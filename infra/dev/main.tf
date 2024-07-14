

#########
# Locals
#########

locals {
  ci_cd_poc_github = "${var.project}-${var.environment}-ci-cd-poc-github"
}


################################################################################
# Subnet Group from Module
################################################################################
module "subnet_group" {
  source      = "../../modules/rds_modules/rds_db_subnet_group"
  name        = "${var.project}-${var.environment}-db-subnet-group"
  name_prefix = false
  subnet_ids  = var.private_subnet_ids
  description = "DB subnet group for ${var.project}-${var.environment}"

  tags = merge(
    {
      "Name" = "${var.project}-${var.environment}-db-subnet-group"
    },
    var.tags
  )
}




module "ci_cd_poc_github_task_definition" {
  source = "../../modules/ecs_modules/ecs_task_definition"

  family          = local.ci_cd_poc_github
  container_name  = local.ci_cd_poc_github
  container_image = "730335529002.dkr.ecr.us-east-2.amazonaws.com/node-ts-ci-cd-github-poc:439ffaa-2024-07-14-14-52"
  container_ports = [3000]
  memory          = "512"
  cpu             = "256"

  log_group_name = "/ecs/${var.project}-${var.environment}/ci_cd_poc_github"

  create_task_role = true
  create_execution_role = true

  tags = var.tags
}

module "ci_cd_poc_github_ecs_service" {
  source = "../../modules/ecs_modules/ecs_service"

  //cluster
  cluster_id = module.ecs_cluster.cluster_id
  vpc_id     = var.vpc_id

  //service
  task_definition_arn = module.ci_cd_poc_github_task_definition.task_definition_arn
  name                = local.ci_cd_poc_github
  subnet_ids          = var.private_subnet_ids

  //load balancer
  load_balancer = {
    internal   = true
    name       = local.ci_cd_poc_github
    subnet_ids = var.private_subnet_ids
    type       = "application"

    target_group = {
      name = local.ci_cd_poc_github
      port = 3000
      health_check = {
        path = "/api/health"
      }
    }
    listeners = {
      http = {
        enabled     = true
        action_type = "forward"
      }
      https = {
        enabled = false
      }
    }
  }
  tags = var.tags
}

module "ecs_cluster" {
  source = "../../modules/ecs_modules/ecs_cluster"

  cluster_name = "${var.project}-${var.environment}"

  tags = merge(
    {
      "Name" = "${var.project}-${var.environment}"
    },
    var.tags
  )
}


###SSM PARAMETERS

module "ssm_parameter_ecs_cluster_name" {
  source = "../../modules/ssm_modules/ssm_parameter"

  parameter_name  = "/${var.project}/${var.environment}/ecs/cluster_name"
  parameter_value = module.ecs_cluster.cluster_name
}


resource "aws_cloudwatch_log_group" "ci_cd_poc_github_logs" {
  name              = "/ecs/${var.project}-${var.environment}/ci_cd_poc_github"
  retention_in_days = var.logs_retention_in_days
  tags              = var.tags
}