output "my_tf_ec2_elastic_ip" {
  value = aws_eip.TF_elastic_ip.public_ip
}

output "my_tf_rds_address" {
  value = aws_db_instance.my_test_mysql.address
}

