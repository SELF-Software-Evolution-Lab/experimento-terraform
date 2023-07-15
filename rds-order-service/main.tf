#main.tf
#defining the provider as aws
provider "aws" {
    shared_credentials_files = ["~/.aws/credentials"]
}
#create a security group for RDS Database Instance
resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#create a RDS Database Instance
resource "aws_db_instance" "order_service_db" {
  identifier              = "order-service-db"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  publicly_accessible     = true
  username             = "daytrader"
  password             = "daytraderpassword"
  parameter_group_name    = aws_db_parameter_group.order-service-db.name
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot  = true
}

resource "aws_db_parameter_group" "order-service-db" {
  name        = "order-service-db-parameter-group"
  family      = "postgres14"
  description = "Parameter group for PostgreSQL 14"
}
