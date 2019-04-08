# zabbix-mysql-multi
## MySQL Monitoring with Zabbix

#### A simple Zabbix template i created to monitor essential MySQL Database metrics for an environment consisting of 5-10 different database instances on a single server. I can't guarantee this will work on zabbix versions other than 3.4.

Before installation: 

1. If you want to use active monitoring, i would advise against having all metrics from the mysqladmin "extended status" command polled on more than 5 instances per server as there is no caching functionality built into this template; unlike the percona template. Having too many metrics polled on many MySQL instances will eat away at your CPU, particularly if you have a lot of insances on a single box and only one CPU.
 
2. Make sure "Include=/etc/zabbix/zabbix_agentd.d/" exists within the agent's "zabbix_agentd.conf" configuration file.

3. You will need to create a dedicated MySQL user with the localhost IP address instead of DNS i.e 'zabbix_mysql'@'127.0.0.1' (not 'zabbix_mysql'@'localhost') if you have the "skip_name_resolve" system variable enabled on each MySQL instance. Make sure this user is added to every instance you wish to monitor with all privileges on all databases and tables, otherwise monitoring won't work.

#### Install procedure.

1. Install "mysql-lld-discover.sh" under /etc/zabbix/ ; Make executable and test it returns the port numbers .

2. Install "userparameters_mysql_multi.conf" under /etc/zabbix/zabbix_agentd.d/ ; Check that you can execute these commands as the zabbix user, then restart zabbix-agent. 

```
sudo systemctl restart zabbix-agent
```

If restart fails, check you don't have any typos in the .conf file and if the same item keys exist elsewhere.

3. Install "zabbix" under /etc/sudoers.d/ to allow Zabbix to run the netstat command with the -p flag as root (Best practice is to use visudo).

```
visudo -f zabbix
```

4. Install ".multi.cnf" under /etc/zabbix/ ; Change the credentials to those you desire and make sure this user+password is added to all your mysql instances that you wish to monitor (Refer to Tip 3).

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
