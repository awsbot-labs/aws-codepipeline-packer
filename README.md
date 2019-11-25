# AWS CodePipeline Packer 
An example project to run packer project in an AWS CodePipeline project. 

## Contents
* buildspec.yml
* Makefile
* pipeline.yml

## Packer
The packer project creates an EC2 AMI.

## Pipeline
The pipeline is quite simply a CodeCommit source and CodeBuild project. You can set the version of terraform to use
as a parameter to the CloudFormation template.
