# grafana-cloudwatch-integration
Monitor Cloud watch logs using Grafana, so that the user's doesn't need AWS access 
executive-overviewThis project demonstrates a high-maturity Infrastructure as Code (IaC) approach to hybrid-cloud monitoring. By bridging a local k3d (Kubernetes) environment with AWS CloudWatch via Terraform, the architecture provides a "Single Pane of Glass" for real-time performance metrics, centralized logging, and financial oversight.The primary objective was to eliminate "Information Silos" between DevOps, Security, and Finance teams by integrating technical health with cost-utilization data.
architecture-highlights
1. Hybrid-Cloud Integration (The "ARC" Pattern)
    Challenge: Overcoming networking and credential hurdles between a local WSL2/Ubuntu environment and AWS.
    Solution: Implemented Actions Runner Controller (ARC) within the cluster to handle private, automated deployments. This ensures that infrastructure changes are executed within a controlled, containerized environment rather than relying on "laptop-local" configurations.
2. Secure Identity & Access Management (IAM)
    Least-Privilege Design: Engineered a custom IAM policy targeting specific cloudwatch:*, logs:*, and ce:* (Cost Explorer) actions, adhering to the principle of least privilege.
    
    Zero-Footprint Credentials: Utilized Terraform’s secureJsonData and set_sensitive functions to inject AWS credentials directly into the Grafana pod's memory. This prevents "Credential Leakage" by ensuring keys never touch the UI or plain-text configuration files.
3. Cost-Aware Observability
    Financial Visibility: Integrated the AWS Cost Explorer API to surface EstimatedCharges alongside system performance metrics.
    Proactive Governance: By monitoring billing metrics in the same dashboard as CPU/Memory utilization, the system enables "Shift-Left" cost management—allowing engineers to see the immediate financial impact of infrastructure scaling.technical-stack
    Layer           Technology              Purpose
    Orchestration   Terraform               Infrastructure as Code & Provider Management
    Compute         k3d (Kubernetes)        Lightweight, localized container orchestration
    CI/CD           GitHub Actions + ARC    Automated, private-network deployment pipeline
    Observability   GrafanaCentralized visualization of Metrics, Logs, and Costs

    ### Architecture Overview

```mermaid
%%{init: {'theme': 'base', 'themeVariables': { 'primaryColor': '#0073BB', 'edgeLabelBackground':'#ffffff', 'tertiaryColor': '#fff'}}}%%
graph TD
    %% Define Nodes and Groups
    subgraph Local_Environment[Local Laptop: WSL2 / Ubuntu]
        subgraph Kubernetes_Cluster[k3d Kubernetes Cluster]
            ARC_Pod(<b>ARC Runner Pod</b><br/>GitHub Actions)
            Grafana_Pod(<b>Grafana Pod</b><br/>Visualization Engine)
        end
        Terraform_CLI(<b>Terraform CLI</b><br/>Infrastructure as Code)
    end

    subgraph AWS_Cloud[AWS Cloud Provider]
        subgraph Security_IAM[Identity & Access Management]
            IAM_User(<b>IAM User</b><br/>grafana-cloudwatch-reader)
            IAM_Policy(<b>IAM Policy</b><br/>Logs, Metrics, Cost Explorer Access)
        end
        subgraph Observability_Silo[CloudWatch & Billing APIs]
            CW_Metrics(CloudWatch Metrics<br/>AWS/EC2, AWS/Billing)
            CW_Logs(CloudWatch Logs<br/>Application Logs)
            CE_API(Cost Explorer API<br/>On-Demand Cost Data)
        end
    end

    %% Define Relationships and Data Flow
    
    %% 1. Infrastructure Provisioning (Control Plane)
    Terraform_CLI -.->|1. Authenticates as Admin| AWS_Cloud
    Terraform_CLI ==>|2. Creates / Updates| IAM_User
    Terraform_CLI ==>|3. Deploys via Helm| Grafana_Pod
    
    %% 2. The "Handshake" (Credential Injection)
    Terraform_CLI -.->|4a. Fetches IAM User Keys| IAM_User
    Terraform_CLI ==>|4b. Injects Keys via<br/>secureJsonData| Grafana_Pod
    
    %% 3. Observability Data Flow (Data Plane)
    Grafana_Pod ==>|5. Requests Data<br/>Using IAM User Keys| Observability_Silo
    CW_Metrics -->|6a. Metrics Data<br/>EstimatedCharges| Grafana_Pod
    CW_Logs -->|6b. Logs Data| Grafana_Pod
    CE_API -->|6c. On-Demand Cost Data| Grafana_Pod

    %% Styling
    style Local_Environment fill:#f9f9f9,stroke:#333,stroke-width:2px,stroke-dasharray: 5 5;
    style Kubernetes_Cluster fill:#e1f5fe,stroke:#0277bd,stroke-width:2px;
    style AWS_Cloud fill:#fff3e0,stroke:#ef6c00,stroke-width:2px;
    style ARC_Pod fill:#fff,stroke:#333,stroke-width:1px;
    style Grafana_Pod fill:#f1f8e9,stroke:#33691e,stroke-width:2px;
    style Terraform_CLI fill:#fff,stroke:#5c4ee5,stroke-width:2px;
    style IAM_User fill:#fff,stroke:#e91e63,stroke-width:1px;
    
    %% Connections styling
    linkStyle 0,1,3 stroke:#5c4ee5,stroke-width:2px,stroke-dasharray: 5 5;
    linkStyle 2 stroke:#5c4ee5,stroke-width:3px;
    linkStyle 4 stroke:#33691e,stroke-width:2px;
    linkStyle 5,6,7 stroke:#0277bd,stroke-width:2px;
%% Paste the Mermaid.js code above directly here %%