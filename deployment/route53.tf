resource "aws_route53_record" "cdn" {
  zone_id = "ZOIU0SZ2X0UUQ"
  name    = "cdn.yogalates.dk"
  type    = "A"

  alias {
    name                   = module.cdn.cf_domain_name
    zone_id                = module.cdn.cf_hosted_zone_id
    evaluate_target_health = false
  }
}
