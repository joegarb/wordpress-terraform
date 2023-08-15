# WordPress on Fargate

WordPress on Fargate/ECS with autoscaling and RDS, suitable for a production deployment.

Originally based on https://github.com/futurice/terraform-examples/tree/master/aws/wordpress_fargate

## Tips

### View logs

Enable debugging with the `wp_debug` variable, and then WordPress logs will be directed to Cloudwatch by default.

### Connect to a running container

```
ecs-session wordpress
```

References for enabling ecs-session:  
https://servian.dev/login-to-fargate-containers-the-easy-way-a470ac4d9851  
https://github.com/aws-containers/amazon-ecs-exec-checker
