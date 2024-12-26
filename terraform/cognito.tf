resource "aws_cognito_user_pool" "main" {
  name                     = var.project
  mfa_configuration        = "OFF"
  username_attributes      = ["email"]
  deletion_protection      = "INACTIVE"
  auto_verified_attributes = ["email"] # Cognito will automatically verify the email address
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }
  password_policy {
    minimum_length = 8
  }
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = var.project
  user_pool_id = aws_cognito_user_pool.main.id
}

resource "aws_cognito_user_pool_client" "client" {
  user_pool_id                         = aws_cognito_user_pool.main.id
  name                                 = var.project
  generate_secret                      = true
  explicit_auth_flows                  = ["ALLOW_CUSTOM_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  callback_urls                        = ["http://localhost:8080/authorize"]
  logout_urls                          = ["http://localhost:8080/logout"]
  supported_identity_providers         = ["COGNITO"]
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]
  prevent_user_existence_errors        = "ENABLED"
  allowed_oauth_flows_user_pool_client = true
}

