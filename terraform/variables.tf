variable "vm_linux_count" {
  type = number
  default = 1
}
  
variable "vm_windows_count" {
  type = number
  default = 1
}

variable "hdinsight_user_name" {
  type = string
  default = "adminuser"
}

variable "hdinsight_user_password" {
  type = string
  default = "P@$$w0rd123!"
  sensitive = true 
}

variable "windows_user_name" {
  type = string
  default = "adminuser"
}
  
variable "windows_user_password" {
  type = string
  sensitive = true 
}

variable "linux_user_name" {
  type = string
  default = "adminuser"
}

variable "linux_user_password" {
  type = string
  sensitive = true 
}

