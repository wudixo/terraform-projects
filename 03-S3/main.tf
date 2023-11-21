resource "aws_s3_bucket" "wudixos3bucket" {

	bucket = "${var.bucket_name}"
	acl = "private"

	versioning {
		enabled = true
	}
}
