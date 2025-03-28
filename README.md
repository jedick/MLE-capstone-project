# NLP Launchpad

This repository contains data files, reproductions of published models, and notebooks for an NLP project on ***Automated Quality Assurance for Literature Citations***.

🙏 This project wouldn't exist without the following resources:

- SciFact dataset: [GitHub](https://github.com/allenai/scifact) and [paper](https://doi.org/10.18653/v1/2020.emnlp-main.609)
  - 1,409 scientific claims verified against 5,183 abstracts
- Citation-Integrity dataset: [GitHub](https://github.com/ScienceNLP-Lab/Citation-Integrity/) and [paper](https://doi.org/10.1093/bioinformatics/btae420)
  - 3,063 citation instances from biomedical publications
- MultiVerS model: [GitHub](https://github.com/dwadden/multivers) and [paper](https://doi.org/10.48550/arXiv.2112.01640)
- Longformer model: [GitHub](https://github.com/allenai/longformer) and [paper](https://doi.org/10.48550/arXiv.2004.05150)

## 📋 Notebooks

See the **notebooks** directory for write-ups and Jupyter notebooks:
- Reproduction of [Citation-Integrity](notebooks/01_Reproduction-of-Citation-Integrity.ipynb) model
- Data wrangling: [Citation-Integrity](notebooks/02_Data-Wrangling-for-Citation-Integrity.ipynb) and [SciFact](notebooks/03_Data-Wrangling-for-SciFact.ipynb)
- Data exploration: [Citation-Integrity](notebooks/04_Data-Exploration-for-Citation-Integrity.ipynb) and [SciFact](notebooks/05_Data-Exploration-for-SciFact.ipynb)
- Model [baselines](notebooks/06_Baselines.ipynb) and starting [checkpoints](notebooks/07_Checkpoints_and_Rationale_Weight.ipynb)
- [eval.py](notebooks/eval.py) is a Python module with helper functions for calculating metrics used in the notebooks

## 📊 Data Sources

The labels in each dataset have been normalized as follows: REFUTE, SUPPORT, or NEI (Not Enough Information).
For more information on the format, see [Data format](https://github.com/dwadden/multivers/blob/main/doc/data.md) in the MultiVerS repo.

### [SciFact](data/scifact)

- This is modified from the SciFact dataset by [Wadden et al., 2020](https://arxiv.org/abs/2004.14974).
- Downloaded from https://scifact.s3-us-west-2.amazonaws.com/release/latest/data.tar.gz (linked from https://github.com/allenai/scifact).
- To enable predictions on the test fold of `scifact`, cited_doc_ids were added from `scifact_10`.
- `scifact_10` is available at https://scifact.s3.us-west-2.amazonaws.com/longchecker/latest/data_train.tar.gz (linked from https://github.com/dwadden/multivers/blob/main/script/get_data_train.sh).

### [Citation-Integrity](data/citint)

- This is modified from the Citation-Integrity dataset by [Sarol et al., 2024](https://doi.org/10.1093/bioinformatics/btae420).
- Downloaded from https://drive.google.com/drive/u/0/folders/11b6Z8iv2FXObWmLaqfYzgUQsaL4QgTT2, which is linked from https://github.com/ScienceNLP-Lab/Citation-Integrity/
- Claims in `citint` have been reordered by increasing claim ID using the script `citint/reorder_claims.R`.

## 🛠 Models

The [models](models) directory contains two versions of the MultiVerS model:
- multivers: Based on MultiVerS with local modifications
- multivers_citint: The version of MultiVerS used in the Citation-Integrity study, also with local modifications.

Two model directories are needed because the Citation-Integrity study added several tokens to the tokenizer.

### Setup training data

One of the directories in **data** should be copied or linked to the appropriate location for training.
For example, link `citint` to `models/multivers/data_train/target/citint` to train on the Citation-Integrity dataset.

### Setup environment and install packages

Use -c conda-forge to avoid this error: PackagesNotFoundError: The following packages are not available from current channels.

```
conda create -n multivers python=3.8
conda activate multivers
conda install --file requirements.txt -c conda-forge
```

Install the CUDA flavor of PyTorch: Run `nvidia-smi` to check CUDA version of the GPU.
Then run this command from the [PyTorch website](https://pytorch.org/get-started/previous-versions/#v171):

```
conda install pytorch==1.7.1 torchvision==0.8.2 torchaudio==0.7.2 cudatoolkit=11.0 -c pytorch
```

Note: run this *after* installing packages from requirements.txt to avoid error with pandas import (ValueError: numpy.dtype size changed, may indicate binary incompatibility. Expected 96 from C header, got 88 from PyObject).

### Download checkpoints and transformer models

The pretraining checkpoints are described in the MultiVerS and Citation-Integrity papers:

- MultiVerS is initialized from the longformer-large checkpoint (`longformer_large_science`)
- Pretraining in MultiVerS corresponds to the `fever_sci` checkpoint.
- Fine-tuning in MultiVerS on different datasets produces the `covidfact`, `healthver`, and `scifact` checkpoints.
- Training in the Citation-Integrity study starts from the `healthver` checkpoint.

Download the checkpoints with these commands:

```
python script/get_checkpoint.py fever_sci
python script/get_checkpoint.py healthver
```

Running the training script will automatically download transformers from HuggingFace.
If getting an error, just try again (ValueError: Connection error, and we cannot find the requested files in the cached path. Please try again or make sure your Internet connection is on).

```
python script/train_target.py --dataset citint --gpus=1
```

### Train the model on Citation-Integrity and make predictions

This takes about 3 hours for 5 epochs.
Results are saved in `checkpoints_user`; use last.ckpt for the predictions.
See [David Wadden's notes about training](https://github.com/dwadden/multivers/blob/main/doc/training.md).

```
CUDA_LAUNCH_BLOCKING=1 TOKENIZERS_PARALLELISM=false python script/train_target.py --dataset citint --gpus=1 --gradient_checkpointing
```

Make predictions - takes about 1.5 minutes.
NOTE: This requires the `train_configs.json` file generated by the training to be present in the current directory.

```
python multivers/predict.py \
  --checkpoint_path=checkpoints/last.ckpt \
  --input_file=data_train/target/citint/claims_test.jsonl \
  --corpus_file=data_train/target/citint/corpus.jsonl \
  --output_file=predictions.jsonl
```

### Train the model on SciFact

Takes about 1.5 hours for 5 epochs.

```
CUDA_LAUNCH_BLOCKING=1 TOKENIZERS_PARALLELISM=false python script/train_target.py --dataset scifact --gpus=1 --gradient_checkpointing
```

Note: `scifact` is the original SciFact dataset.
Use `scifact_10` or `scifact_20` for the datasets with negative sampling.

### Change log

- [[3e6935](https://github.com/jedick/RefSup/commit/3e69357ba6da88f9eea85e13f86cf9e7077811bd)] 2024-12-16 Commit MultiVerS codebase followed by these changes:
    - Minimized list of packages in requirements.txt and renamed torch to pytorch
	- `num_epochs` changed from 20 to 5
	- Add support for Citation-Integrity (`citint`) and original SciFact (`scifact`) datasets
	- Normalize labels in datasets (`SUPPORT`, `REFUTE`, `NEI`)
- [[13ebe7](https://github.com/jedick/RefSup/commit/13ebe74cb872e1344d352d630f11d4b8e4be67cf)] 2024-11-27 Commit Citation-Integrity codebase (source: [277152](https://github.com/ScienceNLP-Lab/Citation-Integrity/commit/277152f9dfe3873455220f4cd15269474ab15617)) to show diffs from MultiVerS (source: [a6ce03](https://github.com/dwadden/multivers/commit/a6ce033f0e17ae38c1f102eae1ee4ca213fbbe2e)). Some changes in CitationIntegrity are:
	- Changes the number of epochs for training from 20 to 5
	- Adds three tokens (`<|cit|>`, `<|multi_cit|>`, `<|other_cit|>`) 
	- Has `"test"` rather than `"val"` in `val_dataloader` 
	- Changes `rationale_weight` from 15 to 0.

Project Proposal
================

*Statement of the problem*

Literature citations are an important part of scientific articles. Proper citations relate the work to past research and justify the methods and claims made in an article. However, all too often, citations suffer from poor quotation accuracy – they do not reflect the content of the cited source or do not support the authors’ claims. Studies of quotation accuracy report that 10-20% or more of citations in various disciplines are inaccurate. A tool that automatically detects inaccurate citations would boost confidence in the scientific literature.

The problem affects a wide cross section of stakeholders, from authors to editors and their institutions. The conventional advice for improving quotation accuracy is “read before you cite”. While human judgment remains central to production of quality scientific content, an automated system to check quotation accuracy would be a valuable addition. Recent advances in natural language processing (NLP) and availability of datasets to train the models make this a feasible goal.

*Data sources*

The project will use data from two studies of quotation accuracy, specifically SciFact and CitationIntegrity, published in 2020 and 2024. In terms of number of citation instances, these are not large datasets (1409 and 3063, respectively), but data preprocessing requires extraction of sentences relevant to the claim (rationale sentences) from source documents, greatly multiplying the number of sentences that need to be considered.

Quotation accuracy in scientific articles (where a source is cited) is related to the problem of claim verification (where a source is not cited). Therefore, claim verification datasets are useful for pre-training the models. There are various publicly available claim verification corpora, and I have provisionally selected Fever, which consists of 185,445 claims synthesized from Wikipedia.

The data will be downloaded from the following sources:

- SciFact: https://github.com/allenai/scifact linking to Amazon S3
- CitationIntegrity: https://github.com/ScienceNLP-Lab/Citation-Integrity/ linking to Google Drive
- Fever: https://fever.ai/dataset/fever.html 

*Approach to solving the problem*

This is a supervised classification problem. The system will predict a label for each claim (Support, Refute, or Not Enough Information). The predictors are the text of a claim and the rationale sentences from a cited source. The system will use deep learning, e.g. Bidirectional Encoder Representations from Transformers (BERT).

Working plan:

- Phase 1: Use the available preprocessed data in the SciFact and CitationIntegrity datasets, which provide rationale sentences extracted from articles or abstracts. The first step will replicate previous work done by NLP researchers. Then, by combining the datasets, this project will build new capabilities.
- Phase 2: Use entire PDFs rather than provided sentences in order to optimize a preprocessing pipeline. This will involve more complex NLP engineering and possibly large language models (LLMs). An additional goal is to develop claim retrieval or generation capability. However, claim retrieval is a relatively young field, so this may not be feasible within the time frame of this project.
- Phase 3: Deployment to the cloud.
- Phase 4: Production stage and analysis of quotation accuracy in large datasets, such as bioRxiv.

*Final deliverable*

A web app will be built for users to submit texts for citation checking. This will be a convenient tool for authors and editors, as they can simply upload a claim and the cited PDF to check quotation accuracy.

*Computational resources needed*

A sufficiently powerful GPU is needed to train the models. According to the SciFact paper (https://arxiv.org/abs/2004.14974), training the RationaleSelection and LabelPrediction modules takes about 700 and 640 minutes, respectively, using a single Nvidia P100 GPU on Google Colab Pro.

