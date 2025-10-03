resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "alb_logs" {
  bucket = "${var.project_name}-alb-logs-${random_id.bucket_suffix.hex}"
  acl    = "private"
}
