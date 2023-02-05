resource "aws_route53_zone" "hosted_zone" {
  name = var.domain.domain
}

resource "aws_route53_record" "subdomain" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = var.domain.subdomain
  type    = var.domain.type

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name               = var.cert.cert_1.domain
  subject_alternative_names = ["*.${var.cert.cert_1.domain}"]
  validation_method         = var.cert.cert_1.validation_method

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cname_validate" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
    }
  }



  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.domain_data.zone_id
}

resource "aws_acm_certificate_validation" "acm_validate" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cname_validate : record.fqdn]
}
