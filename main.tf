#Create S3 bucket

resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}


resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.mybucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.mybucket.arn}/*"
      }
    ]
  })
}


resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "index.html"
  source = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "error.html"
  source = "error.html"
  content_type = "text/html"
}

resource "aws_s3_object" "style" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "style.css"
  source = "style.css"
  content_type = "text/css"
}

resource "aws_s3_object" "myPicture" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "myPicture.jpg"
  source = "myPicture.jpg"
}

resource "aws_s3_object" "cloudImage"{
  bucket = aws_s3_bucket.mybucket.id
  key    = "cloudImage.jpg"
  source = "cloudImage.jpg"
}

resource "aws_s3_object" "heroImage"{
  bucket = aws_s3_bucket.mybucket.id
  key    = "heroImage.jpg"
  source = "heroImage.jpg"
}


resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [aws_s3_bucket_policy.public_read_policy]
}
