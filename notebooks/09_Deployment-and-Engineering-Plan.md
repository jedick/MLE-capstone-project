# Deployment and Engineering Plan

*This is the submission for Step 9 of the MLE Capstone Project on Scientific Citation Verification.*

Written by Jeffrey Dick on 2025-05-21

## Deployment Strategy: Executive Summary
- **Upgrade to Hugging Face GPU Instance with Persisent Storage**: ~$11/month
- **Web App Enhancement**: Improve AI4citations Gradio app with monitoring and logging
	- Monitor inference time
	- Store user feedback for RLHF
	- Log queries to detect data drift

## Project Overview 

### Current Status

- [Model fine-tuning implemented using PyTorch Lightning in the pyvers package](https://github.com/jedick/pyvers)
- [Model fine-tuning completed on two datasets](https://github.com/jedick/MLE-capstone-project?tab=readme-ov-file#milestones) (SciFact and Citation-Integrity)
- [Fine-tuned model uploaded to Hugging Face](https://huggingface.co/jedick/DeBERTa-v3-base-mnli-fever-anli-scifact-citint)
- [AI4citations app developed using Gradio](https://github.com/jedick/AI4citations)
- [App currently hosted on HF Spaces](https://huggingface.co/spaces/jedick/AI4citations) with free CPU instance
	- Slow inference, no persistent storage

### Deployment Goals

- Accelerated inference using GPU
- Monitoring of inference time and compute resources used
- Retraining using reinforcement learning from human feedback (RLHF)
- Detect data drift

### Wishlist

- Automated retraining
- Potential for scaling up
- API documentation:
	- Gradio app already has built-in API documentation
	- (Optional) Create custom API documentation for third-party integration

## Compute Requirements

*Estimated for initial small-scale deployment*

- 10 hours of GPU inference time per month
- 10 MB online storage for logs

## Options Analysis

| Deployment Option | Pros | Cons | Cost | Selected |
|-------------------|------|------|------|----------|
| **HF Inference API** | - Fast implementation<br>- Minimal maintenance | - Limited customization<br>- Higher long-term costs | $11/month | ✓ |
| **AWS Cloud** | - Highly scalable<br>- Potential cost optimization | - Complex setup<br>- More maintenance | ~$5/month | |
| **Edge Deployment** | - No ongoing cloud costs<br>- Local data processing | - Limited scalability<br>- Hardware investment | $1000-2000 upfront | |


### Cost breakdown

- HF Inference API [^1]:
	- Nvidia T4-medium (8 vCPU, 30GB RAM, 16GB VRAM) - $0.60/hour ($6/month)
	- Spaces Persistent Storage (20 GB) - $5/month
- AWS Cloud:
	- Use g4dn-series EC2 instance for T4 GPU [^2]
	- g4dn.xlarge (4 vCPU, 16GB RAM) - $0.526/hour ($5.26/month) [^3]
	- Logging to S3 bucket (1 GB) - $0.03/month + $0.06/GB data transfer to internet


## ML Pipeline Integration

```
┌───────────────┐        ┌───────────────┐        ┌───────────────┐        ┌───────────────┐
│  Data Sources │        │     Data      │        │     Model     │        │  Deployment   │
│   - SciFact   │──────▶│  Processing   │──────▶│   Training    │──────▶│     Stack     │
│ - Citation-Int│        │ (pyvers pkg)  │        │ (PyTorch+MLf) │        │  (HF Spaces)  │
└───────────────┘        └───────────────┘        └───────────────┘        └───────┬───────┘
                                 ▲                        ▲                        │
                                 │                        │                        │
                                 │                        │                        ▼
                         ┌───────┴───────┐        ┌───────┴───────┐        ┌───────────────┐
                         │ Data Feedback │        │ Model Updates │        │  Monitoring   │
                         │  Collection   │◀──────│ & Retraining  │◀──────│  & Logging    │
                         │    (RLHF)     │        │ (Auto-trigger)│        │  (Persistent) │
                         └───────────────┘        └───────────────┘        └───────────────┘
```

## Monitoring & Maintenance Framework

### Metrics Collection
- **Technical Performance**: Inference time, GPU/CPU utilization, memory usage
- **User Experience**: Feedback rates, usage patterns

### Logging System
- **Data Captured**: Query text, model predictions, user feedback, system metrics
- **Usage**: Data collection for RLHF and retraining datasets

### Data Drift Detection
- **Methodology**: Statistical comparison of production vs. training distributions
- **Actions**: Automated alerts when drift exceeds thresholds
- **Integration**: Triggers for model retraining pipeline

## Retraining & Redeployment Process

### Triggering Conditions
- Collect 100+ feedback instances
- Detect significant data drift
- Regular schedule (quarterly review)

### Migration to Cloud Training
- **Resources**: Cloud GPU instances for training - $10/training run
- **Tools**: MLflow for experiment tracking and model versioning - $0-50/month
- **Process**: Automated training pipeline with validation against benchmarks

### Model Versioning & Deployment
- **Implementation**:
	- GitHub for code versioning (**Done**)
	- CI/CD for code testing (**In Progress**)
	- MLflow for model versioning
- **Strategy**: Blue-green deployment for zero-downtime updates
- **Validation**: A/B testing of new models against current production model

## Total Estimated Costs
- **Infrastructure**: $6/month (HF Spaces GPU)
- **Storage & Logging**: $5/month (Persistent Storage)
- **Training & Experimentation**: $10/month (periodic retraining)
- **Tools & Monitoring**: $0-50/month (MLflow, monitoring) [^4]
- **Total Monthly**: $21-71/month
- **Annual Projection**: $252-852/year

[^1]: https://huggingface.co/pricing
[^2]: https://aws.amazon.com/ec2/instance-types/
[^3]: https://aws.amazon.com/ec2/pricing/on-demand/
[^4]: https://docs.nebius.com/mlflow/resources/pricing
