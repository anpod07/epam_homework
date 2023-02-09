provider "aws" {
  region = "eu-central-1"
}

# ================== Create EC2 ==================

data "aws_ami" "ubuntu_22_latest" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "my_tf_ec2" {
  ami                     = data.aws_ami.ubuntu_22_latest.id
  instance_type           = "t2.micro"
  key_name                = aws_key_pair.ssh_ec2_key.id
  subnet_id               = aws_subnet.public_subnets[0].id
  vpc_security_group_ids  = [aws_security_group.my_sg_4_tf_ec2.id]
  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = 8
    volume_type           = "standard"
    delete_on_termination = true
  }
  tags = {
    Name  = "my_tf_ec2"
    owner = "ninja"
  }
  # Attach the Instance Profile to EC2
  iam_instance_profile = aws_iam_instance_profile.s3_read_profile.name
}

resource "aws_key_pair" "ssh_ec2_key" {
  key_name = "aws_ssh_key_pair"
  public_key = file("srv1.pub")
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "my_sg_4_tf_ec2" {
  name        = "TF_proj_4_SSH_HTTP_HTTPS"
  description = "GS for Amazon test TF EC2"
  vpc_id      = aws_vpc.TF_VPC_proj_4.id
  dynamic "ingress" {
    for_each = ["22", "80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "TF_proj_4_GS"
    owner = "ninja"
  }
}

resource "aws_eip" "TF_elastic_ip" {
  instance = aws_instance.my_tf_ec2.id
  depends_on = [aws_internet_gateway.igw]
}

