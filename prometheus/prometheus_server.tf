resource "aws_instance" "prometheus_server" {
    ami = "ami-0ea3c35c5c3284d82"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.prometheus_server_sg.id]

    user_data = "${file("prometheus-server.sh")}"
    
    
    key_name = aws_key_pair.pub_key.key_name
    
    tags = {
        Name: "prometheus_server"
    }

    iam_instance_profile = aws_iam_instance_profile.prometheus_profile.id
}


resource "aws_security_group" "prometheus_server_sg" {

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

resource "aws_iam_role" "prometheus_role" {
  name = "prometheus_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_role_policy" "allow_describe_ec2_policy" {
  name = "prometheus_policy"
  role = aws_iam_role.prometheus_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_instance_profile" "prometheus_profile" {
  name = "prometheus_profile"
  role = aws_iam_role.prometheus_role.name
}