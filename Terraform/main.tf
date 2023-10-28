#v1
provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "example" {
  name        = "Jenkins-security-group"
  description = "Example security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Jenkins" {
  ami           = "ami-05a5f6298acdb05b6"
  instance_type = "t2.micro"
  key_name      = "aws_keypair"

tags = {
    Name = "jenkins-server"
  }


  connection {
    type        = "ssh"
    user        = "ec2-user"  # Replace with the appropriate user for your AMI
    private_key = file("C:/Workspace/aws_terraform/aws_keypair.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /c/Workspace/aws_terraform/install-jenkins.sh",
      "/c/Workspace/aws_terraform/install-jenkins.sh",
    ]
  }
}
