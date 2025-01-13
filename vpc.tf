##########################################  
# VPCの作成
##########################################
resource "aws_vpc" "web-service-vpc" {
  cidr_block = "172.16.0.0/16"
  tags = {
    Name    = "${local.project-name}-vpc",
    Project = "${local.project-name}",
  }
}

