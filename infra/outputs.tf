output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = aws_eip.main.public_ip
}

output "ssh_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh admin@${aws_eip.main.public_ip}"
}

output "nameservers" {
  description = "Nameservers for the hosted zone (configure at your registrar)"
  value       = var.domain_name != "" ? aws_route53_zone.main[0].name_servers : []
}

output "url" {
  description = "Website URL"
  value       = "https://${var.domain_name}"
}
