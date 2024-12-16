# Training data

Notes:
- The directories should be copied or linked to the appropriate location for training.
  For example, link `citint` to `../multivers/data_train/target/citint` to train with the Citation-Integrity dataset.
- The labels `scifact` and `citint` have been normalized as follows:
  - `SUPPORT` instead of `ACCURATE`
  - `REFUTE` instead of `CONTRADICT` or `NOT_ACCURATE`

## scifact

This is the SciFact dataset by [Wadden et al., 2020](https://arxiv.org/abs/2004.14974).
Downloaded from https://scifact.s3-us-west-2.amazonaws.com/release/latest/data.tar.gz, which is linked from https://github.com/allenai/scifact

## citint

This is the Citation-Integrity dataset by [Sarol et al., 2024](https://doi.org/10.1093/bioinformatics/btae420).
Downloaded from https://drive.google.com/drive/u/0/folders/11b6Z8iv2FXObWmLaqfYzgUQsaL4QgTT2, which is linked from https://github.com/ScienceNLP-Lab/Citation-Integrity/

## Fever

[This is a large dataset.](https://fever.ai/dataset/fever.html.)
The full dataset is not provided here, but links to specific data files are listed below.

- [Training Dataset](https://fever.ai/download/fever/train.jsonl) (Labelled, 145449 claims)
- [Shared Task Development Dataset](https://fever.ai/download/fever/shared_task_dev.jsonl) (Labelled, 19998 claims)
- [Shared Task Blind Test Dataset](https://fever.ai/download/fever/shared_task_test.jsonl) (Unlabelled, 19998 claims)
