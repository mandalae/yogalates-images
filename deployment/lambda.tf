provider "aws" {
  region = "eu-west-1"
}

resource "aws_lambda_permission" "Yogalates-images" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.Yogalates-images.function_name}"
  principal     = "apigateway.amazonaws.com"
}

resource "aws_lambda_function" "Yogalates-images" {
  filename      = "../artifact/artifact.zip"
  function_name = "Yogalates-images"
  role          = "arn:aws:iam::368263227121:role/BasicLambdaRole"
  handler       = "index.handler"
  source_code_hash = "${filebase64sha256("../artifact/artifact.zip")}"
  runtime       = "nodejs12.x"
  
  source_arn = "arn:aws:execute-api:eu-west-1:368263227121:${var.rest_api_id.value}/*/${aws_api_gateway_method.GET_images.http_method}${aws_api_gateway_resource.Yogalates-images.path}"
}
