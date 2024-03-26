# EC2 Instances

resource "aws_instance" "machine_0" {
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = [var.sg_name]
  user_data       = <<-EOF
              #!/bin/bash
              echo "echo from machine 0" > index.html
              python3 -m http.server 8080 &
              EOF
}

resource "aws_instance" "machine_1" {
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = [var.sg_name]
  user_data       = <<-EOF
              #!/bin/bash
              echo "echo from machine 1" > index.html
              python3 -m http.server 8080 &
              EOF
}


