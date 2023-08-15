module "environment" {
    source = "../../modules/wordpress-enterprise"

    environment        = var.environment
    site_domain        = var.site_domain
    public_alb_domain  = var.public_alb_domain
}
