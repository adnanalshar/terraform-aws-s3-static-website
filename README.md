# Terraform module for AWS S3 Static Website and Terraform remote state

This repository provides Terraform code for creating a remote state for Terraform (S3 and DynamoDB) as well as Terraform code to provision S3 static website.

## Features

The Terraform code provisions the following:

For the remote state:

- **S3**:
    - An S3 bucket to save the Terraform state file in
- **DynamoDB**:
    - A DynamoDB table for state file locking

For the static website:

- **S3**:
    - A bucket for the root domain
    - A bucket for the www domain
- **ACM**:
    - A wildcard certificate for your domain
- **CloudFront**:
    - A CloudFront distribution for the root domain
    - A CloudFront distribution for the www domain
- **Route 53**:
    - A public hosted zone
    - Two alias records for both CloudFront distrbutions

## Prerequisites

- AWS CLI (version used is 2.17.13)
- Terraform (version used is 1.9.2)
- AWS Credentials (access key and secret key)
- An AWS account and a user with credentials for programmatic access
- A domain that you own (for example, Route 53 or GoDaddy)
- Basic knowledge of AWS and Terraform

## Usage

To make use of the Terraform code, I have added a step-by-step instruction on my website [here](https://www.adnanalshar.com/projects/static-website/setting-up).