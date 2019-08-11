# ------------------
# Certificate Setup
# ------------------
# resource aws_acm_certificate certificate {
#   provider = "aws.us-east-1"
#   // We want a wildcard cert so we can host subdomains later.
#   domain_name = "*.${var.domain_name}"
#   validation_method = "DNS"

#   // We also want the cert to be valid for the root domain even though we'll be
#   // redirecting to the www. domain immediately.
#   subject_alternative_names = [var.domain_name]

#   tags = {
#     Name = var.domain_name
#   }
# }

# resource aws_route53_record cert_validation {
#   provider = "aws.us-east-1"
#   name = aws_acm_certificate.certificate.domain_validation_options.0.resource_record_name
#   type = aws_acm_certificate.certificate.domain_validation_options.0.resource_record_type
#   zone_id = data.aws_route53_zone.zone.id
#   records = [aws_acm_certificate.certificate.domain_validation_options.0.resource_record_value]
#   ttl = 60
# }

# resource aws_acm_certificate_validation cert {
#   provider = "aws.us-east-1"
#   certificate_arn = aws_acm_certificate.certificate.arn
#   validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
# }

# ------------------------
# Cloudfront Distribution
# ------------------------
# resource aws_cloudfront_distribution www_distribution {
#   # The cheapest priceclass
#   price_class = "PriceClass_100"
#   // origin is where CloudFront gets its content from.
#   origin {
#     // We need to set up a "custom" origin because otherwise CloudFront won't
#     // redirect traffic from the root domain to the www domain, that is from
#     // runatlantis.io to www.runatlantis.io.
#     custom_origin_config {
#       // These are all the defaults.
#       http_port = "80"
#       https_port = "443"
#       origin_protocol_policy = "http-only"
#       origin_ssl_protocols = ["TLSv1.2"]
#     }

#     // Here we're using our S3 bucket's URL!
#     domain_name = module.aws_s3_bucket.website_endpoint
#     // This can be any name to identify this origin.
#     origin_id = var.www_domain_name
#   }

#   enabled = true
#   default_root_object = "index.html"

#   // All values are defaults from the AWS console.
#   default_cache_behavior {
#     viewer_protocol_policy = "redirect-to-https"
#     compress = true
#     allowed_methods = ["GET", "HEAD"]
#     cached_methods = ["GET", "HEAD"]
#     // This needs to match the `origin_id` above.
#     target_origin_id = var.www_domain_name
#     min_ttl = 0
#     default_ttl = 36400
#     max_ttl = 46400

#     forwarded_values {
#       query_string = false
#       cookies {
#         forward = "none"
#       }
#     }
#   }

#   // Here we're ensuring we can hit this distribution using www.runatlantis.io
#   // rather than the domain name CloudFront gives us.
#   aliases = [var.www_domain_name]

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   // Here's where our certificate is loaded in!
#   viewer_certificate {
#     acm_certificate_arn = aws_acm_certificate.certificate.arn
#     ssl_support_method = "sni-only"
#   }

#   depends_on = [
#     "aws_acm_certificate.certificate"
#   ]
# }

# resource aws_cloudfront_origin_access_identity origin_access_identity {
#   comment = "Some comment"
# }