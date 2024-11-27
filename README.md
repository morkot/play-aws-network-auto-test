# Automated network testing in AWS

Play with different ways to automatically test connectivity between different network resources like EIN, Transit Gateway, random IP, etc.

Plan to try:

1. VPC Reachability Analyzer
2. Route Analyzer

## References
- https://docs.aws.amazon.com/vpc/latest/reachability/what-is-reachability-analyzer.html
- https://docs.aws.amazon.com/vpc/latest/reachability/multi-account.html
- https://github.com/aws-samples/vpc-reachability-analyzer-multi-region
- https://docs.aws.amazon.com/network-manager/latest/tgwnm/route-analyzer.html

## Use cases

```shell
cd one-account-two-refions
terraform init
teraform plan
terraform apply

#Example aws-cli commands
aws ec2 create-network-insights-path \
    --source tgw-0a7b381eb0f38706c \
    --destination eni-0b95f4d6d34609318 \
    --protocol TCP \
    --filter-at-source file://source-filter.json

aws ec2 start-network-insights-analysis --network-insights-path-id nip-095e8edc40fb32001

aws ec2 describe-network-insights-analyses --network-insights-analysis-ids nia-00a3176429aeba6ec
```
