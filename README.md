# AWS Static Site Template

A simple project to make setting up a static website on AWS easier

## Usage

### Setup

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