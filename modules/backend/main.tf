data "aws_ami" "imagem_ec2" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["al2023-ami-2023.*-x86_64"]
    }
}

resource "aws_security_group" "sg_priv" {
  vpc_id = "${var.vpc_id}"
  tags = {
    Name = "${var.project_name}_sg_priv_backend"
  }
}

resource "aws_security_group_rule" "egress_sg_priv_rule" {
  type = "egress"
  protocol = "tcp"
  security_group_id = aws_security_group.sg_priv.id
  cidr_blocks = ["0.0.0.0/0"]
  to_port = 65535
  from_port = 0
}

resource "aws_security_group_rule" "ingress_22_sg_priv_rule" {
  type = "ingress"
  protocol = "tcp"
  security_group_id = aws_security_group.sg_priv.id
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 22
  to_port = 22
}

resource "aws_network_interface" "net_interface_priv_b" {
  subnet_id = "${var.priv_subnet_id_b}"
  tags = {
    Name = "${var.project_name}-net-interface-b2"
  }
}

resource "aws_network_interface" "net_interface_priv_c" {
  subnet_id = "${var.priv_subnet_id_c}"
  tags = {
    Name = "${var.project_name}-net-interface-c2"
  }
}

resource "aws_instance" "backend_ec2_b" {
  instance_type = "t2.micro"
  ami = data.aws_ami.imagem_ec2.id
  vpc_security_group_ids = [aws_security_group.sg_priv.id]
  subnet_id = "${var.priv_subnet_id_b}"
  key_name = "max-devops-key"
  
  tags = {
    Name = "${var.project_name}-backend-ec2-b"
  }
}

resource "aws_instance" "backend_ec2_c" {
  instance_type = "t2.micro"
  ami = data.aws_ami.imagem_ec2.id
  vpc_security_group_ids = [aws_security_group.sg_priv.id]
  subnet_id = "${var.priv_subnet_id_c}"
  key_name = "max-devops-key"
  
  tags = {
    Name = "${var.project_name}-backend-ec2-c"
  }
}
