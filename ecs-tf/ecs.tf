data "aws_ecs_cluster" "cluster" {
  cluster_name = "eu-???"
}

resource "aws_ecs_task_definition" "service" {
  container_definitions = "${file("./service.json")}"
  family = "test-service"
}

resource "aws_ecs_service" "service" {
  cluster       = "${data.aws_ecs_cluster.cluster.arn}"
  name          = "test"
  desired_count = 1
  task_definition = "${aws_ecs_task_definition.service.arn}"

  load_balancer {
    container_name = "testserver"
    container_port = 8080
    target_group_arn = "${aws_lb_target_group.tg.arn}"
  }

  tags {
    environment = "test"
    service     = "test-service"
  }
}
