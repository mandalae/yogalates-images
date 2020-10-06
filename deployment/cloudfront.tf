module "cdn" {
  source                = "git::https://github.com/cloudposse/terraform-aws-cloudfront-s3-cdn.git?ref=master"
  namespace             = "Yogalates"
  stage                 = "prod"
  name                  = "YogalatesCDN"
  aliases               = ["cdn.yogalates.dk"]
  acm_certificate_arn   = "arn:aws:acm:us-east-1:368263227121:certificate/fe93b48b-58c6-4861-bc1d-2ad96ddd5539"
  parent_zone_id        = "ZOIU0SZ2X0UUQ"
  cors_allowed_methods  = ["GET", "PUT"]
  cors_allowed_origins  = ["yogalates.dk", "www.yogalates.dk"]
  bucket_domain_format  = "%s.eu-west-1.s3.amazonaws.com"
}
