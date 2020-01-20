resource "aws_security_group" "trt_pub" {
    count = length(var.public_subnets)
    name = "trt_test_${count.index}"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.public_cidr_blocks[count.index]}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    vpc_id = var.vpc_id
}