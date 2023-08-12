# Production environment

Production WordPress environment running on Fargate/ECS with autoscaling and RDS.

## Terraform setup

### Initialize

```
terraform init
```

### Create environment

Edit `variables.tf` to override any of the default values.

Then,
```
terraform apply
```

### Tear down

```
terraform destroy
```

## More information

See `/modules/fargate/README.md` for more details.
