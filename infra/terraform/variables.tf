variable "yc_token" {
  type = string
  description = "yandex IAM token"
  sensitive = true
}

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
  default     = "~/.ssh/id_ed25519.pub"
  description = "path for public key"
}
