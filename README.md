# DevOps Showcase Project

Welcome to the **DevOps Showcase** project! This repository is a demonstration of modern DevOps practices, designed to highlight my skills in building, deploying, and managing cloud-native applications. It includes a sample Python API with a PostgreSQL backend, deployed to a Kubernetes cluster using Helm charts, automated CI/CD pipelines with GitHub Actions, and integration with ArgoCD for continuous deployment. Future enhancements will include Terraform modules for provisioning an AWS EKS environment and Ansible playbooks for configuring AMIs.

This project serves as a portfolio to showcase my capabilities in DevOps, cloud infrastructure, and automation to prospective recruiters.

## Project Overview

The DevOps Showcase project demonstrates a full-stack DevOps workflow, including:
- **Python API**: A sample RESTful API built with Python (FastAPI) for handling basic CRUD operations.
- **PostgreSQL Backend**: A database to store and manage application data, integrated with the API.
- **Helm Chart**: A Helm chart for packaging and deploying the API and database to a Kubernetes cluster.
- **GitHub Actions Workflows**: CI/CD pipelines to build, test, and deploy the application to AWS Elastic Container Registry (ECR) and update an ArgoCD ApplicationSet.
- **ArgoCD Integration**: Continuous deployment to a Kubernetes cluster using ArgoCD for GitOps.
- **Planned Features**:
  - **Terraform Modules**: Infrastructure as Code to provision an AWS EKS cluster.
  - **Ansible Playbooks**: Automation scripts to configure AWS AMIs for consistent server setups.

This project emphasizes best practices in DevOps, including containerization, infrastructure automation, CI/CD, and GitOps, showcasing my ability to design and implement production-ready solutions.

## Architecture

The application follows a cloud-native architecture:
- **API Layer**: A Python-based REST API (FastAPI) handling HTTP requests.
- **Database Layer**: PostgreSQL database for persistent storage, connected to the API.
- **Deployment**: Kubernetes cluster (targeting AWS EKS) with Helm for managing deployments.
- **CI/CD Pipeline**: GitHub Actions workflows to:
  - Build and test the Python API.
  - Package the application as a Docker container.
  - Push the container to AWS ECR.
  - Update the ArgoCD ApplicationSet to trigger deployments.
- **GitOps**: ArgoCD monitors the repository and synchronizes the Kubernetes cluster state with the Helm chart configurations.
- **Infrastructure (Planned)**: Terraform modules to provision an EKS cluster and Ansible playbooks to configure AMIs for additional compute resources.

## Prerequisites

To run this project locally or deploy it, ensure you have the following tools installed:
- **Docker**: For building and testing container images.
- **Kubernetes**: A local cluster (e.g., Minikube, Kind) or access to an AWS EKS cluster.
- **Helm**: For deploying the application to Kubernetes.
- **AWS CLI**: For interacting with AWS services (e.g., ECR, EKS).
- **GitHub Actions**: Configured in the repository for CI/CD.
- **ArgoCD**: Installed on the Kubernetes cluster for GitOps.
- **Python 3.12+**: For running the API locally.
- **PostgreSQL**: For local database testing.
- **Terraform (Planned)**: For provisioning AWS infrastructure.
- **Ansible (Planned)**: For configuring AMIs.

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/SenavirathneDilan/devops-showcase.git
cd devops-showcase
```

### 2. Local Development
#### API and Database
1. Install Python dependencies:
   ```bash
   pip install -r requirements.txt
   ```
2. Set up PostgreSQL locally (e.g., using Docker):
   ```bash
   docker run -d -p 5432:5432 --name postgres -e POSTGRES_PASSWORD=your_password postgres
   ```
3. Configure the API to connect to the database by setting environment variables (e.g., in a `.env` file):
   ```plaintext
   DATABASE_URL=postgresql://user:your_password@localhost:5432/devops_showcase
   ```
4. Run the API locally:
   ```bash
   python app/main.py
   ```
   Access the API at `http://localhost:5000`.

#### Kubernetes Deployment
1. Install the Helm chart:
   ```bash
   helm install devops-showcase ./helm/devops-showcase
   ```
2. Verify the deployment:
   ```bash
   kubectl get pods
   ```

### 3. CI/CD Pipeline
The `.github/workflows` directory contains GitHub Actions workflows that:
- Build and test the Python API.
- Create a Docker image and push it to AWS ECR.
- Update the ArgoCD ApplicationSet to trigger a deployment.

To configure the CI/CD pipeline:
1. Set up AWS credentials in GitHub Secrets (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`).
2. Configure ArgoCD to monitor this repository and the `helm/devops-showcase` directory.
3. Push changes to the repository to trigger the pipeline.

### 4. ArgoCD Deployment
1. Ensure ArgoCD is installed on your Kubernetes cluster.
2. Create an ArgoCD ApplicationSet pointing to this repository:
   ```yaml
   apiVersion: argoproj.io/v1alpha1
   kind: ApplicationSet
   metadata:
     name: devops-showcase
   spec:
     generators:
     - git:
         repoURL: https://github.com/SenavirathneDilan/devops-showcase.git
         revision: main
         directories:
         - path: helm/devops-showcase
     template:
       metadata:
         name: devops-showcase
       spec:
         project: default
         source:
           repoURL: https://github.com/SenavirathneDilan/devops-showcase.git
           targetRevision: main
           path: helm/devops-showcase
         destination:
           server: https://kubernetes.default.svc
           namespace: default
         syncPolicy:
           automated: {}
   ```
3. Apply the ApplicationSet:
   ```bash
   kubectl apply -f applicationset-devops-showcase.yaml
   ```

### 5. Planned Features
#### Terraform Modules
- **Goal**: Provision an AWS EKS cluster with necessary networking (VPC, subnets, security groups).
- **Directory**: `terraform/eks` (to be added).
- **Usage**:
  ```bash
  cd terraform/eks
  terraform init
  terraform apply
  ```

#### Ansible Playbooks
- **Goal**: Configure AWS AMIs with required software and settings for compute instances.
- **Directory**: `ansible/playbooks` (to be added).
- **Usage**:
  ```bash
  ansible-playbook -i inventory playbook.yml
  ```

## Project Structure
```
devops-showcase/
├── app/                    # Python API source code
│   ├── main.py             # API entry point
│   └── requirements.txt    # Python dependencies
├── helm/                   # Helm chart for Kubernetes deployment
│   └── devops-showcase/    # Helm chart directory
├── .github/workflows/       # GitHub Actions CI/CD pipelines
├── terraform/              # (Planned) Terraform modules for EKS
├── ansible/                # (Planned) Ansible playbooks for AMI configuration
├── README.md               # Project documentation
└── LICENSE                 # License file
```

## Contributing
Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -m "Add your feature"`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a pull request.

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact
For questions or feedback, reach out via GitHub Issues or connect with me on [LinkedIn](https://www.linkedin.com/in/dilanarjuna/).

---

*Built by Dilan Senavirathne to showcase DevOps expertise for prospective recruiters.*