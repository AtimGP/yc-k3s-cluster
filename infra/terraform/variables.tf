variable "yc_cloud_id" {
  type = string
  description = "yandex cloud id"
}

variable "yc_folder_id" {
  type = string
  description = "yandex cloud catalog id"
}

variable "yc_zone" {
  type = string
  description = "yandex cloud zone"
}

variable "yc_image_id" {
  type = string
  description = "yandex cloud os image id"
}

variable "ssh_user" {
  type        = string
  default     = "debian"
  description = "username for ssh connect"
}

variable "ssh_public_key_path" {
  type        = string
  default     = "C:/Users/Atim/.ssh/id_ed25519.pub"
  description = "path for public key"
}

variable "vm_count" {
  type =  number
  default = 3
}