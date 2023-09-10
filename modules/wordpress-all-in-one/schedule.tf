resource "aws_scheduler_schedule" "ec2_start_schedule" {
  name = "${var.environment}-ec2-start-schedule"
  description = "Start instance"

  state = var.scheduled_stop_enabled ? "ENABLED" : "DISABLED"
  schedule_expression = var.scheduled_start
  schedule_expression_timezone = var.scheduled_stop_timezone
  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn = "arn:aws:scheduler:::aws-sdk:ec2:startInstances"
    role_arn = aws_iam_role.scheduler_ec2_role.arn
  
    input = jsonencode({
      "InstanceIds": [
        "${aws_instance.this.id}"
      ]
    })
  }
}

resource "aws_scheduler_schedule" "ec2_stop_schedule" {
  name = "${var.environment}-ec2-stop-schedule"
  description = "Stop instance"

  state = var.scheduled_stop_enabled ? "ENABLED" : "DISABLED"
  schedule_expression = var.scheduled_stop
  schedule_expression_timezone = var.scheduled_stop_timezone
  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn = "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
    role_arn = aws_iam_role.scheduler_ec2_role.arn
  
    input = jsonencode({
      "InstanceIds": [
        "${aws_instance.this.id}"
      ]
    })
  }
}

resource "aws_iam_policy" "scheduler_ec2_policy" {
  name = "${var.environment}-scheduler-ec2-policy"

  policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor0",
                "Effect": "Allow",
                "Action": [
                    "ec2:StartInstances",
                    "ec2:StopInstances"
                ],
                "Resource": [
                  "${aws_instance.this.arn}:*",
                  "${aws_instance.this.arn}"
                ],
            }
        ]
    }
  )
}

resource "aws_iam_role" "scheduler_ec2_role" {
  name = "${var.environment}-scheduler-ec2-role"
  tags = var.tags

  managed_policy_arns = [aws_iam_policy.scheduler_ec2_policy.arn]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
      },
    ]
  })
}
