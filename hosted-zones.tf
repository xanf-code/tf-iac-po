resource "aws_route53_zone" "po_hosted_zones" {
  name = var.domain_name_hosted_zone

}

resource "aws_route53_record" "www_po_simple" {
  zone_id = aws_route53_zone.po_hosted_zones.zone_id
  name    = var.domain_name_hosted_zone
  type    = "A"
  alias {
    name                   = aws_lb.po-load-balancer.dns_name
    zone_id                = aws_lb.po-load-balancer.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www_po_CNAME" {
  zone_id = aws_route53_zone.po_hosted_zones.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = 300
  records = [var.domain_name_hosted_zone]
}

# resource "aws_route53_record" "po_cert_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.po-cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }
#   zone_id = aws_route53_zone.po_hosted_zones.zone_id
#   name    = each.value.name
#   type    = each.value.type
#   ttl     = 300
#   records = [each.value.record]
# }