provider aws {
  region  = var.region
  version = ">= 2.23.0"

  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

provider aws {
  alias   = "us-east-1"
  region  = "us-east-1"
  version = ">= 2.23.0"

  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}