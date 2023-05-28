resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "my_sg" {
  name        = "my-security-group"
  description = "Allow SSH and Prometheus ports"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type          = "t2.micro"
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Створення EC2 і виконання конфігурації за допомогою User Data і Terraform Remote Exec
resource "aws_instance" "ec2_instance_1" {
  ami           = var.ami
  instance_type = var.type
  key_name      = "my-key-pair"

  user_data = <<-EOF
    #!/bin/bash
    # Встановлення Prometheus
  docker run -d --name prometheus -p 9090:9090 prom/prometheus

  # Встановлення Node Exporter
  wget https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz
  tar xvfz node_exporter-1.2.2.linux-amd64.tar.gz
  sudo mv node_exporter-1.2.2.linux-amd64/node_exporter /usr/local/bin/
  rm -rf node_exporter-1.2.2.linux-amd64*
  sudo useradd --no-create-home --shell /bin/false node_exporter
  sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

  sudo systemctl daemon-reload
  sudo systemctl enable node_exporter
  sudo systemctl start node_exporter

  # Встановлення Cadvisor Exporter
  wget https://github.com/google/cadvisor/releases/download/v0.41.0/cadvisor
  chmod +x cadvisor
  sudo mv cadvisor /usr/local/bin/

  sudo systemctl daemon-reload
  sudo systemctl enable cadvisor
  sudo systemctl start cadvisor
  EOF

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh"
    ]
  }
}

resource "aws_instance" "ec2_instance_2" {
  ami           = var.ami
  instance_type = var.type
  key_name      = "my-key-pair"

  user_data = <<-EOF
  #!/bin/bash
  # Встановлення Node Exporter
  wget https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz
  tar xvfz node_exporter-1.2.2.linux-amd64.tar.gz
  sudo mv node_exporter-1.2.2.linux-amd64/node_exporter /usr/local/bin/
  rm -rf node_exporter-1.2.2.linux-amd64*
  sudo useradd --no-create-home --shell /bin/false node_exporter
  sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

  sudo systemctl daemon-reload
  sudo systemctl enable node_exporter
  sudo systemctl start node_exporter

  # Встановлення Cadvisor Exporter
  wget https://github.com/google/cadvisor/releases/download/v0.41.0/cadvisor
  chmod +x cadvisor
  sudo mv cadvisor /usr/local/bin/

  sudo systemctl daemon-reload
  sudo systemctl enable cadvisor
  sudo systemctl start cadvisor

  EOF

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh"
    ]
  }
}
