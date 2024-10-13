resource "aws_instance" "ansible_server" {

    ami = "ami-0ea3c35c5c3284d82"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.ansible_server_sg.id]
    user_data = "${file("ansible-server.sh")}"
    
    key_name = aws_key_pair.pub_key.key_name

    tags = {
        Name: "ansible_server"
        monitored: "yes"
    }
}


resource "aws_security_group" "ansible_server_sg" {
  ingress {
      from_port = 22
      to_port = 22
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"] 
    }
    ingress {
      from_port = 9090
      to_port = 9090
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"] 
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

