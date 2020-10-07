resource "aws_api_gateway_rest_api" "Yogalates" {
  name        = "Yogalates"
}

resource "aws_api_gateway_resource" "Yogalates-images" {
  rest_api_id = aws_api_gateway_rest_api.Yogalates.id
  parent_id   = aws_api_gateway_rest_api.Yogalates.root_resource_id
  path_part   = "images"
}

resource "aws_api_gateway_method" "GET_images" {
  rest_api_id   = aws_api_gateway_rest_api.Yogalates.id
  resource_id   = aws_api_gateway_resource.Yogalates-images.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "dsc7wd"

  request_parameters = {
    "method.request.header.X-Authorization" = true
  }
}

resource "aws_api_gateway_integration" "GET_images_integration" {
  depends_on              = [aws_api_gateway_method.GET_images]
  rest_api_id             = aws_api_gateway_rest_api.Yogalates.id
  resource_id             = aws_api_gateway_resource.Yogalates-images.id
  http_method             = aws_api_gateway_method.GET_images.http_method
  integration_http_method = aws_api_gateway_method.GET_images.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.Yogalates-images.invoke_arn
}

resource "aws_api_gateway_deployment" "Yogalates-API-deployment" {
  depends_on = [aws_api_gateway_integration.GET_images_integration]

  rest_api_id = aws_api_gateway_rest_api.Yogalates.id
  stage_name  = "prod"

  lifecycle {
    create_before_destroy = true
  }
}
