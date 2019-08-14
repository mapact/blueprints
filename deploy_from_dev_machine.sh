#!/bin/bash

# This tool is used to deploy blueprint from the privileged access workstation

# To run the deployment:
# Initialise the remote state first with ./deploy.sh
# ./deploy.sh [blueprint_name] [plan|apply|destroy]
# ex: ./deploy.sh blueprint_tranquility plan

# capture the current path
current_path=$(pwd)
blueprint_name=$1
tf_action=$2
shift 2

tf_command=$@

echo "tf_action  is : '$(echo ${tf_action})'"
echo "tf_command is : '$(echo ${tf_command})'"
echo "blueprint  is : '$(echo ${blueprint_name})'"

id=$(az resource list --tag stgtfstate=level0 | jq -r .[0].id)
stg=$(az storage account show --ids $id)

export storage_account_name=$(echo $stg | jq -r .name) && echo " - resource_group: ${storage_account_name}"
export resource_group=$(echo $stg | jq -r .resourceGroup) && echo " - resource_group: ${resource_group}"
export access_key=$(az storage account keys list --account-name ${storage_account_name} --resource-group ${resource_group} | jq -r .[0].value) && echo " - resource_group: ${access_key}"
export container=$(echo $stg  | jq -r .tags.container) && echo " - resource_group: ${container}"
export TF_VAR_prefix=$(echo $stg  | jq -r .tags.prefix) && echo " - resource_group: ${TF_VAR_prefix}"
tf_name="${blueprint_name}.tfstate"

function plan {
        echo "running terraform ${tf_action} with ${tf_command}"
        terraform plan ${tf_command} \
                -out=${blueprint_name}.tfplan
}

function apply {
        echo "running terraform $tf_action with ${tf_command}"
        terraform apply \
                -no-color \
                ${blueprint_name}.tfplan
}

function destroy {

        terraform destroy ${tf_command} \
                -refresh=true
}

function deploy_blueprint {
        
        cd ${blueprint_name}

        terraform init \
                -reconfigure \
                -backend=true \
                -lock=false \
                -backend-config storage_account_name=${storage_account_name} \
                -backend-config container_name=${container} \
                -backend-config access_key=${access_key} \
                -backend-config key=${tf_name}

        if [ ${tf_action} == "plan" ]; then
                plan
        fi

        if [ ${tf_action} == "apply" ]; then
                plan
                apply
        fi

        if [ ${tf_action} == "destroy" ]; then
                destroy
        fi

        if [ -f ${blueprint_name}.tfplan ]; then
                echo "Deleting file ${blueprint_name}.tfplan"
                rm ${blueprint_name}.tfplan
        fi

        cd "${current_path}"

}

echo ''
echo "Deploying blueprint '${blueprint_name}' with terraform action '${tf_action}' & command '${tf_command}'"
echo ''
deploy_blueprint
