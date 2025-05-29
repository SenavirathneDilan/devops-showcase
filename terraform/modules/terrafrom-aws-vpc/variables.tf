variable "cidr_block" {
  type    = string
  default = "10.11.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.11.0.0/24", "10.11.1.0/24", "10.11.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.11.3.0/24", "10.11.4.0/24", "10.11.5.0/24"]
}

variable "map_public_ip_on_launch" {
  type    = bool
  default = true
}

variable "public_rt_route" {

}

variable "nacl_ingress_rules" {
  type = map(object({
    rule_number = number
    egress      = bool
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = number
    to_port     = number
  }))

  default = {
    "http" = {
      rule_number = 201
      egress      = false
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "test"
      from_port   = 80
      to_port     = 80
    }
  }
}

variable "default_security_group_rules" {
  type = map(object({
    type       = string
    from_port  = number
    to_port    = number
    protocol   = string
    cidr_block = list(string)
  }))

  default = {
    "http" = {
      type       = "ingress"
      from_port  = 80
      to_port    = 80
      protocol   = "tcp"
      cidr_block = ["0.0.0.0/0"]
    },
    "https" = {
      type       = "ingress"
      from_port  = 443
      to_port    = 443
      protocol   = "tcp"
      cidr_block = ["0.0.0.0/0"]
    }
  }
}