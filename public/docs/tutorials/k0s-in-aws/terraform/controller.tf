locals {
  lb_ports = {
    443: 33001,
    6443: 6443,
    8132: 8132,
    9443: 9443,
  }
}

resource "aws_default_subnet" "subnet" {
  availability_zone = "${var.region}a"
}

resource "aws_instance" "cluster-controller" {
  count         = var.controller_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.cluster_flavor
  subnet_id     = aws_default_subnet.subnet.id

  tags = {
    Name = "controller+worker"
  }
  key_name                    = aws_key_pair.cluster-key.key_name
  vpc_security_group_ids      = [aws_security_group.cluster_allow_ssh.id]
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = 10
  }
}

resource "aws_default_vpc" "vpc" {
}

resource "aws_lb" "lb" {
  name               = "${var.cluster_name}-lb"
  internal           = false
  load_balancer_type = "network"
  subnets = [aws_default_subnet.subnet.id]
}

module "lb_targets" {
  source       = "./lb_targets"
  for_each     = local.lb_ports
  listen_port  = each.key
  target_port  = each.value
  arn          = aws_lb.lb.arn
  node_ids     = aws_instance.cluster-controller[*].id
  node_count   = var.controller_count
  cluster_name = var.cluster_name
  vpc_id       = aws_default_vpc.vpc.id
}
