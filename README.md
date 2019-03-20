# zabbix-mysql-multi
## MySQL Monitoring with Zabbix

#### A simple Zabbix template that i created to monitor the essential MySQL Database metrics for a development environment consisting of 5-10 different database instances on a single box; including snapshots.

Tips: 

1. From an active agent perspective, I would advise against having all metrics from the mysqladmin "extended status" command polled on more than 5 instances per server as there is no caching functionality built into the template, unlike the percona template. Having too many metrics polled will eat away at your CPU very quickly. 
2. Make sure "Include=/etc/zabbix/zabbix_agentd.d/" exists within "zabbix_agentd.conf"
3. You will need to use a MySQL user with the localhost IP address instead of DNS i.e 'zabbix_mysql'@'127.0.0.1' (not 'zabbix_mysql'@'localhost') if you have the "skip_name_resolve" system variable enabled on each MySQL instance. Make sure this user is added to every instance you wish to monitor with all privileges on all databases and tables, otherwise monitoring won't work.

#### Install procedure.

1. Install "mysql-lld-discover.sh" under /etc/zabbix/ ; Make executable and test it.

2. Install "userparameters_mysql_multi.conf" under /etc/zabbix/zabbix_agentd.d/ ; Restart Zabbix Agent. 

```
sudo systemctl restart zabbix-agent
```

If restart fails, you likely have a typo in the .conf file, a user parameter already exists or a key does not work.

3. Install "zabbix" under /etc/sudoers.d/ to allow Zabbix to run the netstat command with the -p flag as root (Best practice is not to edit the sudoers file directly).

4. Install ".multi.cnf" under /etc/zabbix/ ; Change the credentials to those you desire and add the user specified in this file to every MySQL instance you want to monitor if you haven't already (Refer to Tip 3).

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

7. Import the xml template to the Zabbix web interface.

Item and Trigger prototypes are listed under the Templates discovery tab, not items or triggers. 
Once added to a host, Zabbix will start gathering metric data. You might need to restart Zabbix server and/or Agent. Be patient.
