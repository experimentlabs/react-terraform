# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A AWS Cloudfront Distribution, server content from PRIVATE Bucket IN AWS CLOUD PLATFORM
# This is an example of how to use the the module
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # The modules used in this example have been updated with 0.12 syntax, which means the example is no longer
  # compatible with any versions below 0.12.
  required_version = ">= 0.12"
}


module aws_s3_bucket {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "v0.0.1"
  bucket  = local.bucket_name
  acl     = "private"
  policy = templatefile("${path.module}/config/webhost-bucket-policy.json", {
    bucket_name = local.bucket_name
  })

  website_inputs = [
    {
      index_document           = "index.html"
      error_document           = "error.html"
      redirect_all_requests_to = null
      routing_rules            = <<EOF
    [{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
    }]
    EOF
    }
  ]

  versioning_inputs = [
    {
      enabled = true
      mfa_delete = null
    },
  ]
}


# ------------------------
# Route 53 Setup
# ------------------------
resource aws_route53_record www {
  zone_id = data.aws_route53_zone.zone.id
  name = var.www_domain_name
  type = "A"

  alias {
    name = module.aws_s3_bucket.website_domain
    zone_id = module.aws_s3_bucket.hosted_zone_id
    evaluate_target_health = false
  }
}
