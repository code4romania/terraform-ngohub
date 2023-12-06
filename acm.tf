resource "aws_acm_certificate" "regional" {
  validation_method = "DNS"
  domain_name       = var.root_domain
  subject_alternative_names = [
    "*.${var.root_domain}",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "regional_acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.regional.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.zone_id
}

# us-east-1
resource "aws_acm_certificate" "global" {
  provider          = aws.acm
  validation_method = "DNS"
  domain_name       = var.root_domain
  subject_alternative_names = [
    "*.${var.root_domain}",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "global_acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.global.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.zone_id
}
