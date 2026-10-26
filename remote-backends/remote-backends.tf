#S3 bucket to handle statefile

resource "aws_s3_bucket" "remote-s3-bucket" {
  bucket = "hjinfotech-remote-bucket"

  tags = {
    Name = "hjinfotech-remote-bucket"
  }
}

#dynamodb
resource "aws_dynamodb_table" "remote-dynamodb-table" {
  name           = "hjinfotech-remote-table"
  billing_mode="PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
