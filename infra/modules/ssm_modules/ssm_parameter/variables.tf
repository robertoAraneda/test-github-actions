variable "parameter_name" {
  description = "The name of the parameter"
  type        = string
  default     = ""
}

variable "parameter_description" {
  description = "The description of the parameter"
  type        = string
  default     = ""
}

variable "parameter_type" {
  description = "The type of the parameter"
  type        = string
  default     = "String"
}

variable "parameter_value" {
  description = "The value of the parameter"
  type        = string
  default     = ""
}

variable "tags" {
  description = "The tags to apply to the parameter"
  type        = map(string)
  default     = {}
}