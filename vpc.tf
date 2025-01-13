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

##########################################
# サブネットの作成
##########################################
resource "aws_subnet" "web-service-subnet-public" {
  vpc_id            = aws_vpc.web-service-vpc.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = "172.16.100.0/24"
  tags = {
    Name    = "${local.project-name}-subnet-public",
    Project = "${local.project-name}",
  }
}

resource "aws_subnet" "web-service-subnet-private" {
  vpc_id            = aws_vpc.web-service-vpc.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = "172.16.101.0/24"
  tags = {
    Name    = "${local.project-name}-subnet-private",
    Project = "${local.project-name}",
  }
}

##########################################
# インターネットゲートウェイの作成
##########################################
resource "aws_internet_gateway" "web-service-internetgateway" {
  vpc_id = aws_vpc.web-service-vpc.id
  tags = {
    Name    = "${local.project-name}-internetgateway",
    Project = "${local.project-name}",
  }
}

##########################################
# Elastic IPの作成
##########################################
resource "aws_eip" "web-service-natgateway-eip" {
  domain = "vpc" # VPC用のElastic IP
  tags = {
    Name    = "${local.project-name}-natgateway-eip",
    Project = "${local.project-name}",
  }
}

##########################################
# NATゲートウェイの作成
##########################################
resource "aws_nat_gateway" "web-service-natgateway" {
  # サブネットのIDを指定
  subnet_id = aws_subnet.web-service-subnet-public.id
  # Elastic IPのIDを指定
  allocation_id = aws_eip.web-service-natgateway-eip.id
  tags = {
    Name    = "${local.project-name}-natgateway",
    Project = "${local.project-name}",
  }
}

##########################################
# ルートテーブルの作成
##########################################
resource "aws_route_table" "web-service-routetable-subnet-public" {
  vpc_id = aws_vpc.web-service-vpc.id
  tags = {
    Name    = "${local.project-name}-routetable-subnet-public",
    Project = "${local.project-name}",
  }
}
resource "aws_route_table" "web-service-routetable-subnet-private" {
  vpc_id = aws_vpc.web-service-vpc.id
  tags = {
    Name    = "${local.project-name}-routetable-subnet-private",
    Project = "${local.project-name}",
  }
}

##########################################
# ルートの作成
##########################################
resource "aws_route" "web-service-route-subnet-public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.web-service-routetable-subnet-public.id
  gateway_id             = aws_internet_gateway.web-service-internetgateway.id
}

resource "aws_route" "web-service-route-subnet-private" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.web-service-routetable-subnet-private.id
  gateway_id             = aws_nat_gateway.web-service-natgateway.id
}

##########################################
# サブネットとルートテーブルの紐づけ
########################################## 
resource "aws_route_table_association" "web-service-routetable-association-subnet-public" {
  subnet_id      = aws_subnet.web-service-subnet-public.id
  route_table_id = aws_route_table.web-service-routetable-subnet-public.id
}

resource "aws_route_table_association" "web-service-routetable-association-subnet-private" {
  subnet_id      = aws_subnet.web-service-subnet-private.id
  route_table_id = aws_route_table.web-service-routetable-subnet-private.id
}
