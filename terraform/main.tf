provider "aws" {
  region = "us-east-1"
}

# Create EBS volume
resource "aws_ebs_volume" "mysql_data" {
  availability_zone = var.instance_az
  size              = var.ebs_size_gb
  type              = "gp3"

  tags = {
    Name = "mysql-persistence-storage"
  }
}

# Attach EBS volume to existing EC2 instance
resource "aws_volume_attachment" "attach_mysql_data" {
  device_name = var.ebs_device_name
  volume_id   = aws_ebs_volume.mysql_data.id
  instance_id = var.instance_id

  force_detach = false
}

# Create S3 bucket
resource "aws_s3_bucket" "mysql_backup" {
  bucket = "my-mysql-backup-prod"
  force_destroy = true
}

# Policy for EC2 to upload to S3
resource "aws_iam_policy" "s3_backup_policy" {
  name = "mysql-backup-to-s3-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["s3:PutObject", "s3:ListBucket", "s3:GetObject"],
        Effect   = "Allow",
        Resource = [
          "arn:aws:s3:::my-mysql-backup-prod",
          "arn:aws:s3:::my-mysql-backup-prod/*"
        ]
      }
    ]
  })
}

# IAM role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "mysql-backup-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = { Service = "ec2.amazonaws.com" },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_backup_policy.arn
}
