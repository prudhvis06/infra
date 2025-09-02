resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  ebs_block_device {
    device_name = var.volume_device_name
    volume_id   = var.volume_id
  }

  tags = {
    Name = var.name
  }
}
