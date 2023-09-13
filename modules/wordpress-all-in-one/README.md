# WordPress All-in-One EC2

WordPress and MySQL on a single EC2 using docker compose, suitable for a dev or staging environment only. SSL and SFTP are included, as well as support for using private docker images from ECR. Also, scheduled downtime for cost savings when not in use.

## Features

### SSL

Enable SSL by setting the letsencrypt_email variable before applying. Or after applying, connect to the instance and edit `docker-compose.yml` according to the instructions in that file, and restart the wordpress docker container.

### SSH

One option for shell access is to use EC2 Instance Connect.

Or if you specified a key_name, connect with ssh like:

```
ssh -i {private_key} ec2-user@{site_domain}
```

### SQL

Remote SQL access is available using SSH tunneling.

Create tunnel:
```
ssh -N -L 3308:127.0.0.1:3306 -i {private_key} ec2-user@{site_domain}
```

Connect to database:
```
mysql -h 127.0.0.1 -P 3308 -u wordpress -p
```

### SFTP

SFTP access to the WordPress files requires first launching the SFTP service by running `docker compose --profile sftp up -d` on the EC2 instance.

Then,
```
sftp -P 2222 ftpuser@{site_domain}
```

Credentials are located within docker-compose.yml on the instance or can be specified with variables.

### Scheduled downtime

To save money, the EC2 instance can be scheduled to shut down during specified time periods (such as overnight, weekends, etc). This is configurable via the variables scheduled_start, scheduled_stop, and others.
