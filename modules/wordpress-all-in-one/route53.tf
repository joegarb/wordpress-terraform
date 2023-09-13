data "aws_route53_zone" "this" {
  name = replace(var.site_domain, "/.*\\b(\\w+\\.\\w+)\\.?$/", "$1") # gets domain from subdomain e.g. "foo.example.com" => "example.com"
}

# This is initially just a placeholder; IP and TTL will get updated by a script each time the instance boots up. This can't get the IP initially because it would create a circular dependency for terraform with the script.
resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.site_domain
  type    = "A"
  ttl     = "1"
  records = ["127.0.0.1"]
}
