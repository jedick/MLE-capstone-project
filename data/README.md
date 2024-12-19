# Training data

The directories should be copied or linked to the appropriate location for training.
For example, link `citint` to `../multivers/data_train/target/citint` to train on the Citation-Integrity dataset.

Local modifications:
- The labels have been normalized as follows:
  - REFUTE replaces CONTRADICT in `scifact`
  - SUPPORT replaces ACCURATE in `citint`
  - REFUTE replaces NOT_ACCURATE in `citint`
- To enable predictions on the test fold of `scifact`, cited_doc_ids were added from `scifact_10`.
- Claims in `citint` have been reordered by increasing claim ID using `citint/reorder_claims.R`.
  - The unordered claims were discovered by an error thrown in `format_predictions()` on the dev and train folds but not the test fold.
- Claims in `citintnm` inherit the above changes to `citint` and have had the citation markers and surrounding punctuation removed with the following commands in sed:
  - `s/<|multi_cit|>//g`
  - `s/<|other_cit|>//g`
  - `s/<|cit|>//g`
  - `s/\ \[\]//g`
  - `s/\ ()//g`
  - `s/\[\]//g`
  - `s/()//g`

## scifact

This is modified from the SciFact dataset by [Wadden et al., 2020](https://arxiv.org/abs/2004.14974).
Downloaded from https://scifact.s3-us-west-2.amazonaws.com/release/latest/data.tar.gz (linked from https://github.com/allenai/scifact).
`scifact_10` is available at https://scifact.s3.us-west-2.amazonaws.com/longchecker/latest/data_train.tar.gz (linked from https://github.com/dwadden/multivers/blob/main/script/get_data_train.sh).

## citint

This is modified from the Citation-Integrity dataset by [Sarol et al., 2024](https://doi.org/10.1093/bioinformatics/btae420).
Downloaded from https://drive.google.com/drive/u/0/folders/11b6Z8iv2FXObWmLaqfYzgUQsaL4QgTT2, which is linked from https://github.com/ScienceNLP-Lab/Citation-Integrity/

## Fever

[This is a large dataset.](https://fever.ai/dataset/fever.html.)
The full dataset is not provided here, but links to specific data files are listed below.

- [Training Dataset](https://fever.ai/download/fever/train.jsonl) (Labeled, 145449 claims)
- [Shared Task Development Dataset](https://fever.ai/download/fever/shared_task_dev.jsonl) (Labeled, 19998 claims)
- [Shared Task Blind Test Dataset](https://fever.ai/download/fever/shared_task_test.jsonl) (Unlabeled, 19998 claims)
