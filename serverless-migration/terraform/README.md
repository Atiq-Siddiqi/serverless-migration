# Serverless Migration & Modernization Prototype (Strangler Fig Pattern)

An enterprise reference architecture demonstrating zero-downtime application modernization using the **Strangler Fig Pattern**. This prototype routes traffic securely via **AWS API Gateway** to modern serverless microservices (**AWS Lambda**) while decoupling legacy infrastructure.

## 🏗️ Architecture Overview

[ Client / Consumer ]
│
▼
[ AWS API Gateway (HTTP API) ]
│
├──► GET /api/v1/resource ──► [ AWS Lambda (Modern Backend) ]
│
└──► (Legacy Routes)      ──► [ Legacy Backend (Simulated ECS/EC2) ]


## 🛠️ Tech Stack
* **Infrastructure as Code:** Terraform
* **API Routing:** AWS API Gateway (HTTP API v2)
* **Compute Layer:** AWS Lambda (Node.js 20.x runtime)
* **Design Pattern:** Strangler Fig Incremental Modernization

---

## 🚀 Quick Start Deployment

### Prerequisites
* [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate permissions.
* [Terraform](https://www.terraform.io/) installed (v1.0+).

### 1. Initialize Infrastructure
Navigate to the terraform directory and initialize providers:
```bash
cd terraform
terraform init
2. Deploy the Prototype
Run the automated deployment plan:

terraform apply -auto-approve

3. Test the Endpoint
Test the modernized route using the output API endpoint:

curl -X GET "<your-api-gateway-endpoint>/api/v1/resource"

📊 Diagnostics & Execution Results
1. Successful Terraform Deployment & Output
2. Terminal API Routing & Response Test (curl)
3. Browser-Based Endpoint Verification
🧹 Cleanup & Cost Management
To tear down all provisioned AWS resources and prevent billing charges, run:

cd terraform
terraform destroy -auto-approve