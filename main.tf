provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "key" {
  key_name   = "terra"
  public_key = file("/home/ubuntu/.ssh/terra.pub")
}

resource "aws_default_vpc" "default_vpc" {

}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"


  vpc_id      = aws_default_vpc.default_vpc.id
  ingress {
    description = "TLS from VPC"


    from_port   = 22
    to_port     = 22
    protocol    = "tcp"


    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}


variable "tags" {
  type = map(string)
  default = {
    "name" = "utk-ec2"
  }
}

resource "aws_instance" "my_ec2" {
  ami             = var.ec2-ubuntu-ami
  instance_type   = "t2.micro"

  key_name        = aws_key_pair.key.key_name

  security_groups = [aws_security_group.allow_ssh.name]

  tags = var.tags
                                                                                                                                                                                                  1,0-1         Top

}

output "arn" {
  value = aws_instance.my_ec2.arn
}

output "public_ip" {
  value = aws_instance.my_ec2.public_ip
}

         
