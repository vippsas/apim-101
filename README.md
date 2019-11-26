# [IN PROGRESS] API Management 101

This repository contains presentations and source code that is used for internal workshops on Azure API Management.

## Understanding Azure API Management

### Introduction

What you need to know to get started with Azure API Management [(PowerPoint)](apim-101-introduction.pptx).

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

### Task 5: Mock the payments API
The payments API doesn't have an implementation yet. In this task we will mock its response with policies. To make it easy to change the response text later, we define the response text as a placeholder. We use Named values for that.

### Task 6: Change URLs in the response
The response from our petstore API and the one from the conference API contain their original URLs, not the one from our API Management instance. Let's replace those URLs to our public URL.

### Task 7: Make sure petstore API can handle high traffic
In a few weeks is a large Microsoft event with lots of great speakers. Every time there is a large Microsoft event, lots of clients will probably use our conference API, especially the `/sessions` endpoint. We need to make sure that our API Gateway won't overload this endpoint. In this task, we will use throttling for the `/sessions` endpoint only.

## Maintenance in Azure API Management

## References
[Policy examples](https://github.com/Azure/api-management-policy-snippets)
