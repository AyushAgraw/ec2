output "instance_public_ip" {
  value = aws_instance.Myserver.public_ip
}

output "instance_public_dns" {
  value = aws_instance.Myserver.public_dns
}

output "instance_type" {
  value = aws_instance.Myserver
}
