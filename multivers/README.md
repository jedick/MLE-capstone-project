# Setup notes

This model is modified from [Citation-Integrity](https://github.com/ScienceNLP-Lab/Citation-Integrity), which is derived from [MultiVerS](https://github.com/dwadden/multivers).

- [See here](README_Citation-Integrity.md) for the original Citation-Integrity README.

- See [this commit](https://github.com/jedick/readycite/commit/13ebe74cb872e1344d352d630f11d4b8e4be67cf#diff-8e6dbc89855517e16e9eda8a378fb0a168e4b9296690f014c48e374b4709b2f1R30) for the differences between MultiVerS and CitationIntegrity. CitationIntegrity adds three tokens (`<|cit|>`, `<|multi_cit|>`, `<|other_cit|>`) and changes the number of epochs from 20 to 5.

These notes were written by Jeffrey Dick in November 2024.

### Training data

See `data` directory in the root this repo for training files.
Put `*.jsonl` files in:

- `data_train/target/citint` for Citation-Integrity ([2024 paper](https://doi.org/10.1093/bioinformatics/btae420)). Note: these are not the files in the Citation-Integrity [`data` directory](https://github.com/ScienceNLP-Lab/Citation-Integrity/tree/main/Data) but were downloaded from [Google Drive](https://drive.google.com/drive/u/0/folders/11b6Z8iv2FXObWmLaqfYzgUQsaL4QgTT2?q=parent:11b6Z8iv2FXObWmLaqfYzgUQsaL4QgTT2).
- `data_train/target/scifact_10` for SciFact (10 negative samples per positive - [2022 paper](https://arxiv.org/abs/2210.13777))
- `data_train/target/scifact_20` for SciFact (20 negative samples per positive - [2021 paper](https://arxiv.org/abs/2112.01640))
- `data_train/target/scifact` for SciFact (original version - [2020 paper](https://arxiv.org/abs/2004.14974))

### Setup conda environment with working Python version

```
conda create -n multivers python=3.8
conda activate multivers
```

### Install required packages for MultiVerS

```
conda install --file requirements.txt -c conda-forge
```

Notes:

- Commented bertviz and FocalLoss imports from src/model.py
- Minimized list of packages in requirements.txt and renamed torch to pytorch
- Use -c conda forge to avoid this error: PackagesNotFoundError: The following packages are not available from current channels


### Install the CUDA flavor of PyTorch

Run `nvidia-smi` to check CUDA version of the GPU.
Then run this command from the [PyTorch website](https://pytorch.org/get-started/previous-versions/#v171):

```
conda install pytorch==1.7.1 torchvision==0.8.2 torchaudio==0.7.2 cudatoolkit=11.0 -c pytorch
```

Note: run this *after* installing packages from requirements.txt to avoid error with pandas import (ValueError: numpy.dtype size changed, may indicate binary incompatibility. Expected 96 from C header, got 88 from PyObject).

### Download checkpoints

Citation-Integrity starts training from the healthver checkpoint (see the arguments in `train_target.py`).
Note: I modified the wget command in `get_checkpoint.py` to continue interrupted downloads.

```
python get_checkpoint.py healthver
# To get the checkpoint used in MultiVerS
# python get_checkpoint.py longformer_large_science
```

### Download transformers

Running the training script will automatically download transformers from huggingface.
Sometimes getting an error, just try again (ValueError: Connection error, and we cannot find the requested files in the cached path. Please try again or make sure your Internet connection is on).

```
python train_target.py --dataset citint --gpus=1
```

### Train the model and make predictions

This takes about 3 hours for 5 epochs.
Results are saved in `checkpoints_user`; use last.ckpt for the predictions.
See [David Wadden's notes about training](https://github.com/dwadden/multivers/blob/main/doc/training.md).

```
CUDA_LAUNCH_BLOCKING=1 TOKENIZERS_PARALLELISM=false python train_target.py --dataset citint --gpus=1 --gradient_checkpointing > ./output.txt 2>&1
```

Make predictions - takes about 1.5 minutes.

```
python src/predict.py \
  --checkpoint_path=checkpoints/last.ckpt \
  --input_file=data_train/target/citint/claims_test.jsonl \
  --corpus_file=data_train/target/citint/corpus.jsonl \
  --output_file=predictions.jsonl
```

### Train the model on SciFact

Takes about 1.5 hours for 5 epochs.

```
CUDA_LAUNCH_BLOCKING=1 TOKENIZERS_PARALLELISM=false python train_target.py --dataset scifact --gpus=1 --gradient_checkpointing > ./output.txt 2>&1
```

Note: this is the original SciFact dataset.
Use `scifact_10` or `scifact_20` for the datasets with negative sampling.

### Change log

Modifications made by JMD:

- [cf8461](https://github.com/jedick/readycite/commit/cf846148c39557c45d99e2fcbb3409adea4fede3) 2024-11-28
    - Use names for the Citation-Integrity (`citint`) and original SciFact (`scifact`) datasets.
    - In `src/data_verisci.py`, handle SUPPORT and CONTRADICT labels from the SciFact dataset.
    - In `src/data_train.py`, revert `val_dataloader` to use the `"val"` instead of `"test"` set.
- [e10022](https://github.com/jedick/readycite/commit/e10022ecc4a24646708f6dd81e40f20208d62860) 2024-11-27
    - Update `requirements.txt` and imports.
- [13ebe7](https://github.com/jedick/readycite/commit/13ebe74cb872e1344d352d630f11d4b8e4be67cf) 2024-11-27
    - Commit Citation-Integrity codebase [277152](https://github.com/ScienceNLP-Lab/Citation-Integrity/commit/277152f9dfe3873455220f4cd15269474ab15617) to show diffs from MultiVerS [a6ce03](https://github.com/dwadden/multivers/commit/a6ce033f0e17ae38c1f102eae1ee4ca213fbbe2e).

