module "environment" {
    source = "../../../modules/wordpress-all-in-one"

    site_domain             = var.site_domain
    letsencrypt_email       = var.letsencrypt_email
    environment             = var.environment
    tags                    = var.tags
    instance_type           = var.instance_type
    key_name                = var.key_name
    image                   = var.image
    db_username             = var.db_username
    db_password             = var.db_password
    wp_debug                = var.wp_debug
    wp_debug_log            = var.wp_debug_log
    wp_extra                = var.wp_extra
    scheduled_stop_enabled  = var.scheduled_stop_enabled
    scheduled_stop_timezone = var.scheduled_stop_timezone
    scheduled_start         = var.scheduled_start
    scheduled_stop          = var.scheduled_stop
    sftp_username           = var.sftp_username
    sftp_password           = var.sftp_password
}
