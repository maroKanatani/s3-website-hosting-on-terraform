resource "aws_cloudfront_distribution" "static_website" {
  origin {
    domain_name = aws_s3_bucket.static_website.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.static_website.id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.static_website.cloudfront_access_identity_path
    }
  }

  enabled             = true
  default_root_object = "index.html"
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_s3_bucket.static_website.id

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 60
    default_ttl            = 60
    max_ttl                = 60
    compress               = true

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.basic_auth.arn
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_identity" "static_website" {
  comment = "Allow Cloudfront to access the website bucket"
}

output "website_url" {
  value = "https://${aws_cloudfront_distribution.static_website.domain_name}/"
}

# Basic 認証を行う CloudFront Function
resource "aws_cloudfront_function" "basic_auth" {
  name    = "static-website-basicauth"
  runtime = "cloudfront-js-1.0"
  publish = true
  code = templatefile(
    "${path.module}/function/basic-auth.js",
    {
      authString = base64encode("${var.basicauth_username}:${var.basicauth_password}")
    }
  )
}