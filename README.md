# [IN PROGRESS] API Management 101

This repository contains presentations and source code that is used for internal workshops on Azure API Management.

## Understanding Azure API Management

### Introduction

What you need to know to get started with Azure API Management [(PowerPoint)](http://notYetDefined.com).

In the following tasks, we will create an API Gateway for our customers that want to use APIs that we manage.

### Task 1: Setup
Make sure that you can open a console from your Azure Portal.

### Task 2: Provision an instance of Azure API Management
Use PowerShell from the console in the Azure Portal. Provision an instance of APIM and make sure that whatever you will provision in this workshop will be deleted later together. Choose the purchasable Stock Keeping Unit (SKU) that bills per execution.

### Task 3: Deploy 3 APIs in 3 different ways
In this task we'll deploy 3 APIs that we will need in the task that follows.

1. Deploy the famous [conference API](https://conferenceapi.azurewebsites.net?format=json) to your APIM instance with PowerShell and test it from your favorite browser.
1. Deploy the [petstore api](https://petstore.swagger.io/v2/swagger.json) to your APIM instance directly from within the Azure Portal.
1. Create an own API called `payments API` with a basic GET endpoint directly from within in the Azure Portal. This API won't do much since it is missing an actual implementation yet. We will fix this in a later task.

### Task 4: Secure your APIs
Create two users. One user is an iOS developer that has written an App that shows Microsoft conferences. He needs only access to your `conference API`. The other user represents your own Android App that implements a pet store. This client need access to the `petstore API` and the `payments API`. In this task you will need to look at products.

## Policies in Azure API Management

Introduction to policies [(PowerPoint)](http://notYetDefined.com)

### Working with NamedValues

### Workshop tasks

https://github.com/Azure/api-management-policy-snippets

1. Replace one endpoint with a static response
1. Replace response urls
1. Add correlation id to inbound request
1. Make sure your API can handle high traffic
1. Call out to an HTTP endpoint and cache the response
1. Filter response content based on product name
1. Canary Deployment

## Maintenance in Azure API Management
