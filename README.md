# zabbix-mysql-multi
## MySQL Monitoring with Zabbix

#### This is a base build that i used to monitor basic metrics for my development environment.

Tips: 

- If you have little CPU power, i would advise against having all items monitored on more than 5 instances per server as there is no caching functionality built into the discovery script.  
- You can comment out user parameters and select "Create Disabled" for item prototypes after importing the template. 
- Make sure "Include=/etc/zabbix/zabbix_agentd.d/" exists within "zabbix_agentd.conf"

Install procedure.

1. Install "mysql-lld-discover.sh" under /etc/zabbix/ and make executable.
2. Install "userparameters_mysql_multi.conf" under /etc/zabbix/zabbix_agentd.d/
3. Install "zabbix" under /etc/sudoers.d/ (Best practice is not to edit the sudoers file directly) to allow Zabbix to run the netstat command with the -p flag as root.
4. Install ".multi.cnf" under /etc/zabbix/ changing the credentials and make sure you have the same user on each MySQL instance with all privileges.
5. Test the script on the agent.
```
zabbix_agentd -t mysql.questions[3306]
zabbix_agentd -t mysql.questions[3307]
zabbix_agentd -t mysql.questions[3308]
```
6. Test the script on the server.
```
zabbix_get -s <agent-ip> -P <zabbix-agent-port> -k mysql.questions[3306]
zabbix_get -s <agent-ip> -P <zabbix-agent-port> -k mysql.questions[3307]
zabbix_get -s <agent-ip> -P <zabbix-agent-port> -k mysql.questions[3308]
```
7. Import Template in the Zabbix web interface.
