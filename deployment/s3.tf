resource "aws_s3_bucket" "yogalates-images-bucket" {
  bucket = "cdn.yogalates.dk"
  acl    = "public-read"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}
