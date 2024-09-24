#!/bin/bash

# run the following command to check your aws profiles
# --> aws configure list-profiles

# run this command to create profiles if you need
# --> aws configure --profile <aws-account-id>



regions=("eu-west-1" "us-east-1")  # Add all the regions you're interested in
profiles=("account1" "account2")   # Add all the profiles you're using

# Initialize variable to store the total number of vCPUs across all clusters
total_vcpus_all_clusters=0

for profile in "${profiles[@]}"; do
    echo "Checking EKS Clusters in profile: $profile"
    for region in "${regions[@]}"; do
        clusters=$(aws eks list-clusters --profile $profile --region $region --query 'clusters[*]' --output text)
        for cluster in $clusters; do
            echo "Cluster: $cluster in $region"
            instance_ids=$(aws ec2 describe-instances \
              --filters "Name=tag:kubernetes.io/cluster/$cluster,Values=owned" \
              --query 'Reservations[*].Instances[*].InstanceId' \
              --profile $profile --region $region --output text)

            total_vcpus=0  # Initialize total for the current cluster

            for instance_id in $instance_ids; do
                # Get the core count and threads per core
                instance_info=$(aws ec2 describe-instances --instance-ids $instance_id --profile $profile --region $region \
                  --query 'Reservations[*].Instances[*].[InstanceId, InstanceType, CpuOptions.CoreCount, CpuOptions.ThreadsPerCore]' \
                  --output text)

                # Extract core count and threads per core from instance_info
                core_count=$(echo $instance_info | awk '{print $3}')
                threads_per_core=$(echo $instance_info | awk '{print $4}')

                # Calculate the number of vCPUs (cores * threads per core)
                if [[ -n $core_count && -n $threads_per_core ]]; then
                    vcpus=$((core_count * threads_per_core))
                    total_vcpus=$((total_vcpus + vcpus))
                fi
            done

            echo "Total vCPUs for cluster $cluster in region $region: $total_vcpus"
            total_vcpus_all_clusters=$((total_vcpus_all_clusters + total_vcpus))  # Add to overall total
        done
    done
done

# Output the total number of vCPUs across all clusters
echo "Total vCPUs across all clusters: $total_vcpus_all_clusters"

