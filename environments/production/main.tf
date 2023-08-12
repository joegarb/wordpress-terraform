module "environment" {
    source = "../../modules/fargate"

    site_domain        = var.site_domain
    public_alb_domain  = var.public_alb_domain
    db_master_username = var.db_master_username
    db_master_password = var.db_master_password
}
