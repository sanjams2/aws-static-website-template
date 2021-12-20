# AWS Static Site Template

A simple project to make setting up a static website on AWS easier

## Usage

### Prereqs
1. Ensure you have an AWS account 
2. Ensure you have the AWS cli installed. You can test by running `aws help`
3. Ensure you have an [AWS cli profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) configured 

### Env Setup

#### Manual

Run the following and ensure you set `PROJECT_NAME` correctly:
```bash
PROJECT_NAME="<put your project name here>"

git clone https://github.com/sanjams2/aws-static-website-template.git
mv aws-static-website-template $PROJECT_NAME
cd $PROJECT_NAME
rm -rf .git
git init
```

You will need to update the Makefile to ensure your aws profile and domain name are configured properly

#### Github Template

You can also use the GitHub templates feature by clicking "Use this template" or clicking [here](https://github.com/sanjams2/aws-static-website-template/generate)

You will need to update the Makefile to ensure your aws profile and domain name are configured properly

### Infra Creation

Run the following from the workspace root:

```bash
make cfn-create
```

This will create the necessary infrastructure needed to host a static website via an AWS CloudFormation template.

#### Certificate Issueance

The CloudFormation Template will create an certificate for enabling https traffic to your website. 
To do this, a certificate is created using Amazon Certificate Manager (ACM). Before ACM will issue you a certificate
for your domain, you will need to verify you own your domain.

To verify you own your domain, you will need to create a special CNAME record for a specific sub domain of your website domain. 
ACM documentation on this can be found [here](https://docs.aws.amazon.com/acm/latest/userguide/dns-validation.html). 

It is important to note that your CloudFormation template will sit in a pending state until you perform the DNS ownership verification. 


### Updating Your Site

To update your site, simply run:

```bash
make release
```

This will upload the contents of the `site` folder to S3 and invalidate the current CloudFront distribution so your new changes will be picked up