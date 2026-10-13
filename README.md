# Drug Classification - CI/CD Pipeline for Machine Learning

[![CI/CD Pipeline](https://github.com/bharani-01/Drug-Classification/actions/workflows/ci.yml/badge.svg)](https://github.com/bharani-01/Drug-Classification/actions)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/)
[![Gradio](https://img.shields.io/badge/UI-Gradio-orange)](https://gradio.app/)

An automated MLOps pipeline for **Drug Classification** using Scikit-Learn, GitHub Actions for Continuous Integration (CI), CML (Continuous Machine Learning) for automated metric tracking, and Continuous Deployment (CD) to Hugging Face Spaces with a Gradio web application.

---

## 🏗️ Representative Block Diagram for CI/CD Pipeline

```mermaid
flowchart TD
    %% Node Styling
    classDef dev fill:#2563eb,stroke:#1d4ed8,stroke-width:2px,color:#fff;
    classDef git fill:#059669,stroke:#047857,stroke-width:2px,color:#fff;
    classDef ci fill:#d97706,stroke:#b45309,stroke-width:2px,color:#fff;
    classDef eval fill:#7c3aed,stroke:#6d28d9,stroke-width:2px,color:#fff;
    classDef cd fill:#db2777,stroke:#be185d,stroke-width:2px,color:#fff;
    classDef prod fill:#0891b2,stroke:#0e7490,stroke-width:2px,color:#fff;

    subgraph S1["1. Code & Version Control"]
        DEV["👨‍💻 Developer"]:::dev -->|"git push"| GITHUB["GitHub Repo<br/>(bharani-01/Drug-Classification)"]:::git
    end

    subgraph S2["2. Continuous Integration (CI)"]
        GITHUB -->|"Trigger Workflow"| GHA["GitHub Actions Runner"]:::ci
        GHA --> DEPS["Install Dependencies<br/>(make install)"]:::ci
        DEPS --> LINT["Format & Lint<br/>(make format)"]:::ci
        LINT --> TRAIN["Train Model<br/>(make train)"]:::eval
        TRAIN --> EVAL["Evaluate Metrics & Confusion Matrix<br/>(make eval)"]:::eval
        EVAL --> CML["CML Bot<br/>(Comments report on PR / Commit)"]:::eval
        EVAL --> UPDATE["Update Branch<br/>(make update-branch)"]:::git
    end

    subgraph S3["3. Continuous Deployment (CD)"]
        UPDATE -->|"workflow_run triggered"| CD["CD Workflow (.github/workflows/cd.yml)"]:::cd
        CD --> HF_LOGIN["Login to Hugging Face<br/>(make hf-login)"]:::cd
        HF_LOGIN --> SYNC["Upload App, Model & Metrics<br/>(make push-hub)"]:::cd
        SYNC --> HF["🚀 Hugging Face Spaces<br/>(Live Gradio Web Application)"]:::prod
    end
```

---

## 📁 Project Directory Structure

```text
Drug-Classification/
├── .github/
│   └── workflows/
│       ├── ci.yml            # CI workflow: install, format, train, eval, cml, update-branch
│       └── cd.yml            # CD workflow: automated deployment to Hugging Face Spaces
├── app/
│   ├── app.py                # Gradio web application for inference
│   ├── README.md             # Space configuration and metadata
│   └── requirements.txt      # Gradio Space dependencies (scikit-learn, skops, gradio)
├── data/
│   └── drug.csv              # Clinical dataset for drug classification (200 records)
├── model/
│   └── drug_pipeline.skops   # Serialized model pipeline artifact
├── results/
│   ├── metrics.txt           # Generated model evaluation metrics (Accuracy, F1)
│   └── model_results.png     # Generated confusion matrix plot
├── Makefile                  # Build, formatting, training, and deployment commands
├── requirements.txt          # Root Python dependencies for CI & local development
├── train.py                  # Model training and evaluation script
├── .gitignore                # Python ignore patterns
└── README.md                 # Project documentation
```

---

## 🚀 How to Run Locally

### 1. Setup Virtual Environment
```bash
# Windows
py -3.12 -m venv venv
.\venv\Scripts\activate

# Linux / macOS
python3 -m venv venv
source venv/bin/activate
```

### 2. Install Dependencies
```bash
pip install -r requirements.txt
```

### 3. Train & Evaluate Model
```bash
python train.py
```
Outputs:
- Model artifact: `model/drug_pipeline.skops`
- Evaluation metrics: `results/metrics.txt`
- Confusion matrix image: `results/model_results.png`

### 4. Launch Gradio Web App
```bash
pip install -r app/requirements.txt
python app/app.py
```

---

## 🔐 GitHub Actions Repository Secrets

Configure the following secrets in **Settings > Secrets and variables > Actions**:

| Secret Name | Description |
| :--- | :--- |
| `HF` | Hugging Face Access Token with **Write** permission |
| `USER_NAME` | Git commit username for automated update branch pushes |
| `USER_EMAIL` | Git commit email for automated update branch pushes |
| `GITHUB_TOKEN` | Inherent token (grant *Read and write permissions* under *Settings > Actions > General*) |
