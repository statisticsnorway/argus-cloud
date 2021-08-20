gcloud compute networks create brunost-team-vpc \
  --project=team-brunost \
  --subnet-mode=auto \
  --mtu=1460 \
  --bgp-routing-mode=regional

gcloud compute firewall-rules create brunost-team-vpc-allow-internal \
  --project=team-brunost \
  --network=projects/team-brunost/global/networks/brunost-team-vpc \
  --direction=INGRESS \
  --priority=65534 \
  --source-ranges=10.128.0.0/9 \
  --action=ALLOW \
  --rules=tcp,udp,icmp