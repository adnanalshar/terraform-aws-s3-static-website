# Cloudfront distribution for main s3 site.
resource "aws_cloudfront_distribution" "www_s3_distribution" {
  origin {
    #domain_name = aws_s3_bucket.www_bucket.website_endpoint
    domain_name = aws_s3_bucket_website_configuration.static_website_s3_buckets.website_endpoint
    origin_id   = "S3-www.${var.bucket_name}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["www.${var.domain_name}"]

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 200
    response_page_path    = "/404.jpeg"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-www.${var.bucket_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 31536000
    default_ttl            = 31536000
    max_ttl                = 31536000
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.cert_validation.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # - Challenge: resolve Checkov issues -
  #checkov:skip=CKV_AWS_68: "CloudFront Distribution should have WAF enabled"
  #checkov:skip=CKV_AWS_310: "Ensure CloudFront distributions should have origin failover configured"
  #checkov:skip=CKV_AWS_34: "Ensure CloudFront distribution ViewerProtocolPolicy is set to HTTPS"
  #checkov:skip=CKV_AWS_305: "Ensure CloudFront distribution has a default root object configured"
  #checkov:skip=CKV_AWS_86: "Ensure CloudFront distribution has Access Logging enabled"
  #checkov:skip=CKV2_AWS_32: "Ensure CloudFront distribution has a response headers policy attached"
  #checkov:skip=CKV2_AWS_47: "Ensure AWS CloudFront attached WAFv2 WebACL is configured with AMR for Log4j Vulnerability"
  #checkov:skip=CKV2_AWS_46: "Ensure AWS CloudFront Distribution with S3 have Origin Access set to enabled"
}

# Cloudfront S3 for redirect to www.
resource "aws_cloudfront_distribution" "root_s3_distribution" {
  origin {
    domain_name = aws_s3_bucket_website_configuration.root_s3_buckets.website_endpoint
    origin_id   = "S3-.${var.bucket_name}"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true

  aliases = [var.domain_name]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-.${var.bucket_name}"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }

      headers = ["Origin"]
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.cert_validation.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # - Challenge: resolve Checkov issues -
  #checkov:skip=CKV_AWS_68: "CloudFront Distribution should have WAF enabled"
  #checkov:skip=CKV_AWS_310: "Ensure CloudFront distributions should have origin failover configured"
  #checkov:skip=CKV_AWS_34: "Ensure CloudFront distribution ViewerProtocolPolicy is set to HTTPS"
  #checkov:skip=CKV_AWS_305: "Ensure CloudFront distribution has a default root object configured"
  #checkov:skip=CKV_AWS_86: "Ensure CloudFront distribution has Access Logging enabled"
  #checkov:skip=CKV2_AWS_32: "Ensure CloudFront distribution has a response headers policy attached"
  #checkov:skip=CKV2_AWS_47: "Ensure AWS CloudFront attached WAFv2 WebACL is configured with AMR for Log4j Vulnerability"
  #checkov:skip=CKV2_AWS_46: "Ensure AWS CloudFront Distribution with S3 have Origin Access set to enabled"
}
