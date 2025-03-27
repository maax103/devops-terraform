data "aws_ami" "imagem_ec2" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["al2023-ami-2023.*-x86_64"]
    }
}

resource "aws_security_group" "sg" {
  vpc_id = "${var.vpc_id}"
  tags = {
    Unity = "${var.project_name}-vpc"
    Name = "${var.project_name}_sg"
  }
}

resource "aws_security_group_rule" "egress_sg_rule" {
  type = "egress"
  protocol = "tcp"
  security_group_id = aws_security_group.sg.id
  cidr_blocks = ["0.0.0.0/0"]
  to_port = 65535
  from_port = 0
}

resource "aws_security_group_rule" "ingress_22_sg_rule" {
  type = "ingress"
  protocol = "tcp"
  security_group_id = aws_security_group.sg.id
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 22
  to_port = 22
}

resource "aws_security_group_rule" "ingress_80_sg_rule" {
  type = "ingress"
  protocol = "tcp"
  security_group_id = aws_security_group.sg.id
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 80
  to_port = 80
}

resource "aws_network_interface" "net_interface" {
  subnet_id = "${var.nginx_pub_subnet_id}"
  tags = {
    Name = "${var.project_name}-net-interface"
  }
}

resource "aws_instance" "nginx_ec2" {
  instance_type = "t3.micro"
  ami = data.aws_ami.imagem_ec2.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id = "${var.nginx_pub_subnet_id}"
  tags = {
    Name = "${var.project_name}-nginx-ec2"
  }
  associate_public_ip_address = true
}