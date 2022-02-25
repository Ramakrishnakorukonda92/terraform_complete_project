resource "null_resource" "name" {
  connection {
    type        = "ssh"
    host        = aws_eip.nat.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("newkey.pem")
  }
  provisioner "file" {
    source      = "newkey.pem"
    destination = "/tmp/newkey.pem"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/newkey.pem"
    ]
  }
}

