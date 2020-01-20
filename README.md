# tf-aws

## Story So Far

### VPC, Subnets & Security

The script starts with main.tf pulling in the variables.tf.

It configures the network (VPC & subnets) in Site (also pulling in variables.tf).
The main setup is network.tf

It sets up the vpc, the igw, a nat gateway, and the public and private subnets with route tables.

### Security

Next steps will be security module. 
This needs the security groups and the network ACLs to be configured.

#### tf-EKS Template

The EKS template used the below...

rst_webproxy_sg.tf sets up the security groups (i.e. firewall) for the webproxy group - inbound HTTP/s & SSH from specific IP (mine); outbound, anywhere.

nat-sg.tf sets egress for private subnet on HTTP/s & ICMP, with all outgoing. Also allows web access to the private subnet from public subnet.

bastion-sg.tf allows SSH into bastion from specific IP (mine). Bastion also allows outgoing SSH.

### Launch Config

main.tf pulls through webproxy security groups for launch configs. 

webapp-lc.tf sets up the webproxy launch config, instance type and security groups. It runs the actions in the userdata.sh script on startup.

### Load Balancers

The intention is to use Kubernetes with internal load balancers in the public subnets.

### Autoscaling Groups

This can be left till the end.

webapp-asg.tf sets up auto-scaling.

### Instances

The instances kick off the various servers...

## Next Steps

* Investigate whether EKS nodes need to be on a particular sg & how to isolate networks
    * Recommended approach is for Kubernetes to be in the public net & workers in private
* Security Best Practices for VPC 
    * https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-best-practices.html
    * Use multiple availability zones for deployments
    * Use security groups and Network ACLs (firewall)
        * Use 100, 200, 300 for rules to have room for additions
    * Set IAM Polices
    * Use Amazon CloudWatch to monitor VPC/VPN connections
* Add in EKS setup
* Confirm deployment process