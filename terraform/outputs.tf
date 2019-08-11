output webiste_bucket {
  value = module.aws_s3_bucket.id
}

output website_bucket_endpoint {
  value = module.aws_s3_bucket.website_endpoint
}

output access_endpoint {
  value = aws_route53_record.www.fqdn
}
