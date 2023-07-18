# WordPress All-in-One EC2

WordPress and MySQL on a single EC2 using docker compose, suitable for a dev or staging environment. SSL and FTP are also included.

## Terraform setup

### Initialize

```
terraform init -backend-config=backend.hcl
```

### Create environment

Create a `terraform.tfvars` file within the folder where you will run `terraform apply` to override any values from variables.tf, like:
```
site_domain = "example.com"
```

`site_domain` is the only required variable, but you will likely want to also set `letsencrypt_email` to enable SSL. Review variables.tf for all the variables that can be specified.

Then,
```
terraform apply
```

### Tear down

```
terraform destroy
```

## More information

### SSL

Enable SSL by setting the letsencrypt_email variable before applying. Or after applying, connect to the instance and edit `docker-compose.yml` according to the instructions in that file, and restart the wordpress docker container.

### SSH

One option for shell access is to use EC2 Instance Connect.

Or if you specified a key_name, connect with ssh like:

```
ssh -i {private_key} ec2-user@{site_domain}
```

### FTP

FTP access to the WordPress files is available on port 2222. Credentials can be located within docker-compose.yml on the EC2 instance or customized with a terraform variable.

```
sftp -P 2222 ftpuser@{site_domain}
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
