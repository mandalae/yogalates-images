module "cdn" {
  source                    = "git::https://github.com/cloudposse/terraform-aws-cloudfront-s3-cdn.git?ref=master"
  namespace                 = "Yogalates"
  stage                     = "prod"
  name                      = "YogalatesCDN"
  aliases                   = ["cdn.yogalates.dk"]
  acm_certificate_arn       = "arn:aws:acm:us-east-1:368263227121:certificate/fe93b48b-58c6-4861-bc1d-2ad96ddd5539"
  parent_zone_id            = "ZOIU0SZ2X0UUQ"
  cors_allowed_methods      = ["GET"]
  cors_allowed_origins      = ["yogalates.dk", "www.yogalates.dk"]
  bucket_domain_format      = "%s.s3.amazonaws.com"
  additional_bucket_policy  = <<POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "PutObjectFromLambda",
              "Effect": "Allow",
              "Principal": {
                  "AWS": "arn:aws:iam::368263227121:role/BasicLambdaRole"
              },
              "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:DeleteObject"
             ],
              "Resource": "arn:aws:s3:::yogalates-prod-yogalatescdn-origin/*"
          },
          {
              "Sid": "S3GetObjectForCloudFront",
              "Effect": "Allow",
              "Principal": {
                  "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity EIMIIXLMVEYV"
              },
              "Action": "s3:GetObject",
              "Resource": "arn:aws:s3:::yogalates-prod-yogalatescdn-origin/*"
          },
          {
              "Sid": "S3ListBucketForCloudFront",
              "Effect": "Allow",
              "Principal": {
                  "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity EIMIIXLMVEYV"
              },
              "Action": "s3:ListBucket",
              "Resource": "arn:aws:s3:::yogalates-prod-yogalatescdn-origin"
          }
      ]
    }
    POLICY
}
