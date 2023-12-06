data "aws_ami" "bastion" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

resource "aws_key_pair" "bastion" {
  key_name   = "${local.namespace}-bastion"
  public_key = var.bastion_public_key
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.bastion.id
  instance_type               = "t3a.nano"
  associate_public_ip_address = true
  source_dest_check           = false

  subnet_id              = module.subnets.public_subnet_ids[1]
  private_ip             = cidrhost(module.subnets.public_subnet_cidrs[1], 20)
  vpc_security_group_ids = [aws_security_group.bastion.id]

  key_name = aws_key_pair.bastion.key_name

  ebs_optimized = true

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = true
  }

  tags = {
    Name = "${local.namespace}-bastion"
  }
}

resource "aws_security_group" "bastion" {
  name        = "${local.namespace}-bastion"
  description = "Inbound - Security Group attached to the bastion instance"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
