resource "aws_instance" "quest" {
  key_name      = "jestallin-aws"
  ami           = "ami-0dc2d3e4c0f9ebd18"
  instance_type = "t2.micro"
  subnet_id = "${var.subnet-us-east-1b}"


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

   provisioner "remote-exec" {
    inline = [
      "sudo yum install -y git docker ",
      "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash",
      "source ~/.nvm/nvm.sh",
      "nvm install node",
      "git clone https://github.com/jestallin/quest.git",
      "cd quest && npm install forever -g && npm install",
      "forever start src/000.js",
      "sudo service docker start",
      "sudo docker build -t quest .",
      "sudo docker run --user 1000:1000 -d -e SECRET_WORD='TwelveFactor' -p 3001:3000 quest"
    ]
  }
}

resource "aws_eip" "quest" {
  vpc      = true
  instance = aws_instance.quest.id
}