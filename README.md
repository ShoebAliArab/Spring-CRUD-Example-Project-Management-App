#Make a t2.xLarge EC2-Instance with 30Gb of EBS
Clone the GitHub repo

git clone https://github.com/Shoebaliarab/Spring-CRUD-Example-Project-Management-App

cd Spring-CRUD-Example-Project-Management-App

Create a Dockerfile in the root of your project. This file will contain instructions for building the Docker image.

# Use an official OpenJDK runtime as a base image
FROM openjdk:8-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the application JAR file into the container at /app
COPY target/project-management-0.0.1-SNAPSHOT.jar /app/app.jar

# Expose the port the app runs on
EXPOSE 8080

# Specify the command to run on container startup
CMD ["java", "-jar", "app.jar"]


Install docker on the instance  
Install maven on the instance to build the application and check if it runs
![Screenshot 2024-02-15 000811](https://github.com/ShoebAliArab/Spring-CRUD-Example-Project-Management-App/assets/129241220/3be3e37e-f17b-47d2-9cef-ecb1de49c0e7)
Step 1: Download the JDK Binaries

Go to the URL: https://jdk.java.net/13/ Copy the download link for Linux/x64 build. Then use the below command to download and extract it.

$ wget https://download.java.net/java/GA/jdk13.0.1/cec27d702aa74d5a8630c65ae61e4305/9/GPL/openjdk-13.0.1_linux-x64_bin.tar.gz

$ tar -xvf openjdk-13.0.1_linux-x64_bin.tar.gz

$ mv jdk-13.0.1 /opt/

I have moved JDK to /opt, you can keep it anywhere in the file system.

Step 2: Setting JAVA_HOME and Path Environment Variables

Open .profile file from the home directory and add the following lines to it.

JAVA_HOME='/opt/jdk-13.0.1'

PATH="$JAVA_HOME/bin:$PATH"

export PATH

You can relaunch the terminal or execute source .profile command to apply the configuration changes.

Step 3: Verify the Java Installation

You can run java -version command to verify the JDK installation.

$ java -version

openjdk version "13.0.1" 2019-10-15

OpenJDK Runtime Environment (build 13.0.1+9)

OpenJDK 64-Bit Server VM (build 13.0.1+9, mixed mode, sharing)

$

Installing Maven on Linux/Ubuntu

We will install Maven in a similar way that we have installed JDK in the Linux system.

Step 1: Download the Maven Binaries

Go to the URL: https://maven.apache.org/download.cgi Copy the link for the “Binary tar.gz archive” file. Then run the following commands to download and untar it.

$ wget https://mirrors.estointernet.in/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz

$ tar -xvf apache-maven-3.6.3-bin.tar.gz

$ mv apache-maven-3.6.3 /opt/

Step 2: Setting M2_HOME and Path Variables

Add the following lines to the user profile file (.profile).

M2_HOME='/opt/apache-maven-3.6.3'

PATH="$M2_HOME/bin:$PATH"

export PATH

Relaunch the terminal or execute source .profile to apply the changes.

Step 3: Verify the Maven installation

Execute mvn -version command and it should produce the following output.

$ mvn -version

Apache Maven 3.6.3 (cecedd343002696d0abb50b32b541b8a6ba2883f)

Maven home: /opt/apache-maven-3.6.3

Java version: 13.0.1, vendor: Oracle Corporation, runtime: /opt/jdk-13.0.1

Default locale: en, platform encoding: UTF-8

OS name: "linux", version: "4.15.0-47-generic", arch: "amd64", family: "unix"

$



Install Jenkins on the instance 

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \

  
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update

sudo apt-get install Jenkins


Jenkins requires Java to run, yet not all Linux distributions include Java by default. Additionally, not all Java versions are compatible with Jenkins.

There are multiple Java implementations which you can use. OpenJDK is the most popular one at the moment, we will use it in this guide.

Update the Debian apt repositories, install OpenJDK 17, and check the installation with the commands:

sudo apt update

sudo apt install fontconfig openjdk-17-jre

java -version

Setup Jenkins install all suggested plugins and setup username and password
After that make a pipeline project on Jenkins names “DockerPipeline”

![Screenshot 2024-02-20 121903](https://github.com/ShoebAliArab/Spring-CRUD-Example-Project-Management-App/assets/129241220/63d79995-856e-48c2-ad0d-3f759fee596f)

First enter (Docker, GitHub) credentials in Jenkins and save it as secrettext
Afterwards write the Jenkins pipeline as shown in GitHub Repo (Filename:Jenkinsfile)
Setup poll SCM for automatic build when any changes are made.
![Screenshot 2024-02-20 121853](https://github.com/ShoebAliArab/Spring-CRUD-Example-Project-Management-App/assets/129241220/e07458bf-f5b6-413c-b73e-c78a2f936563)
Trigger the build manually to check if the application is getting built as intended.
Whenever the pipeline is triggered and the app is built the app automatically gets updated on the Docker Hub.
Setup an EKS Cluster to deploy the application
Name: prod
Use K8S version 1.28

Create an IAM role 'eks-cluster-role' with 1 policy attached: AmazonEKSClusterPolicy
Create another IAM role 'eks-node-grp-role' with 3 policies attached: 
(Allows EC2 instances to call AWS services on your behalf.)
    - AmazonEKSWorkerNodePolicy
    - AmazonEC2ContainerRegistryReadOnly
    - AmazonEKS_CNI_Policy

Choose default VPC, Choose 2 or 3 subnets
Choose a security group which open the ports 22, 80, 8080
cluster endpoint access: public

# For VPC CNI, CoreDNS and kube-proxy, choose the default versions, For CNI, latest and default are 
# different. But go with default.

Click 'Create'. This process will take 10-12 minutes. Wait till your cluster shows up as Active. 

Add Node Groups to our cluster

Now, let’s add the worker nodes where the pods can run

Open the cluster > Compute > Add NodeGrp
Name: Worker-eks-nodegrp-1 
Select the role you already created
Leave default values for everything else

AMI - choose the default 1 (Amazon Linux 2)
change desired/minimum/maximum to 1 (from 2)
Enable SSH access. Choose a security group which allows all traffic access 

Choose default values for other fields 

Node group creation may take 2-3 minutes



Connect to a cluster using AWS Configure.Provide your AWS Access Key ID, Secret Access Key, default region, and output format

GO to your Instance install aws cli using 
apt install aws-cli

Install kubectl using 
Sudo snap install kubectl --classic
aws eks --region ap-south-1 update-kubeconfig --name Prod

Check if it you are connected properly to the EKS cluster by using the command 

Kubectl get nodes

If there are nodes present which you have created in aws console then you have successfully connected to a cluster

Install Helm 
If you're using Linux, install the binaries with the following commands.
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

MYSQL INSTALLATION
 bash
helm install my-release oci://registry-1.docker.io/bitnamicharts/mysql
![Screenshot 2024-02-17 170707](https://github.com/ShoebAliArab/Spring-CRUD-Example-Project-Management-App/assets/129241220/b619fc35-e344-4181-bb6a-76b72d001d8e)

Run this command to get administrator credentials of MYSQL
echo Username: root
  MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default my-release-mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d)

![Screenshot 2024-02-17 195342](https://github.com/ShoebAliArab/Spring-CRUD-Example-Project-Management-App/assets/129241220/9a803660-97b0-4d1a-9383-09d2e0f6b0bf)


To connect to your database:

  1. Run a pod that you can use as a client:
kubectl run my-release-mysql-client --rm --tty -i --restart='Never' --image  registry-1.docker.io/bitnami/mysql:8.0.36-debian-11-r20 --namespace default --env MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --command – bash
make a pv to attach to pvc
After MYSQL pod is active write the YAML for you application.
spring-deployment.yaml
spring-ingress.yaml
spring-service.yaml
apply all the files
make the changes in application.properties file on github .
as you have setup poll scm when you make changes on that file your build will take place automatically and the latest image will be updated on dockerHub and your application will be deployed using that image on EKS cluster.

Installing Prometheus and Grafana Dashboard 
add the Helm Stable Charts for your local client. Execute the below command:
helm repo add stable https://charts.helm.sh/stable
Add Prometheus Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
Create Prometheus namespace
kubectl create namespace prometheus
Install Prometheus
helm install stable prometheus-community/kube-prometheus-stack -n prometheus
To check whether Prometheus is installed or not use the below command
kubectl get pods -n prometheus
to check the services file (svc) of the Prometheus
kubectl get svc -n prometheus

Grafana will be coming along with Prometheus as the stable version
This output is conformation that our Prometheus is installed successfully
there is no need of installing Grafana as a separate tool it comes along with Prometheus
let’s expose Prometheus and Grafana to the external world through loadbalancer

kubectl edit svc stable-kube-prometheus-sta-prometheus -n Prometheus

edit the type from ClusterIP to LoadBalancer
![Screenshot 2024-02-20 124552](https://github.com/ShoebAliArab/Spring-CRUD-Example-Project-Management-App/assets/129241220/301697c5-8e2e-4e73-8df9-d02248b5cf41)
![Screenshot 2024-02-20 124612](https://github.com/ShoebAliArab/Spring-CRUD-Example-Project-Management-App/assets/129241220/a1a0a64c-038a-4999-aad5-f9115bb9c015)

we can use a Prometheus UI for monitoring the EKSbut the UI of Prometheus is not a convent for the user Grafana will extract the matrix from the Prometheus UI and show it in a user-friendly manner
let’s change the SVC file of the Grafana and expose it to the outer world
command to edit the SVC file of grafana
kubectl edit svc stable-grafana -n prometheus
edit the type from ClusterIP to LoadBalancer
use the link of the LoadBalancer and access from the Browser

kubectl get secret --namespace prometheus stable-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
use the above command to get the password
the user name is admin
Create a Dashboard in Grafana
create a Dashboard by importing

![Screenshot 2024-02-20 115747](https://github.com/ShoebAliArab/Spring-CRUD-Example-Project-Management-App/assets/129241220/8670ba1d-8c29-4379-ad3e-2d0790ebbc74)

click on Import and import the dashboard with numbers
![Screenshot 2024-02-20 115841](https://github.com/ShoebAliArab/Spring-CRUD-Example-Project-Management-App/assets/129241220/58a3367d-6bca-432a-8af5-5c3b192276c2)


there are plenty of ready templates to use the pre-existing templates and modify based on our desired
![Screenshot 2024-02-20 115848](https://github.com/ShoebAliArab/Spring-CRUD-Example-Project-Management-App/assets/129241220/37622cd7-68f8-473d-b32d-1da76b1fff30)


it uses a Prometheus.

![Screenshot 2024-02-20 115857](https://github.com/ShoebAliArab/Spring-CRUD-Example-Project-Management-App/assets/129241220/00b9de80-d00a-4488-9ff0-6a1874d8ed49)



click on the Import the Entire data of the cluster


where we can able to see the entire data of the EKS cluster

![Screenshot 2024-02-20 124543](https://github.com/ShoebAliArab/Spring-CRUD-Example-Project-Management-App/assets/129241220/a4123d1e-9b93-4b76-9971-8a5e54ef40d3)

1. CPU and RAM use
2. pods in a specific namespace
3. Pod up history
4. HPA
5. Resources by Container
CPU used by container & limits
network bandwidth & packet rate


