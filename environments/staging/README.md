# Staging environments 

Staging environments running on individual WordPress all-in-one EC2 instances.

## Terraform setup

### Initialize

Navigate into one of the individual staging environment folders, such as `staging1`.

Then,
```
terraform init
```

### Create environment

Edit `variables.tf` to override any of the default values. `site_domain` is the only required variable, but you will likely want to also set `letsencrypt_email` to enable SSL. Review variables.tf for all the variables that can be specified.

Then,
```
terraform apply
```

### Tear down

```
terraform destroy
```

## More information

See `/modules/ec2/README.md` for more details.
