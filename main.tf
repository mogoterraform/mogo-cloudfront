provider "aws" {
  region = "ca-central-1"
}

#creating AWS CloudFront distribution :
resource "aws_cloudfront_distribution" "main_dist" {
  enabled             = true
  aliases             = [var.domain_alias]

  dynamic "origin" {
    for_each = var.origins
    content {
      domain_name = origin.value
      origin_id = var.origin_ids[origin.key]
      custom_origin_config {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  default_cache_behavior {
    allowed_methods        = ["HEAD", "GET", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["HEAD", "GET", "OPTIONS"]
    target_origin_id       = "staging"
    viewer_protocol_policy = "redirect-to-https" # other options - https only, http
    forwarded_values {
      headers      = ["Origin"]
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }
  ordered_cache_behavior {
    path_pattern     = "/privacy-policy/*"
    allowed_methods  = ["HEAD", "GET", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["HEAD", "GET", "OPTIONS"]
    target_origin_id = "mokaweb"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "all"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:784932190261:certificate/b36a745f-dc72-4f1c-bdf4-305f1b4b9271" 
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
}
