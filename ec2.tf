resource "aws_instance" "web_ec2" {
    ami                    = data.aws_ami.my_image.id
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.primary.id
    vpc_security_group_ids = [aws_security_group.websg.id]
}



resource "aws_instance" "db_ec2" {
    ami                    = data.aws_ami.my_image.id
    instance_type          = "t3a.micro"
    subnet_id              = aws_subnet.prv_one.id
    vpc_security_group_ids = var.dg_sg
}
