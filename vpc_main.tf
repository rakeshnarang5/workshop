provider "aws" {
  version = "~> 2.17"
  region = "${var.aws_region}"
}

################ VPC #################

resource "aws_vpc" "anupamvpc" {
  cidr_block       = "${var.anupamvpc_vpc_cidr}"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "anupamvpc"
    }
}

 ################# Subnets #############

resource "aws_subnet" "anusubnet1" {
  vpc_id     = "${aws_vpc.anupamvpc.id}"
  cidr_block = "10.42.1.0/24"
  availability_zone = "${var.availability_zone1}"


  tags = {
    Name = "app-anusubnet-1"
    }
}
resource "aws_subnet" "anusubnet2" {
  vpc_id     = "${aws_vpc.anupamvpc.id}"
  cidr_block = "10.42.2.0/24"
  availability_zone = "${var.availability_zone2}"


  tags = {
    Name = "app-anusubnet-2"
  }
}
resource "aws_subnet" "anusubnet3" {
  vpc_id     = "${aws_vpc.anupamvpc.id}"
  cidr_block = "10.42.3.0/24"
  availability_zone = "${var.availability_zone1}"


  tags = {
    Name = "elb-anusubnet-1"
  }
}
resource "aws_subnet" "anusubnet4" {
  vpc_id     = "${aws_vpc.anupamvpc.id}"
  cidr_block = "10.42.4.0/24"
  availability_zone = "${var.availability_zone2}"


  tags = {
    Name = "elb-anusubnet-2"
  }
}
resource "aws_subnet" "anusubnetdb1" {
  vpc_id     = "${aws_vpc.anupamvpc.id}"
  cidr_block = "10.42.5.0/24"
  availability_zone = "${var.availability_zone1}"


  tags = {
    Name = "db-anusubnet-1"
  }
}
resource "aws_subnet" "anusubnetdb2" {
  vpc_id     = "${aws_vpc.anupamvpc.id}"
  cidr_block = "10.42.6.0/24"
  availability_zone = "${var.availability_zone2}"


  tags = {
    Name = "db-anusubnet-2"
  }
}
resource "aws_subnet" "anusubnetnat1" {
  vpc_id     = "${aws_vpc.anupamvpc.id}"
  cidr_block = "10.42.7.0/24"
  availability_zone = "${var.availability_zone1}"


  tags = {
    Name = "nat-anusubnet-1"
  }
}
resource "aws_subnet" "anusubnetnat2" {
  vpc_id     = "${aws_vpc.anupamvpc.id}"
  cidr_block = "10.42.8.0/24"
  availability_zone = "${var.availability_zone2}"


  tags = {
    Name = "nat-anusubnet-2"
  }
}

######## IGW ###############

resource "aws_internet_gateway" "anupamvpc-igw" {
  vpc_id = "${aws_vpc.anupamvpc.id}"

  tags = {
    Name = "anupamvpc-igw"
  }
}

########### NAT ##############

resource "aws_eip" "nat" {
}

resource "aws_nat_gateway" "anupamvpc-natgw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.anusubnetnat2.id}"

  tags = {
    Name = "anupamvpc-nat"
  }
}

############# Route Tables ##########

resource "aws_route_table" "anupamvpc-public-rt" {
  vpc_id = "${aws_vpc.anupamvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.anupamvpc-igw.id}"
  }

  tags = {
    Name = "anupamvpc-public-rt"
  }
}

resource "aws_route_table" "anupamvpc-private-rt" {
  vpc_id = "${aws_vpc.anupamvpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.anupamvpc-natgw.id}"
  }

  tags = {
    Name = "anupamvpc-private-rt"
  }
}

######### PUBLIC Subnet association with rotute table    ######

resource "aws_route_table_association" "public-assoc-1" {
  subnet_id      = "${aws_subnet.anusubnet3.id}"
  route_table_id = "${aws_route_table.anupamvpc-public-rt.id}"
}
resource "aws_route_table_association" "public-assoc-2" {
  subnet_id      = "${aws_subnet.anusubnet4.id}"
  route_table_id = "${aws_route_table.anupamvpc-public-rt.id}"
}
resource "aws_route_table_association" "public-assoc-3" {
  subnet_id      = "${aws_subnet.anusubnetnat1.id}"
  route_table_id = "${aws_route_table.anupamvpc-public-rt.id}"
}
resource "aws_route_table_association" "public-assoc-4" {
  subnet_id      = "${aws_subnet.anusubnetnat2.id}"
  route_table_id = "${aws_route_table.anupamvpc-public-rt.id}"
}

########## PRIVATE Subnets association with rotute table ######

