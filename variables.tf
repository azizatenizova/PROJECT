variable "region" {
  type        = string
  description = "Enter region"
  default     = ""
}
variable "vpc_name" {
  default = ""
}
variable "cidr_block" {
  description = "Provide cidr block"
  default = ""
}
variable "igw_name" {
  description = "Internet gateway"
  default = ""
}
variable "public_cidr_block" {
  default     = ""
}
variable "public_subnet_name" {
  default     = ""
}
variable "availability_zone" {
  default     = ""
}
variable "az1" {
  default     = ""
}
variable "az2" {
  default     = ""
}
variable "ami_id" {
  description = "Enter AMI ID for the region"
  default = ""
}