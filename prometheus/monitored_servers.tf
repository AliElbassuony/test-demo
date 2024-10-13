resource "aws_instance" "web_server" {
    count = 2
    ami = "ami-0ea3c35c5c3284d82"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.web_server_sg.id]
    user_data = "${file("node-exporter.sh")}"
    
    
    key_name = aws_key_pair.pub_key.key_name

    tags = {
        Name: "web_server.${count.index}"
        monitored: "yes"
        layer: "web"
    }
}

resource "aws_security_group" "web_server_sg" {

    ingress {
      from_port = 22
      to_port = 22
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"] 
    }

    ingress {
      from_port = 9100
      to_port = 9100
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    #   security_groups = [aws_security_group.prometheus_server_sg.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }   
}


resource "aws_key_pair" "pub_key" {
    public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAqAAYSO5YJdQGyYIycGydIOvNs6ZnqiVJd8B7s8BKya anything@anything"
    key_name = "pub-key"
}