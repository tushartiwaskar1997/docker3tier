
output "volume_id" {
  value = aws_ebs_volume.mysql_data.id
}

output "device_name" {
  value = var.ebs_device_name
}

output "next_steps" {
  value = "Connect to instance -> run your mount script -> then run docker compose"
}                                                                                     