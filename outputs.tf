output "alb_dns" {
  value = aws_lb.app_alb.dns_name
}

output "vpc_id" {
  value = aws_vpc.main.id
}
