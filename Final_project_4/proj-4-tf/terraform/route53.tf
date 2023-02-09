data "aws_route53_zone" "my_hosted_zone" {
  name = "anpod.tk."
}

#output "my_tf_route53_zone" {
#  value = data.aws_route53_zone.my_hosted_zone.zone_id
#}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "a_record_pyapp" {
  zone_id = "${data.aws_route53_zone.my_hosted_zone.zone_id}"
  name    = "pyapp.anpod.tk"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.TF_elastic_ip.public_ip}"]
}

