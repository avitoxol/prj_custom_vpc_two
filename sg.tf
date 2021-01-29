resource "aws_security_group" "websg" {
    description = "Ports for Apache"
    vpc_id = aws_vpc.testvpc.id

    dynamic "ingress" {
      for_each = var.webports
      iterator = port
      content {
        from_port = port.value
        to_port = port.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
}
