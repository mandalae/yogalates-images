#!/usr/bin/env bash
rm plan.tf || true

../terraform init
../terraform import aws_lambda_function.Yogalates-images Yogalates-images || true

../terraform import module.cdn.aws_cloudfront_origin_access_identity.default[0] EIMIIXLMVEYV || true
../terraform import module.cdn.module.logs.aws_s3_bucket.default[0] yogalates-prod-yogalatescdn-logs || true
../terraform import module.cdn.aws_s3_bucket_policy.default[0] yogalates-prod-yogalatescdn-origin || true
../terraform import module.cdn.module.logs.aws_s3_bucket_public_access_block.default[0] yogalates-prod-yogalatescdn-logs || true
../terraform import module.cdn.aws_s3_bucket.origin[0] yogalates-prod-yogalatescdn-origin || true
../terraform import module.cdn.aws_cloudfront_distribution.default E2PAE9UZIO3W9O || true

../terraform import aws_route53_record.cdn ZOIU0SZ2X0UUQ_cdn.yogalates.dk_A || true

../terraform import aws_api_gateway_method.GET_images ul55ggh6oa/rtiutq/GET || true
../terraform import aws_api_gateway_integration.GET_images_integration ul55ggh6oa/rtiutq/GET || true
../terraform import aws_api_gateway_method_response.images_response_200 ul55ggh6oa/rtiutq/GET/200 || true

../terraform import aws_api_gateway_request_validator.images_request_validator ul55ggh6oa/gqp7ro || true

../terraform import aws_api_gateway_method.OPTIONS_images ul55ggh6oa/rtiutq/OPTIONS || true
../terraform import aws_api_gateway_integration.OPTIONS_images_integration ul55ggh6oa/rtiutq/OPTIONS || true
../terraform import aws_api_gateway_method_response.images_options_response_200 ul55ggh6oa/rtiutq/OPTIONS/200 || true
../terraform import aws_api_gateway_integration_response.images_options_integration_response ul55ggh6oa/rtiutq/OPTIONS/200 || true

../terraform plan -out plan.tf
../terraform apply plan.tf
