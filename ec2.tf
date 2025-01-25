##########################################
# E2 インスタンスの作成
##########################################
resource "aws_instance" "web-service-ec2-01" {
  ami                         = "ami-03dceaabddff8067e"
  associate_public_ip_address = "false"
  instance_type               = "t3a.small"
  subnet_id                   = aws_subnet.web-service-subnet-private.id
  vpc_security_group_ids      = [aws_security_group.web-service-securitygroup-private-subnet-ec2.id, aws_security_group.web-service-securitygroup-ssh-ec2.id]
  depends_on                  = [aws_nat_gateway.web-service-natgateway]
  user_data                   = file("./user_data.sh")
  tags = {
    Name    = "${local.project-name}-ec2-01",
    Project = "${local.project-name}",
  }
}

##########################################
# EC2 Instance Connect Endpointおよびセキュリティグループの作成
# EC2に接続するため
##########################################
resource "aws_ec2_instance_connect_endpoint" "web-service-ec2-instance-connect-endpoint" {
  subnet_id          = aws_subnet.web-service-subnet-private.id
  security_group_ids = [aws_security_group.web-service-securitygroup-ssh-eic.id]
  preserve_client_ip = true

  tags = {
    Name    = "${local.project-name}-ec2-01",
    Project = "${local.project-name}",
  }
}

# EIC Endpointのセキュリティグループ
resource "aws_security_group" "web-service-securitygroup-ssh-eic" {
  name        = "web-service-securitygroup-ssh-eic"
  description = "EIC Security Group"
  vpc_id      = aws_vpc.web-service-vpc.id

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web-service-securitygroup-ssh-ec2" {
  name        = "web-service-securitygroup-ssh-ec2"
  description = "EC2 Instance Security Group"
  vpc_id      = aws_vpc.web-service-vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web-service-securitygroup-ssh-eic.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


