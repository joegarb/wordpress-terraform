# Wordpress on Fargate

Based on https://github.com/futurice/terraform-examples/tree/master/aws/wordpress_fargate

## Terraform setup

### Initialize

```
terraform init -backend-config=backend.hcl
```

### Create environment

#### Option 1 - using .tfvars

Ensure that a `terraform.tfvars` file has been created locally, similar to the following:
```
site_domain        = "<PUBLIC_DOMAIN>"
public_alb_domain  = "<INTERNAL_DOMAIN_FOR_ALB>"
db_master_username = "<DB_MASTER_USERNAME>"
db_master_password = "<DB_MASTER_PASSWORD>"
```

Then,
```
terraform apply
```

#### Option 2 - using environment variables

```
TF_VAR_site_domain=<PUBLIC_DOMAIN> \
TF_VAR_public_alb_domain=<INTERNAL_DOMAIN_FOR_ALB> \
TF_VAR_db_master_username=<DB_MASTER_USERNAME> \
TF_VAR_db_master_password=<DB_MASTER_PASSWORD> \
terraform apply
```

### Tear down

Ensure that vars are configured using .tfvars or provide them to `terraform destroy` as environment variables, as shown above.

```
terraform destroy
```

## Tips

To connect to a running container:

```
ecs-session wordpress
```

References for enabling ecs-session:  
https://servian.dev/login-to-fargate-containers-the-easy-way-a470ac4d9851  
https://github.com/aws-containers/amazon-ecs-exec-checker
