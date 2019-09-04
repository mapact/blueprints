# Introduction 
Welcome to Azure Terraform Blueprints.
Using this serie of blueprints based on Terraform, you will be able to deploy easily a complex environment based on virtual datacenter and cloud adoption framrwork concepts. <br/>
We designed this serie of blueprints to offer a modular and highly specialized approach, each blueprint adding a layer of features and the associated security, just by customizing a set of variables.


# Getting Started
The fastest way to get started is to leverage Azure Cloud Shell:
1. Logon to https://shell.azure.com
2. Select Bash as scripting environment.
3. Go to the clouddrive directory: 
```
cd clouddrive
```
4. Clone the GitHub repo from http://aka.ms/tf-landingzones
```
git clone https://github.com/aztfmod/blueprints.git 
``` 
5. Initialize the environment - this will create the fundamentals for the Terraform state, like Storage Account, Azure Key Vault, and the managed identities.
```
./launchpad.sh 
```

6. Deploy your first tranquility blueprint 

```
./launchpad.sh blueprint_tranquility plan
```
Review the configuration and if you are ok with it, deploy it by running: 
```
./launchpad.sh blueprint_tranquility apply
```
Have fun playing with the blueprint an once you are done, you can simply delete the deployement using: 
```
./launchpad.sh blueprint_tranquility destroy
```
The foundations will remain on your subscription so next run, you can jump to step 6 directly. 
More details about tranquility can be found in the blueprint folder ./blueprint_tranquility

<br/>




# Contribute
Pull requests are welcome to evolve the framework and integrate new features.