# WordPress All-in-One EC2

WordPress and MySQL on a single EC2 using docker compose, suitable for a dev or staging environment.

## Terraform setup

### Initialize

```
terraform init -backend-config=backend.hcl
```

### Create environment

Optionally create a `terraform.tfvars` file within the folder where you will run `terraform apply` to override any values from variables.tf, similar to the following:
```
key_name      = "my_key"
instance_type = "t3a.nano"
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

### Connect to the instance

Use EC2 Instance Connect.

Or if you specified a key_name, connect with ssh like:

```
ssh -i {private_key} ec2-user@{ip_address}
```
