resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.public_key
}

resource "aws_security_group" "ssh_sg" {
  name        = "ssh-security-group"
  description = "Allow SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "test-instance" {
  ami             = "ami-080e1f13689e07408"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.ssh_sg.name]
  tags = {
    Name = "test-instance"
  }
}

output "instance_public_ip" {
  value = aws_instance.test-instance.public_ip
}