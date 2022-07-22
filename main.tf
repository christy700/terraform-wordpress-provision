resource "aws_vpc" "uber_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name    = "${var.project_name}-${var.project_env}",
    Project = var.project_name,
    Env     = var.project_env
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.uber_vpc.id

  tags = {
    Name    = "${var.project_name}-${var.project_env}",
    Project = var.project_name,
    Env     = var.project_env
  }
}

resource "aws_subnet" "public1_sub" {
  vpc_id                  = aws_vpc.uber_vpc.id
  cidr_block              = var.public1_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project_name}-${var.project_env}-public1_sub",
    Project = var.project_name,
    Env     = var.project_env
  }
}


resource "aws_subnet" "public2_sub" {
  vpc_id                  = aws_vpc.uber_vpc.id
  cidr_block              = var.public2_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project_name}-${var.project_env}-public2_sub",
    Project = var.project_name,
    Env     = var.project_env
  }
}

resource "aws_subnet" "public3_sub" {
  vpc_id                  = aws_vpc.uber_vpc.id
  cidr_block              = var.public3_cidr
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project_name}-${var.project_env}-public3_sub",
    Project = var.project_name,
    Env     = var.project_env
  }
}

resource "aws_subnet" "private1_sub" {
  vpc_id                  = aws_vpc.uber_vpc.id
  cidr_block              = var.private1_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project_name}-${var.project_env}-private1_sub",
    Project = var.project_name,
    Env     = var.project_env
  }
}

resource "aws_subnet" "private2_sub" {
  vpc_id                  = aws_vpc.uber_vpc.id
  cidr_block              = var.private2_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project_name}-${var.project_env}-private2_sub",
    Project = var.project_name,
    Env     = var.project_env
  }
}

resource "aws_subnet" "private3_sub" {
  vpc_id                  = aws_vpc.uber_vpc.id
  cidr_block              = var.private3_cidr
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project_name}-${var.project_env}-private3_sub",
    Project = var.project_name,
    Env     = var.project_env
  }
}

resource "aws_eip" "uber_eip" {
  vpc = true
  tags = {
    Name    = "${var.project_name}-${var.project_env}-nat",
    Project = var.project_name,
    Env     = var.project_env
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.uber_eip.id
  subnet_id     = aws_subnet.public2_sub.id

  tags = {
    Name    = "${var.project_name}-${var.project_env}",
    Project = var.project_name,
    Env     = var.project_env
  }

  depends_on = [aws_internet_gateway.igw]
}


resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.uber_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "${var.project_name}-${var.project_env}-public_sub",
    Project = var.project_name,
    Env     = var.project_env
  }
}


resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.uber_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name    = "${var.project_name}-${var.project_env}-private_sub",
    Project = var.project_name,
    Env     = var.project_env
  }
}

resource "aws_route_table_association" "public1_sub" {
  subnet_id      = aws_subnet.public1_sub.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public2_sub" {
  subnet_id      = aws_subnet.public2_sub.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public3_sub" {
  subnet_id      = aws_subnet.public3_sub.id
  route_table_id = aws_route_table.public_route.id
}


resource "aws_route_table_association" "private1_sub" {
  subnet_id      = aws_subnet.private1_sub.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private2_sub" {
  subnet_id      = aws_subnet.private2_sub.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private3_sub" {
  subnet_id      = aws_subnet.private3_sub.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_security_group" "bastion" {
  name_prefix = "bastion-"
  description = "Allow port 22"
  vpc_id      = aws_vpc.uber_vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "${var.project_name}-${var.project_env}-bastion",
    Project = var.project_name,
    Env     = var.project_env
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "frontend" {
  name_prefix = "frontend-"
  description = "Allow port 22 from bastion 80,443"
  vpc_id      = aws_vpc.uber_vpc.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "${var.project_name}-${var.project_env}-frontend",
    Project = var.project_name,
    Env     = var.project_env
  }
  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_security_group" "backend" {
  name_prefix = "backend-"
  description = "Allow port 22 from bastion,3306"
  vpc_id      = aws_vpc.uber_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "${var.project_name}-${var.project_env}-backend",
    Project = var.project_name,
    Env     = var.project_env
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_key_pair" "uberkey" {
  key_name   = "${var.project_name}-${var.project_env}"
  public_key = file("uberinfra.pub")
  tags = {
    Name    = "${var.project_name}-${var.project_env}-frontend",
    Project = var.project_name,
    Env     = var.project_env
  }
}

resource "aws_instance" "bastion" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.uberkey.id
  subnet_id              = aws_subnet.public1_sub.id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  user_data              = file("sshpass.sh")
  tags = {
    Name    = "${var.project_name}-${var.project_env}-bastion",
    Project = var.project_name,
    Env     = var.project_env
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("uberinfra")
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "template-output"
    destination = "/tmp/"
  }
  provisioner "file" {
    source      = "uberinfra"
    destination = "/tmp/uberinfra"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install sshpass -y",
      "chmod 400 /tmp/uberinfra",
      "chmod +x /tmp/template-output/tranfer.sh",
      "/tmp/template-output/tranfer.sh"
    ]
  }

  depends_on = [aws_instance.frontend, aws_instance.backend, aws_route_table_association.public1_sub]
}

resource "aws_instance" "frontend" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.uberkey.id
  user_data              = file("userdata1.sh")
  subnet_id              = aws_subnet.public2_sub.id
  vpc_security_group_ids = [aws_security_group.frontend.id]
  tags = {
    Name    = "${var.project_name}-${var.project_env}-frontend",
    Project = var.project_name,
    Env     = var.project_env
  }
  depends_on = [aws_route_table_association.public2_sub, aws_internet_gateway.igw]
}

resource "aws_instance" "backend" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.uberkey.id
  subnet_id              = aws_subnet.private1_sub.id
  user_data              = file("userdata2.sh")
  vpc_security_group_ids = [aws_security_group.backend.id]
  tags = {
    Name    = "${var.project_name}-${var.project_env}-backend",
    Project = var.project_name,
    Env     = var.project_env
  }
  depends_on = [aws_nat_gateway.ngw, aws_route_table_association.private2_sub, aws_internet_gateway.igw]
}

resource "aws_route53_record" "my_record" {
  zone_id = var.host_zoneid
  name    = var.domain_name
  type    = "A"
  ttl     = "300"
  records = [aws_instance.frontend.public_ip]
}


