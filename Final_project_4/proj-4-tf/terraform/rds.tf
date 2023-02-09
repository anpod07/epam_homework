# ================== Create RDS ==================

resource "aws_db_subnet_group" "rds_private_subnet" {
  name = "tf_proj_4_rds_private_subnet_group"
  subnet_ids = ["${aws_subnet.private_subnets[0].id}", "${aws_subnet.private_subnets[1].id}"]
  tags = {
    Name  = "TF_proj_4_RDS_subnet_group"
    owner = "ninja"
  }
}

resource "aws_security_group" "SG_4_tf_rds" {
  name        = "TF_proj_4_MYSQL"
  description = "GS for TF RDS-MySQL"
  vpc_id      = aws_vpc.TF_VPC_proj_4.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.80.0.0/22"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "TF_proj_4_SG_RDS"
    owner = "ninja"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
resource "aws_db_instance" "my_test_mysql" {
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = false
  port                        = 3306
  allocated_storage           = 20
  max_allocated_storage       = 0
  identifier                  = "rds-mysql"
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "8.0.28"
  instance_class              = "db.t3.micro"
  #db_name                     = "tfrdstestmysql"
  username                    = "admin"
  password                    = "07secret07"
  parameter_group_name        = "default.mysql8.0"
  db_subnet_group_name        = "${aws_db_subnet_group.rds_private_subnet.name}"
  vpc_security_group_ids      = ["${aws_security_group.SG_4_tf_rds.id}"]
  multi_az                    = false
  skip_final_snapshot         = true
  publicly_accessible         = false
  tags = {
    Name  = "TF_proj_4_RDS_MySQL"
    owner = "ninja"
  }
}




