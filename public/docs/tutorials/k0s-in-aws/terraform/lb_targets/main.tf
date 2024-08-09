resource "aws_lb_target_group" "api" {
  name     = "${var.cluster_name}-${var.listen_port}-${var.target_port}"
  protocol = "TCP"
  vpc_id   = var.vpc_id
  port     = var.target_port
  health_check {
    unhealthy_threshold = 6
    healthy_threshold   = 2
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "api" {
  load_balancer_arn = var.arn
  port              = var.listen_port
  protocol          = "TCP"
  default_action {
    target_group_arn = aws_lb_target_group.api.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "api" {
  count            = var.node_count
  target_group_arn = aws_lb_target_group.api.arn
  target_id        = var.node_ids[count.index]
  port             = var.target_port
}
