variable "name" {
  type = string
}

variable "assume_role_service" {
  type = string
}

variable "policy_name" {
  type = string
}

variable "policy_description" {
  type = string
}

variable "policy_document" {
  type = any
}
