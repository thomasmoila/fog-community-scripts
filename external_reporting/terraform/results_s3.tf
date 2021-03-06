# NOTE: Bucket name must have exact same name as the dns recored, like example.com or box.example.com
resource "aws_s3_bucket" "results_bucket" {
  bucket = "${var.results_name}.${data.terraform_remote_state.base.outputs.zone_name}"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  lifecycle_rule {
    id      = "lifecycle"
    enabled = true
    tags = {
      "rule"      = "lifecycle"
      "autoclean" = "true"
    }
    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }
  }
  tags = {
    Name = "${var.results_name}.${data.terraform_remote_state.base.outputs.zone_name}"
    Project = var.project
  }
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[{
	"Sid":"PublicReadGetObject",
        "Effect":"Allow",
	  "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${var.results_name}.${data.terraform_remote_state.base.outputs.zone_name}/*"
      ]
    }
  ]
}
POLICY
}


# NOTE: the higher-level zone_id is the owned zone_id. The alias zone_ID is the s3 bucket's zone_id.
resource "aws_route53_record" "results_record" {
  zone_id = data.terraform_remote_state.base.outputs.zone_id
  name = "${var.results_name}.${data.terraform_remote_state.base.outputs.zone_name}"
  type = "A"
  alias {
    name = aws_s3_bucket.results_bucket.website_domain
    zone_id = aws_s3_bucket.results_bucket.hosted_zone_id
    evaluate_target_health = false
  }
}


