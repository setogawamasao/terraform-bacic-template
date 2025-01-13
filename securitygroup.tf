##########################################
# セキュリティグループの作成
##########################################
resource "aws_security_group" "web-service-securitygroup-private-subnet-ec2" {
  name        = "web-service-securitygroup-ec2"
  description = "for EC2"
  vpc_id      = aws_vpc.web-service-vpc.id
  tags = {
    Name    = "${local.project-name}-securitygroup-private-subnet-ec2",
    Project = "${local.project-name}",
  }
}

##########################################
# セキュリティグループのルールの作成
##########################################
# インバウンドルール 01 (80/TCP)  
resource "aws_security_group_rule" "web-service-ingress-rule-01" {
  description       = "inbound rule http"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  type              = "ingress"
  cidr_blocks       = ["172.16.100.0/24"]
  security_group_id = aws_security_group.web-service-securitygroup-private-subnet-ec2.id
}

# アウトバウンドルール 01  
resource "aws_security_group_rule" "web-service-egress-rule-01" {
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web-service-securitygroup-private-subnet-ec2.id
}
