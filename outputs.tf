output "public_ip" {
  value = aws_instance.example.*.public_ip
}

output "role_id" {
  value = aws_iam_role.ansible.unique_id
}