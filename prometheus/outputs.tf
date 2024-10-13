output "webserver_public_ips" {
    value = aws_instance.web_server.*.public_ip
}


output "prometheus_server_public_ip" {
    value = aws_instance.prometheus_server.public_ip
}

output "ansible_server_public_ip" {
    value = aws_instance.ansible_server.public_ip
}

output "ssh_command" {
  value = "ssh ubuntu@${aws_instance.prometheus_server.public_ip}"
}