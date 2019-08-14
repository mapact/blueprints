#!/bin/bash

# To run the deployment:
# Initialize the remote state first with ./initialize.sh
# Initialize the devops environment with ./initialize.sh [plan|apply|destroy]
# ex: ./deploy.sh blueprint_tranquility plan

# capture the current path
current_path=$(pwd)
tf_action=$1
shift 1
tf_command=$@


tf_version=0.12.5

function initialize_state {
        echo 'Initializing remote terraform state'
        cd tfstate
        terraform init
        terraform apply -auto-approve
        cd "${current_path}"
}

function plan {
        echo "running terraform plan with $tf_command"
        terraform plan $tf_command \
                -out=${blueprint_name}.tfplan
}

function apply {
        echo 'running terraform apply'
        terraform apply \
                -no-color \
                ${blueprint_name}.tfplan
        
        cd "${current_path}"
        # This is moved after the devops blueprint has been deployed and provisioned into the tfstate
        echo 'Moving tfstate to Azure storage account'
        upload_tfstate
}


function deploy_blueprint {
        cd tfstate
        export TF_VAR_tfstate_current_level=$(terraform output tfstate_map)
        export TF_VAR_deployment_msi=$(terraform output deployment_msi)
        export TF_VAR_keyvault_id=$(terraform output keyvault_id)
        storage_account_name=$(terraform output storage_account_name)
        echo ${storage_account_name}
        resource_group=$(terraform output resource_group)
        access_key=$(az storage account keys list --account-name ${storage_account_name} --resource-group ${resource_group} | jq -r .[0].value)
        container=$(terraform output container)
        export TF_VAR_prefix=$(terraform output prefix)
        tf_name="${blueprint_name}.tfstate"

        # Set the security context under the devops app
        export ARM_SUBSCRIPTION_ID=$(az account show | jq -r .id) && echo " - subscription id: ${ARM_SUBSCRIPTION_ID}"
        export ARM_CLIENT_ID=$(terraform output devops_application_id)
        export ARM_CLIENT_SECRET=$(terraform output devops_client_secret)
        export ARM_TENANT_ID=$(az account show | jq -r .tenantId) && echo " - tenant id: ${ARM_TENANT_ID}"
 
        cd "../${blueprint_name}"
        pwd 


        terraform init \
                -reconfigure \
                -backend=true \
                -lock=false \
                -backend-config storage_account_name=${storage_account_name} \
                -backend-config container_name=${container} \
                -backend-config access_key=${access_key} \
                -backend-config key=${tf_name}

        if [ $tf_action == "plan" ]; then
                plan
        fi

        if [ $tf_action == "apply" ]; then
                plan
                apply
        fi

        if [ -f ${blueprint_name}.tfplan ]; then
                echo "Deleting file ${blueprint_name}.tfplan"
                rm ${blueprint_name}.tfplan
        fi

        cd "${current_path}"

}

function upload_tfstate {
        pwd
        cd tfstate

        blobFileName=$(terraform output tfstate-blob-name)

        az storage blob upload -f terraform.tfstate \
                -c ${container} \
                -n ${blobFileName} \
                --account-key ${access_key} \
                --account-name ${storage_account_name}

        rm -f terraform.tfstate
}

# Initialise storage account to store remote terraform state
if [[ -z "$tf_action" ]]; then
        initialize_state
fi

if [[ -n "${tf_action}" && -f tfstate/terraform.tfstate ]]; then
        blueprint_name="blueprint_azure_devops"
        tf_command="$(echo $tf_command) -var-file=./tfvars/_var.azure_devops.tfvars -var-file ./tfvars/_var.environments.tfvars"
        echo ''
        echo "Deploying blueprint ${blueprint_name} with terraform command '${tf_action} ${tf_command}'"
        echo ''
        deploy_blueprint

else
        echo ''
        echo 'Initialize the Azure DevOps environment to deploy the blueprints by running the terraform command [plan|apply]'
        echo './initialize.sh plan'
        echo ''
fi

