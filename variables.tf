variable "subnet_cidrs_public" {
  default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  type = "list"
}
 variable "az_list" {
   default = ["us-east-1a","us-east-1b","us-east-1c","us-east-1d","us-east-1e","us-east-1d","us-east-1f"]
  
}
variable "pub_subnet1" {
  default = "10.0.1.0/24"
}
variable "pub_subnet2" {
  default = "10.0.2.0/24"
}
variable "pub_sub_cidr" {
    type = "list"
    default = ["10.0.1.0/24","10.0.2.0/24"]
}