resource "aws_route_table_association" "private-assoc-1" {
  subnet_id      = "${aws_subnet.anusubnet1.id}"
  route_table_id = "${aws_route_table.anupamvpc-private-rt.id}"
}
resource "aws_route_table_association" "private-assoc-2" {
  subnet_id      = "${aws_subnet.anusubnet2.id}"
  route_table_id = "${aws_route_table.anupamvpc-private-rt.id}"
}
resource "aws_route_table_association" "private-assoc-3" {
  subnet_id      = "${aws_subnet.anusubnetdb1.id}"
  route_table_id = "${aws_route_table.anupamvpc-private-rt.id}"
}
resource "aws_route_table_association" "private-assoc-4" {
  subnet_id      = "${aws_subnet.anusubnetdb2.id}"
  route_table_id = "${aws_route_table.anupamvpc-private-rt.id}"
}


#########create instance###################

resource "aws_security_group" "pocsg" {
    name = "pocsg"
    description = "security group for devops poc"
    vpc_id = "${aws_vpc.anupamvpc.id}"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 12001
        to_port = 12001
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
   egress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_instance" "test_instance" {
        ami = "ami-0c322300a1dd5dc79"
        associate_public_ip_address = true
        instance_type = "t2.micro"
        key_name = "anupam_poc"
        vpc_security_group_ids = ["${aws_security_group.pocsg.id}"]
		subnet_id = "${aws_subnet.anusubnet3.id}"
        tags {
                Name="test-instance"
                CustomTagName="terraform"
        }
}
resource "aws_launch_configuration" "terraform-test-launchconfig" {
name_prefix = "terraform-test"
image_id = "ami-0c322300a1dd5dc79"
instance_type = "t2.micro"
key_name = "anupam_poc"
security_groups = ["${aws_security_group.pocsg.id}"]
}
resource "aws_autoscaling_group" "terraform-test-autoscaling" {
name = "terraform-test-autoscaling"
vpc_zone_identifier = ["${aws_subnet.anusubnet1.id}", "${aws_subnet.anusubnet2.id}"]
launch_configuration = "${aws_launch_configuration.terraform-test-launchconfig.name}"
min_size = 1
max_size = 2
health_check_grace_period = 300
health_check_type = "EC2"
force_delete = true
tag {
key = "Name"
value = "ec2 instance"
propagate_at_launch = true
}
}

# scale up alarm
resource "aws_autoscaling_policy" "terraform-test-cpu-policy" {
name = "terraform-test-cpu-policy"
autoscaling_group_name = "${aws_autoscaling_group.terraform-test-autoscaling.name}"
adjustment_type = "ChangeInCapacity"
scaling_adjustment = "1"
cooldown = "300"
policy_type = "SimpleScaling"
}
resource "aws_cloudwatch_metric_alarm" "terraform-test-cpu-alarm" {
alarm_name = "terraform-test-cpu-alarm"
alarm_description = "terraform-test-cpu-alarm"
comparison_operator = "GreaterThanOrEqualToThreshold"
evaluation_periods = "2"
metric_name = "CPUUtilization"
namespace = "AWS/EC2"
period = "120"
statistic = "Average"
threshold = "30"
dimensions = {
"AutoScalingGroupName" = "${aws_autoscaling_group.terraform-test-autoscaling.name}"
}
actions_enabled = true
alarm_actions = ["${aws_autoscaling_policy.terraform-test-cpu-policy.arn}"]
}
# scale down alarm
resource "aws_autoscaling_policy" "terraform-test-cpu-policy-scaledown" {
name = "terraform-test-cpu-policy-scaledown"
autoscaling_group_name = "${aws_autoscaling_group.terraform-test-autoscaling.name}"
adjustment_type = "ChangeInCapacity"
scaling_adjustment = "-1"
cooldown = "300"
policy_type = "SimpleScaling"
}
resource "aws_cloudwatch_metric_alarm" "terraform-test-cpu-alarm-scaledown" {
alarm_name = "terraform-test-cpu-alarm-scaledown"
alarm_description = "terraform-test-cpu-alarm-scaledown"
comparison_operator = "LessThanOrEqualToThreshold"
evaluation_periods = "2"
metric_name = "CPUUtilization"
namespace = "AWS/EC2"
period = "120"
statistic = "Average"
threshold = "5"
dimensions = {
"AutoScalingGroupName" = "${aws_autoscaling_group.terraform-test-autoscaling.name}"
}
actions_enabled = true
alarm_actions = ["${aws_autoscaling_policy.terraform-test-cpu-policy-scaledown.arn}"]
}
