# zabbix-mysql-multi
## MySQL Monitoring with Zabbix

#### This is a simple template that i use to monitor basic metrics for a development environment consisting of 5-10 instances on a single box.

Tips: 

- If you have little CPU power, i would advise against having all items monitored on more than 5 instances per server as there is no caching functionality built into the discovery script like the percona template.
- You can comment out user parameters and select "Create Disabled" for item prototypes after importing the template. 
- Make sure "Include=/etc/zabbix/zabbix_agentd.d/" exists within "zabbix_agentd.conf"
- You will need to use a MySQL user with the localhost IP such as 'zabbix_mysql'@'127.0.0.1' (not DNS 'localhost') if you have the "skip_name_resolve" system variable enabled on each MySQL instance. Make sure this user is added to every instance otherwise monitoring won't happen.

Install procedure.

1. Install "mysql-lld-discover.sh" under /etc/zabbix/ and make executable.
2. Install "userparameters_mysql_multi.conf" under /etc/zabbix/zabbix_agentd.d/
3. Install "zabbix" under /etc/sudoers.d/ (Best practice is not to edit the sudoers file directly) to allow Zabbix to run the netstat command with the -p flag as root.
4. Install ".multi.cnf" under /etc/zabbix/ changing the credentials to those you desire and add the user specified in this file to every MySQL instance you want to monitor if you haven't already.
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
Item and Trigger prototypes are listed under the Templates discovery tab, not items or triggers.
