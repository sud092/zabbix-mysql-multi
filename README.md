# zabbix-mysql-multi
## MySQL Monitoring with Zabbix

#### A simple MySQL template i created to monitor basic metrics for a development environment consisting of 5-10 instances on a single box.

Tips: 

1. From an active agent perspective, I would advise against having all metrics from the mysqladmin "extended status" command polled on more than 5 instances per server as there is no caching functionality built into the template, unlike the percona template. Having too many metrics polled will eat away at your CPU very quickly. 
2. Make sure "Include=/etc/zabbix/zabbix_agentd.d/" exists within "zabbix_agentd.conf"
3. You will need to use a MySQL user with the localhost IP address instead of DNS i.e 'zabbix_mysql'@'127.0.0.1' (not 'zabbix_mysql'@'localhost') if you have the "skip_name_resolve" system variable enabled on each MySQL instance. Make sure this user is added to every instance with all privileges on all databases and tables, otherwise monitoring won't work.

Install procedure.

1. Install "mysql-lld-discover.sh" under /etc/zabbix/ and make executable.
2. Install "userparameters_mysql_multi.conf" under /etc/zabbix/zabbix_agentd.d/
3. Install "zabbix" under /etc/sudoers.d/ to allow Zabbix to run the netstat command with the -p flag as root (Best practice is not to edit the sudoers file directly).
4. Install ".multi.cnf" under /etc/zabbix/ changing the credentials to those you desire and add the user specified in this file to every MySQL instance you want to monitor if you haven't already (Refer to Tip 3).
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
