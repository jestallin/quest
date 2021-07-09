provider "aws" {
  profile = "default"
  region  = "us-east-1"
}



resource "aws_security_group" "quest" {
  name        = "quest"
  description = "quest sg"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "terraform"
  }
}

resource "aws_instance" "quest" {
  key_name      = "jestallin-aws"
  ami           = "ami-0dc2d3e4c0f9ebd18"
  instance_type = "t2.micro"

  tags = {
    Name = "quest"
  }

  vpc_security_group_ids = [
    aws_security_group.quest.id
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/jestallin-aws.pem")
    host        = self.public_ip
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 30
  }

   provisioner "remote-exec" {
    inline = [
      "yum install git docker ",
      "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash",
      "source ~/.nvm/nvm.sh",
      "nvm install node",
      "git clone https://github.com/jestallin/quest.git"
    ]
  }
}

resource "aws_eip" "quest" {
  vpc      = true
  instance = aws_instance.quest.id
}