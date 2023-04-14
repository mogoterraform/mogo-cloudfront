provider "aws" {
  region = "ca-central-1"
}

data "aws_cloudfront_cache_policy" "CachingPolicy" {
  name = var.cachepol
}

data "aws_cloudfront_origin_request_policy" "OriginRequest" {
  name = var.originpol
}



#creating AWS CloudFront distribution :
resource "aws_cloudfront_distribution" "main_dist" {
  enabled = true
  aliases = [var.domain_alias]
  comment = var.domain_alias

  dynamic "origin" {
    for_each = var.origins
    content {
      domain_name = origin.value
      origin_id   = var.origin_ids[origin.key]
      custom_origin_config {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  default_cache_behavior {
    allowed_methods           = ["HEAD", "GET", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods            = ["HEAD", "GET", "OPTIONS"]
    target_origin_id          = var.origin_ids[0]
    viewer_protocol_policy    = "redirect-to-https" # other options - https only, http
    cache_policy_id           = data.aws_cloudfront_cache_policy.CachingPolicy.id
    origin_request_policy_id  = data.aws_cloudfront_origin_request_policy.OriginRequest.id
    }
  

  dynamic "ordered_cache_behavior" {
    for_each = var.patterns
    content {
      path_pattern     = ordered_cache_behavior.value
      allowed_methods  = ["HEAD", "GET", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
      cached_methods   = ["HEAD", "GET", "OPTIONS"]
      target_origin_id = var.origin_ids[1]
      cache_policy_id           = data.aws_cloudfront_cache_policy.CachingPolicy.id
      origin_request_policy_id  = data.aws_cloudfront_origin_request_policy.OriginRequest.id


      min_ttl                = 0
      default_ttl            = 86400
      max_ttl                = 31536000
      compress               = true
      viewer_protocol_policy = "redirect-to-https"
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = var.cert_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
}
