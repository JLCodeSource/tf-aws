variable "rules" {
    description = "Map of known security group rules (define as 'name' = ['from port', 'to port', 'protocol', 'description'])"
    type = map(list(any))

    # Protocols (tcp, udp, icmp, all - are allowed keywords) or numbers (from
    # https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml):
    # All = -1, IPV4-ICMP = 1, TCP = 6, UDP = 16, IPV6-ICMP = 58

    default = {
        # DNS
        dns-udp = [53, 53, "udp", "DNS"]
        dns-tcp = [53, 53, "tcp", "DNS"]
        # Elasticsearch
        elasticsearch-rest-tcp = [9200, 9200, "tcp", "Elasticsearch REST interface"]
        elasticsearch-java-tcp = [9300, 9300, "tcp", "Elasticsearch Java interface"]
        # Gitea
        gitea-web-tcp = [3000, 3000, "tcp", "Gitea Web"]
        gitea-ssh-tcp = [2022, 2022, "tcp", "Gitea SSH"]
        # HTTP
        #http-80-tcp   = [80, 80, "tcp", "HTTP"]
        #http-8080-tcp = [8080, 8080, "tcp", "HTTP"]
        # HTTPS
        https-443-tcp  = [443, 443, "tcp", "HTTPS"]
        https-8443-tcp = [8443, 8443, "tcp", "HTTPS"]
        # Kibana
        kibana-tcp = [5601, 5601, "tcp", "Kibana"] 
        # Logstash
        logstash-tcp  = [5044, 5044, "tcp", "Logstash"]
        # LDAPS
        #ldaps-tcp = [636, 636, "tcp", "LDAPS"]
        # Memcached
        #memcached-tcp = [11211, 11211, "tcp", "Memcached"]
        # NTP - Network Time Protocol
        ntp-udp = [123, 123, "udp", "NTP"]
        # OpenVPN
        #openvpn-udp       = [1194, 1194, "udp", "OpenVPN"]
        #openvpn-tcp       = [943, 943, "tcp", "OpenVPN"]
        #openvpn-https-tcp = [443, 443, "tcp", "OpenVPN"]   
        # RDP
        rdp-tcp = [3389, 3389, "tcp", "Remote Desktop"]
        rdp-udp = [3389, 3389, "udp", "Remote Desktop"] 
        # SSH
        ssh-tcp = [22, 22, "tcp", "SSH"]
        # Open all ports & protocols
        all-all       = [-1, -1, "-1", "All protocols"]
        all-tcp       = [0, 65535, "tcp", "All TCP ports"]
        all-udp       = [0, 65535, "udp", "All UDP ports"]
        all-icmp      = [-1, -1, "icmp", "All IPV4 ICMP"]
        all-ipv6-icmp = [-1, -1, 58, "All IPV6 ICMP"]
        # This is a fallback rule to pass to lookup() as default. It does not open anything, because it should never be used.
        _ = ["", "", ""]
    }
}

variable "auto_groups" {
    description = "Map of groups of security group rules to use to generate modules (see update_groups.sh)"
    type        = map(map(list(string)))

    # Valid keys - ingress_rules, egress_rules, ingress_with_self, egress_with_self
    default = {
        elasticsearch = {
            ingress_rules     = ["elasticsearch-rest-tcp", "elasticsearch-java-tcp"]
            ingress_with_self = ["all-all"]
            egress_rules      = ["all-all"]
        }
        gitea = {
            ingress_rules     = ["gitea-web-tcp", "gitea-ssh-tcp"]
            ingress_with_self = ["all-all"]
            egress_rules      = ["all-all"]
        }
/*         http-80 = {
            ingress_rules     = ["http-80-tcp"]
            ingress_with_self = ["all-all"]
            egress_rules      = ["all-all"]
        }
        http-8080 = {
            ingress_rules     = ["http-8080-tcp"]
            ingress_with_self = ["all-all"]
            egress_rules      = ["all-all"]
        } */
        https-443 = {
            ingress_rules     = ["https-443-tcp"]
            ingress_with_self = ["all-all"]
            egress_rules      = ["all-all"]
        }
        https-8443 = {
            ingress_rules     = ["https-8443-tcp"]
            ingress_with_self = ["all-all"]
            egress_rules      = ["all-all"]
        }
        kibana = {
            ingress_rules     = ["kibana-tcp"]
            ingress_with_self = ["all-all"]
            egress_rules      = ["all-all"]
        }
        logstash = {
            ingress_rules     = ["logstash-tcp"]
            ingress_with_self = ["all-all"]
            egress_rules      = ["all-all"]
        }
        ntp = {
            ingress_rules     = ["ntp-udp"]
            ingress_with_self = ["all-all"]
            egress_rules      = ["all-all"]
        }
        rdp = {
            ingress_rules     = ["rdp-tcp", "rdp-udp"]
            ingress_with_self = ["all-all"]
            egress_rules      = ["all-all"]
        }
        ssh = {
            ingress_rules     = ["ssh-tcp"]
            ingress_with_self = ["all-all"]
            egress_rules      = ["all-all"]
    }
}