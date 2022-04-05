variable "database_name" {
  type    = string
  default = "wp"
}

variable "database_user" {
  type    = string
  default = "wp"
}

variable "webserver_instances" {
  type    = number
  default = 2
}
