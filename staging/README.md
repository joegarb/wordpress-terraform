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

Then,
```
terraform apply
```

### Tear down

```
terraform destroy
```

## Tips

### SSL

Enable SSL by setting the letsencrypt_email variable before applying. Or after applying, connect to the instance and edit `docker-compose.yml` according to the instructions in that file, and restart the wordpress docker container.

### Connect to the instance

Use EC2 Instance Connect.

Or if you specified a key_name, connect with ssh like:

```
ssh -i {private_key} ec2-user@{ip_address}
```

FTP access to WordPress files is also available on port 2222. Credentials can be located within docker-compose.yml on the EC2 instance.
