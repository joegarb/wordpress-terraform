# Wordpress on Fargate

Based on https://github.com/futurice/terraform-examples/tree/master/aws/wordpress_fargate

## Terraform setup

## Initialize terraform environment

```
terraform init -backend-config="bucket=<BUCKET_NAME>"
```

### Create environment

```
  AWS_SDK_LOAD_CONFIG=1 \
  TF_VAR_site_domain=<PUBLIC_DOMAIN> \
  TF_VAR_public_alb_domain=<INTERNAL_DOMAIN_FOR_ALB> \
  TF_VAR_db_master_username=<DB_MASTER_USERNAME> \
  TF_VAR_db_master_password="<DB_MASTER_PASSWORD>" \
  terraform apply
```

### Tear down

```
  AWS_SDK_LOAD_CONFIG=1 \
  TF_VAR_site_domain=<PUBLIC_DOMAIN> \
  TF_VAR_public_alb_domain=<INTERNAL_DOMAIN_FOR_ALB> \
  TF_VAR_db_master_username=<DB_MASTER_USERNAME> \
  TF_VAR_db_master_password="<DB_MASTER_PASSWORD>" \
  terraform destroy
```

Instead of environment variables, you can use .tfvar files for assigning values to terraform variables.

## Tips

To connect to a running container:

```
ecs-session wordpress
```

References for enabling ecs-session:  
https://servian.dev/login-to-fargate-containers-the-easy-way-a470ac4d9851  
https://github.com/aws-containers/amazon-ecs-exec-checker
