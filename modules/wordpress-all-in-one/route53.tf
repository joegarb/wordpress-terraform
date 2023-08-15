data "aws_route53_zone" "this" {
  name = replace(var.site_domain, "/.*\\b(\\w+\\.\\w+)\\.?$/", "$1") # gets domain from subdomain e.g. "foo.example.com" => "example.com"
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.site_domain
  type    = "A"
  ttl     = "300"
  records = [aws_instance.this.public_ip]
}
