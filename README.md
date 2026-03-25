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