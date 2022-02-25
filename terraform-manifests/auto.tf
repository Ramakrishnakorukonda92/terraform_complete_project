locals {
  //name   = "ex-asg-complete"
  //region = "eu-west-1"
  #   tags = {
  #     Owner       = "user"
  #     Environment = "dev"
  #   }

  user_data = <<-EOT
  #!/bin/bash
yum update -y
sudo amazon-linux-extras install nginx1
systemctl start nginx
systemctl enable nginx
sudo mkdir /usr/share/nginx/html/app1
sudo echo "<h1>hi from nginx</h1>" | sudo tee /usr/share/nginx/html/index.html
sudo echo "<h1>hi from nginx1</h1>" | sudo tee /usr/share/nginx/html/app1/index.html
  EOT
}
module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "5.1.1"

  name            = "${local.name}-complete-pakkimti"
  use_name_prefix = false
  instance_name   = "my-instance-name"

  ignore_desired_capacity_changes = true

  min_size                  = 2
  max_size                  = 10
  desired_capacity          = 2
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.private_subnets
  service_linked_role_arn   = aws_iam_service_linked_role.autoscaling.arn

  target_group_arns = module.alb.target_group_arns


  initial_lifecycle_hooks = [
    {
      name                 = "ExampleStartupLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 60
      lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                 = "ExampleTerminationLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 180
      lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
    }
    triggers = ["tag"] //when ever any changes happens in tag it will automatically update mean refresh
  }

  # Launch template
  launch_template_name        = "${local.name}-complete-template"
  launch_template_description = "Complete launch template example"
  update_default_version      = true

  image_id      = data.aws_ami.amazonlinux.id
  instance_type = "t3.micro"
  //user_data              = file("nginx.sh")
  user_data_base64  = base64encode(local.user_data)
  ebs_optimized     = true
  enable_monitoring = true

  //iam_instance_profile_arn = aws_iam_instance_profile.ssm.arn
  # # Security group is set on the ENIs below
  security_groups = [module.security-group.security_group_id]



  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 20
        volume_type           = "gp2"
      }
      }, {
      device_name = "/dev/sda1"
      no_device   = 1
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 30
        volume_type           = "gp2"
      }
    }
  ]

  #   capacity_reservation_specification = {
  #     capacity_reservation_preference = "open"
  #   }

  #   cpu_options = {
  #     core_count       = 1
  #     threads_per_core = 1
  #   }

  #   credit_specification = {
  #     cpu_credits = "standard"
  #   }

  # enclave_options = {
  #   enabled = true # Cannot enable hibernation and nitro enclaves on same instance nor on T3 instance type
  # }

  # hibernation_options = {
  #   configured = true # Root volume must be encrypted & not spot to enable hibernation
  # }

  #   instance_market_options = {
  #     market_type = "spot"
  #   }

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 32
    instance_metadata_tags      = "enabled"
  }

  #   network_interfaces = [
  #     {
  #       delete_on_termination = true
  #       description           = "eth0"
  #       device_index          = 0
  #       security_groups       = [module.asg_sg.security_group_id]
  #     },
  #     {
  #       delete_on_termination = true
  #       description           = "eth1"
  #       device_index          = 1
  #       security_groups       = [module.asg_sg.security_group_id]
  #     }
  #   ]

  #   placement = {
  #     availability_zone = "${local.region}b"
  #   }

  #   tag_specifications = [
  #     {
  #       resource_type = "instance"
  #       tags          = { WhatAmI = "Instance" }
  #     },
  #     {
  #       resource_type = "volume"
  #       tags          = merge({ WhatAmI = "Volume" })
  #     },
  #     {
  #       resource_type = "spot-instances-request"
  #       tags          = merge({ WhatAmI = "SpotInstanceRequest" })
  #     }
  #   ]

  //tags = local.tags

  # Autoscaling Schedule
  schedules = {
    night = {
      min_size         = 0
      max_size         = 0
      desired_capacity = 0
      recurrence       = "0 18 * * 1-5" # Mon-Fri in the evening
      time_zone        = "Europe/Rome"
    }

    morning = {
      min_size         = 0
      max_size         = 1
      desired_capacity = 1
      recurrence       = "0 7 * * 1-5" # Mon-Fri in the morning
    }

    go-offline-to-celebrate-new-year = {
      min_size         = 0
      max_size         = 0
      desired_capacity = 0
      start_time       = "2031-12-31T10:00:00Z" # Should be in the future
      end_time         = "2032-01-01T16:00:00Z"
    }
  }
  # Target scaling policy schedule based on average CPU load
  scaling_policies = {
    avg-cpu-policy-greater-than-50 = {
      policy_type               = "TargetTrackingScaling"
      estimated_instance_warmup = 1200
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 50.0
      }
    },
    predictive-scaling = {
      policy_type = "PredictiveScaling"
      predictive_scaling_configuration = {
        mode                         = "ForecastAndScale"
        scheduling_buffer_time       = 10
        max_capacity_breach_behavior = "IncreaseMaxCapacity"
        max_capacity_buffer          = 10
        metric_specification = {
          target_value = 32
          predefined_scaling_metric_specification = {
            predefined_metric_type = "ASGAverageCPUUtilization"
            resource_label         = "testLabel"
          }
          predefined_load_metric_specification = {
            predefined_metric_type = "ASGTotalCPUUtilization"
            resource_label         = "testLabel"
          }
        }
      }
    }
  }
}