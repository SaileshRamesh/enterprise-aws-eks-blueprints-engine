output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "The CIDR block of the created VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = values(aws_subnet.public)[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = values(aws_subnet.private)[*].id
}

output "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  value       = values(aws_subnet.public)[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  value       = values(aws_subnet.private)[*].cidr_block
}

output "nat_gateway_ids" {
  description = "IDs of NAT gateways created for the VPC"
  value       = aws_nat_gateway.this.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway attached to the VPC"
  value       = aws_internet_gateway.this.id
}

output "availability_zones" {
  description = "Availability zones used by the VPC"
  value       = var.azs
}
