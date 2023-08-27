resource "aws_s3_bucket" "static_website" {
  bucket_prefix = "trial-site"
  tags = {
    Name = "trial-site"
  }
}

resource "aws_s3_bucket_policy" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  policy = data.aws_iam_policy_document.static_website.json
}

data "aws_iam_policy_document" "static_website" {
  statement {
    sid    = "Aollow Cloudfront"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.static_website.iam_arn
      ]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.static_website.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  rule {
    # 約半年
    id     = "181日経過で削除"
    status = "Enabled"
    expiration {
      # 約半年
      days = 180
    }
    noncurrent_version_expiration {
      noncurrent_days = 1
    }
  }
}
