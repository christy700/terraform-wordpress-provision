variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_ami" {
  default = "ami-006d3995d3a6b963b"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "project_name" {
  default = "uber"
}

variable "project_env" {
  default = "dev"
}

variable "vpc_cidr" {

  default = "172.17.0.0/16"
}

variable "public1_cidr" {

  default = "172.17.0.0/19"
}

variable "public2_cidr" {

  default = "172.17.32.0/19"
}

variable "public3_cidr" {

  default = "172.17.64.0/19"
}

variable "private1_cidr" {

  default = "172.17.96.0/19"
}

variable "private2_cidr" {

  default = "172.17.128.0/19"
}


variable "private3_cidr" {

  default = "172.17.160.0/19"
}

variable "mysql_pass" {

  default = "mysqlpass123"
}

variable "db_name" {

  default = "wordpressdb"
}

variable "db_user" {

  default = "wordpressuser"
}

variable "db_pass" {

  default = "wordpress123"
}

variable "domain_name" {

  default = "blog.timetrav.online"
}

variable "host_zoneid" {

  default = "Z0495840JLT6YJ4HJBRD"
}
