Prerequisites 

1. Docker desktop with kubernetes enabled.
2. kubectl
3. Terraform
4. WSL (only for windows PC)

Steps to recreate deployment:

1. Login to github.com

2. Create a new Project and name the repository `terraform-local-ruby` (Follow the structure).

3. Provide description for the repo, select Private and select `Add a README file` and `Add .gitignore` to init the repo.

4. Clone the repository locally and copy the resource files and push it to remote.

----------------- Platform Configuration Procedure ----------------------------------------------

5. Run below command to setup a local docker registry, build a docker image having the http_server app and push it to the local registry created.

$chmod +x setup.sh
$bash setup.sh

The above script will create docker registry locally which can be accessed on port 5000 and build application container image.

To check the registry run $docker ps
To see the images run $docker image ls

6. Now to build the application run below sequence of terraform commands

    a. $terraform init
    b. $terraform plan
    c. $terraform apply

7. Now try to browse the application from browser using http://localhost or try curl http://localhost -k

8. To check the status of the cluster and pods use below command

$kubectl get deploy,svc,pods

8. To destroy the environment run below set of commands

    a. $terraform destroy
    b. docker stop <container id of the registry>
    c. docker rm <container id of the registry>
    d. docker rmi <image id>