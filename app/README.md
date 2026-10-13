---
title: Drug Classification - ML CI/CD
colorFrom: blue
colorTo: green
sdk: static
pinned: false
---

# Drug Classification - ONNX Runtime Web Interface

This is an in-browser machine learning inference application for clinical drug classification.

- **Architecture:** Zero-server, client-side inference powered by [ONNX Runtime Web](https://onnxruntime.ai/) and WebAssembly.
- **Model:** Scikit-Learn Pipeline (`OneHotEncoder` + `RandomForestClassifier`), converted to ONNX via `skl2onnx`.
- **Hosting:** Hugging Face Static Space (fast, free, static asset serving).
- **Automation:** GitHub Actions continuous integration and continuous deployment (CI/CD) with automated model evaluation using Continuous Machine Learning (CML).
