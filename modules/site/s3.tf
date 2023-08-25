resource "aws_s3_bucket" "static_website" {
  bucket_prefix = "trial-site"
  tags = {
    Name = "trial-site"
  }
}
