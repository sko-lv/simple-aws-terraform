Simple terraform project
-------------------------
Create on AWS:  
1. EC2 with custom volumes  
2. DNS zone  
3. DNS record for EC2  
4. ELB  
+ Terraform state back-end configured on s3 (now w/o DynamoDB)  
 


---
Manual:

Generate set env script:  
echo -e 'export TF_VAR_aws_access_key="XXXreplaceXXX"\nexport TF_VAR_aws_secret_key="XXXreplaceXXX"\nenv |grep TF_' > set-env.sh && chmod +x set-env.sh  

Do not forget update the file!  

Run before terraform:  
. ./set-env.sh  

Create infrastructure:  
terraform init  
terraform plan  
terraform apply  

