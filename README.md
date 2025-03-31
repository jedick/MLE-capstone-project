# AI4citations: AI-Powered Citation Verification

An NLP framework for automated validation of citations and claims, ensuring references accurately support stated information.

## Overview

This repository contains models, datasets, and tools for verifying the accuracy of citations in scientific literature. The project builds on established datasets and models to classify citation accuracy as SUPPORT, REFUTE, or NEI (Not Enough Information).

- See the [project proposal](notebooks/00_Project-Proposal.md) for additional background information and project plans.
- See the [pyvers repository](https://github.com/jedick/pyvers) for a Python package with data modules and model training code developed to support this project.
- See [this blog post](https://jedick.github.io/blog/experimenting-with-transformer-models/) for experiments with different transformer models.
- The rest of this README describes the project files contained in this repository.

## Data Sources

The project utilizes two primary datasets, normalized with consistent labeling:

### SciFact
- 1,409 scientific claims verified against 5,183 abstracts
- Source: [GitHub](https://github.com/allenai/scifact) | [Paper](https://doi.org/10.18653/v1/2020.emnlp-main.609)
- Downloaded from: https://scifact.s3-us-west-2.amazonaws.com/release/latest/data.tar.gz
- Test fold includes cited_doc_ids from [`scifact_10`](https://github.com/dwadden/multivers/blob/main/script/get_data_train.sh)

### Citation-Integrity
- 3,063 citation instances from biomedical publications
- Source: [GitHub](https://github.com/ScienceNLP-Lab/Citation-Integrity/) | [Paper](https://doi.org/10.1093/bioinformatics/btae420)
- Downloaded from: https://github.com/ScienceNLP-Lab/Citation-Integrity/ (Google Drive link)

For more details on data format, see [MultiVerS data documentation](https://github.com/dwadden/multivers/blob/main/doc/data.md).

## Models

The repository contains two versions of the MultiVerS model:

- **multivers**: Standard MultiVerS implementation with local modifications
- **multivers_citint**: Adapted version used in the Citation-Integrity study

These models are built on transformer architectures:
- [MultiVerS](https://github.com/dwadden/multivers) | [Paper](https://doi.org/10.48550/arXiv.2112.01640)
- [Longformer](https://github.com/allenai/longformer) | [Paper](https://doi.org/10.48550/arXiv.2004.05150)

## Notebooks

Jupyter notebooks for exploration, analysis, and model training:

- **Reproduction**: [Citation-Integrity model](notebooks/01_Reproduction-of-Citation-Integrity.ipynb)
- **Data Processing**: 
  - [Citation-Integrity wrangling](notebooks/02_Data-Wrangling-for-Citation-Integrity.ipynb)
  - [SciFact wrangling](notebooks/03_Data-Wrangling-for-SciFact.ipynb)
- **Exploration**:
  - [Citation-Integrity analysis](notebooks/04_Data-Exploration-for-Citation-Integrity.ipynb)
  - [SciFact analysis](notebooks/05_Data-Exploration-for-SciFact.ipynb)
- **Model Development**:
  - [Baselines](notebooks/06_Baselines.ipynb)
  - [Checkpoints and rationale weights](notebooks/07_Checkpoints_and_Rationale_Weight.ipynb)
- **Utilities**: [eval.py](notebooks/eval.py) - Metrics calculation module

## Setup Instructions

### Environment Setup

```bash
# Create and activate conda environment
conda create -n multivers python=3.8
conda activate multivers

# Install dependencies
conda install --file requirements.txt -c conda-forge

# Install PyTorch with CUDA support (check GPU compatibility first)
# Example for CUDA 11.0:
conda install pytorch==1.7.1 torchvision==0.8.2 torchaudio==0.7.2 cudatoolkit=11.0 -c pytorch
```

### Model Checkpoints

Download required checkpoints:

```bash
python script/get_checkpoint.py fever_sci
python script/get_checkpoint.py healthver
```

### Training & Prediction

#### Citation-Integrity Dataset

```bash
# Train (approx. 3 hours for 5 epochs)
CUDA_LAUNCH_BLOCKING=1 TOKENIZERS_PARALLELISM=false python script/train_target.py --dataset citint --gpus=1 --gradient_checkpointing

# Generate predictions
python multivers/predict.py \
  --checkpoint_path=checkpoints/last.ckpt \
  --input_file=data_train/target/citint/claims_test.jsonl \
  --corpus_file=data_train/target/citint/corpus.jsonl \
  --output_file=predictions.jsonl
```

#### SciFact Dataset

```bash
# Train (approx. 1.5 hours for 5 epochs)
CUDA_LAUNCH_BLOCKING=1 TOKENIZERS_PARALLELISM=false python script/train_target.py --dataset scifact --gpus=1 --gradient_checkpointing
```

## Acknowledgments

This project builds upon several significant contributions from the scientific community:

- SciFact dataset by [Wadden et al., 2020](https://arxiv.org/abs/2004.14974)
- Citation-Integrity dataset by [Sarol et al., 2024](https://doi.org/10.1093/bioinformatics/btae420)
- MultiVerS model by [Wadden et al., 2021](https://doi.org/10.48550/arXiv.2112.01640)
- Longformer model by [Beltagy et al., 2020](https://doi.org/10.48550/arXiv.2004.05150)

## Change Log

- [[1dba23](https://github.com/jedick/AI4citations/commit/1dba23cd2cdef341ed37df76f2f37f50a4cfec03)] (2024-12-16) Normalized labels across datasets (`SUPPORT`, `REFUTE`, `NEI`)
- [[a5b029](https://github.com/jedick/AI4citations/commit/a5b0298ecbad2d2ab1ee02fad5487f966a29f6cf)] (2024-12-16) Made modifications to MultiVerS codebase:
  - Simplified requirements.txt
  - Reduced `num_epochs` from 20 to 5
  - Added support for Citation-Integrity (`citint`) and original SciFact datasets
- [[13ebe7](https://github.com/jedick/AI4citations/commit/13ebe74cb872e1344d352d630f11d4b8e4be67cf)] (2024-11-27) Cloned Citation-Integrity codebase; noted key differences from MultiVerS:
  - Training epochs reduced from 20 to 5
  - Additional tokens: `<|cit|>`, `<|multi_cit|>`, `<|other_cit|>`
  - Setting for `rationale_weight` changed from 15 to 0
