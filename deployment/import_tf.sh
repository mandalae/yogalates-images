#!/usr/bin/env bash
rm plan.tf || true

../terraform init
../terraform import aws_lambda_function.Yogalates-images Yogalates-images || true

../terraform import module.cdn.aws_cloudfront_origin_access_identity.default[0] EIMIIXLMVEYV || true
../terraform import module.cdn.module.logs.aws_s3_bucket.default[0] yogalates-prod-yogalatescdn-origin || true
../terraform import module.cdn.aws_s3_bucket_policy.default[0] yogalates-prod-yogalatescdn-logs || true
../terraform import module.cdn.module.logs.aws_s3_bucket_public_access_block.default[0] yogalates-prod-yogalatescdn-logs || true
../terraform import module.cdn.aws_cloudfront_distribution.default E2PAE9UZIO3W9O || true

../terraform plan -out plan.tf
../terraform apply plan.tf
