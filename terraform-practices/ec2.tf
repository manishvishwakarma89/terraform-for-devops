resource "aws_key_pair" "my_key_pair" {

  key_name   = "terra-automate-key-josh"
  public_key = file("terra-automate-key.pub")
}

# VPC Default

resource "aws_default_vpc" "default" {
}


# Security Group 

resource "aws_security_group" "my_security_group" {

  name        = "terra-security-group"
  vpc_id      = aws_default_vpc.default.id # interpolation
  description = "this is Inbound and outbound rules for your instance Security group"

}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# EC2 instance



resource "aws_ec2_instance_state" "my_instance_state" {
  count=var.ec2_instance_count
  instance_id = aws_instance.my_instance.id
  state       = var.ec2_instance_state
}
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_security_group" "my_sg" {
  name        = "my-instance-sg"
  description = "SSH and HTTP access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-instance-sg"
  }
}

resource "aws_instance" "my_instance" {
  ami                    = data.aws_ssm_parameter.al2023.value
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "my-instance"
  }
}


