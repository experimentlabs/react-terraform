variable region {
  description = "Region where to deploy infrastructure"
}

variable www_domain_name {
  default = "www.photostampsonline.com"
}

variable domain_name {
  default = "photostampsonline.com"
}

locals {
  bucket_name = var.www_domain_name
}
