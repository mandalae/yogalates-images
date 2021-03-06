variable "rest_api_id" {
    default = "ul55ggh6oa"
}

variable "images_resource_id" {
    default = "rtiutq"
}

resource "aws_api_gateway_request_validator" "images_request_validator" {
  name                        = "images_request_validator"
  rest_api_id                 = var.rest_api_id
  validate_request_body       = false
  validate_request_parameters = true
}

resource "aws_api_gateway_method" "GET_images" {
  depends_on            = [aws_api_gateway_request_validator.images_request_validator]

  rest_api_id           = var.rest_api_id
  resource_id           = var.images_resource_id
  http_method           = "GET"
  authorization         = "COGNITO_USER_POOLS"
  authorizer_id         = "dsc7wd"
  request_validator_id  = aws_api_gateway_request_validator.images_request_validator.id

  request_parameters = {
    "method.request.header.X-Authorization" = true,
    "method.request.querystring.document" = true,
    "method.request.querystring.mimeType" = false
  }
}

resource "aws_api_gateway_integration" "GET_images_integration" {
  depends_on              = [aws_api_gateway_method.GET_images]
  rest_api_id             = var.rest_api_id
  resource_id             = var.images_resource_id
  http_method             = aws_api_gateway_method.GET_images.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.Yogalates-images.invoke_arn

  cache_key_parameters = ["method.request.querystring.document", "method.request.querystring.mimeType"]
}

resource "aws_api_gateway_method_response" "images_response_200" {
  rest_api_id             = var.rest_api_id
  resource_id             = var.images_resource_id
  http_method             = aws_api_gateway_method.GET_images.http_method
  status_code             = 200

  response_models     = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method" "OPTIONS_images" {
  rest_api_id   = var.rest_api_id
  resource_id   = var.images_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "OPTIONS_images_integration" {
  depends_on              = [aws_api_gateway_method.OPTIONS_images]
  rest_api_id             = var.rest_api_id
  resource_id             = var.images_resource_id
  http_method             = aws_api_gateway_method.OPTIONS_images.http_method
  type                    = "MOCK"

  request_templates = {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
  }
}

resource "aws_api_gateway_method_response" "images_options_response_200" {
  depends_on              = [aws_api_gateway_method.OPTIONS_images]
  rest_api_id             = var.rest_api_id
  resource_id             = var.images_resource_id
  http_method             = aws_api_gateway_method.OPTIONS_images.http_method
  status_code             = 200

  response_models     = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "images_options_integration_response" {
  depends_on = [aws_api_gateway_integration.OPTIONS_images_integration, aws_api_gateway_method_response.images_options_response_200]

  rest_api_id = var.rest_api_id
  resource_id = var.images_resource_id
  http_method = aws_api_gateway_method.OPTIONS_images.http_method
  status_code = aws_api_gateway_method_response.images_options_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token,X-Authorization'",
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_deployment" "Yogalates-API-deployment" {
  depends_on = [aws_api_gateway_integration.GET_images_integration, aws_api_gateway_method_response.images_response_200]

  rest_api_id = var.rest_api_id
  stage_name  = "Prod"

  lifecycle {
    create_before_destroy = true
  }
}
