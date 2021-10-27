### ---------------------------------------------------------------------------------
### Unmanaged docker running on Linux VM - ASC CIS Validation + Alerts
### ---------------------------------------------------------------------------------

# 0 - Connect to Linux box 

# 1 - Install Docker (depends on the distro)
    # https://docs.docker.com/engine/install/ubuntu/
    # https://docs.docker.com/engine/install/centos/
        sudo yum update && sudo yum upgrade
        mkdir Docker
        Set-Location docker # aka cd
        # Check if no previous installations
        sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
        # Installing docker using repositories (automatically updated, etc)
        # set up the repo by installiong yum-utils package
        sudo yum install -y yum-utils
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        # Install Docker Engine (--nobest due to docker being blocker by centos8)
        sudo yum install --nobest docker-ce docker-ce-cli containerd.io # (no best depends on CentOs version)

# 2 - Docker is installed but not started. The docker group is created, but no users are added to the group.
    docker -v
    # Start Docker
    sudo systemctl start docker
    # Verify if docker is running (downloads a test image and runs it in a container that prints info and exits)
    sudo docker run hello-world

# 3 - Get vulnerable image into local docker repo and run it
    # List images
    sudo docker image ls
    # Pull vulnerable image from docker hub https://hub.docker.com/r/vulnerables/web-dvwa/,
    sudo docker pull vulnerables/web-dvwa
    sudo Docker image list
    # Run image (interactive and stop when exit)
    sudo docker run -it vulnerables/web-dvwa
    # Run image in background (detached mode)
    sudo docker run -d -it vulnerables/web-dvwa
    # List running containers
    sudo docker ps -a
    sudo docker container list
    # kill it
    sudo docker contaienr kill CONTAINERID

# After a while, verify Docker CIS assessments in ASC