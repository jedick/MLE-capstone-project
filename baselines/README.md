# Baselines

The repository contains two versions of the MultiVerS model:

- **multivers**: Standard MultiVerS implementation with local modifications
- **multivers_citint**: Adapted version used in the Citation-Integrity study

These models are built on transformer architectures:
- [MultiVerS](https://github.com/dwadden/multivers) | [Paper](https://doi.org/10.48550/arXiv.2112.01640)
- [Longformer](https://github.com/allenai/longformer) | [Paper](https://doi.org/10.48550/arXiv.2004.05150)

## Environment Setup

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

## Model Checkpoints

Download required checkpoints:

```bash
python script/get_checkpoint.py fever_sci
python script/get_checkpoint.py healthver
```

## Training & Prediction

Copy data files from the `data` directory of this repository into the correct location for training:

- `data_train/target/citint` for Citation-Integrity
- `data_train/target/scifact` for SciFact

### Citation-Integrity Dataset

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

### SciFact Dataset

```bash
# Train (approx. 1.5 hours for 5 epochs)
CUDA_LAUNCH_BLOCKING=1 TOKENIZERS_PARALLELISM=false python script/train_target.py --dataset scifact --gpus=1 --gradient_checkpointing
```

## Change Log

- [[1dba23](https://github.com/jedick/MLE-capstone-project/commit/1dba23cd2cdef341ed37df76f2f37f50a4cfec03)] (2024-12-16) Normalized labels across datasets (`SUPPORT`, `REFUTE`, `NEI`)
- [[a5b029](https://github.com/jedick/MLE-capstone-project/commit/a5b0298ecbad2d2ab1ee02fad5487f966a29f6cf)] (2024-12-16) Made modifications to MultiVerS codebase:
  - Simplified requirements.txt
  - Reduced `num_epochs` from 20 to 5
  - Added support for Citation-Integrity (`citint`) and original SciFact datasets
- [[13ebe7](https://github.com/jedick/MLE-capstone-project/commit/13ebe74cb872e1344d352d630f11d4b8e4be67cf)] (2024-11-27) Cloned Citation-Integrity codebase; noted key differences from MultiVerS:
  - Training epochs reduced from 20 to 5
  - Additional tokens: `<|cit|>`, `<|multi_cit|>`, `<|other_cit|>`
  - Setting for `rationale_weight` changed from 15 to 0
