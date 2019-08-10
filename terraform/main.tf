locals {
  bucket_name = "s3-example-website"
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
