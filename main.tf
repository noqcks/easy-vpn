data "aws_ami" "amazon-linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  owners = ["amazon"]
}

resource "aws_instance" "pritunl" {
  ami           = data.aws_ami.amazon-linux.id
  instance_type = var.instance_type
  key_name      = var.ssh_keypair_name
  user_data     = file("${path.module}/provision.sh")

  vpc_security_group_ids = [
    aws_security_group.pritunl.id,
    aws_security_group.whitelisted_access.id,
  ]

  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true
  source_dest_check           = false

  tags = merge(
    map("Name", format("%s-%s", var.resource_name_prefix, "vpn")),
    var.tags,
  )

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ec2-user"
    agent       = "true"
    private_key = file(var.ssh_keypair_file_location)
  }

  provisioner "remote-exec" {

    inline = [
      "sleep 60",
      "sudo pritunl setup-key",
    ]
  }

}

data "aws_instance" "pritunl_loaded" {
  depends_on = [
    aws_instance.pritunl
  ]

  filter {
    name   = "image-id"
    values = [data.aws_ami.amazon-linux.id]
  }

  filter {
    name   = "tag:Name"
    values = [format("%s-%s", var.resource_name_prefix, "vpn")]
  }

}

resource "aws_eip" "pritunl" {
  instance = aws_instance.pritunl.id
  vpc      = true
}
