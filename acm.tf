# resource "aws_acm_certificate" "po-cert" {
#   domain_name       = "*.${var.domain_name_hosted_zone}"
#   validation_method = "DNS"
# }

# resource "aws_acm_certificate_validation" "cert_validation" {
#   certificate_arn         = aws_acm_certificate.po-cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.po_cert_validation : record.fqdn]

#   lifecycle {
#     prevent_destroy = true
#   }
# }