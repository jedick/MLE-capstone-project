## Predictions

This document summarizes the checkpoints and model parameters used for different sets of experiments.
Commits to the AI4citations repo are listed in brackets.

NOTE: The Reproductions and one Baseline model (`bestModel-001`) use the `../model/multivers_citint` codebase. All others use the `../model/multivers` codebase.

## Reproductions using the Citation-Integrity codebase

The models here start with the HealthVer checkpoint (`healthver.ckpt`) and use the code in `../model/multivers_citint`.
See [the notebook](../doc/02_Reproduction-of-Citation-Integrity.ipynb) for more information.

- `bestModel-001`: This is the best model from the [Citation-Integrity](https://github.com/ScienceNLP-Lab/Citation-Integrity) repository and was downloaded from [Google Drive](https://drive.google.com/drive/u/0/folders/11b6Z8iv2FXObWmLaqfYzgUQsaL4QgTT2?q=parent:11b6Z8iv2FXObWmLaqfYzgUQsaL4QgTT2).
- `citint_20241127` [[e10022](https://github.com/jedick/AI4citations/commit/e10022ecc4a24646708f6dd81e40f20208d62860)]: This is my first reproduction of the Citation-Integrity model. Except for modification made to `requirements.txt` and imported packages, the codebase is identical to [this commit of Citation-Integrity](https://github.com/ScienceNLP-Lab/Citation-Integrity/commit/277152f9dfe3873455220f4cd15269474ab15617).
- `citint_20241128` [[cf8461](https://github.com/jedick/AI4citations/commit/cf846148c39557c45d99e2fcbb3409adea4fede3)]: As in previous, but with the dataset in `val_dataloader` changed from `"test"` to `"val"`.
- `citint_20241129` [[d9782c](https://github.com/jedick/AI4citations/commit/d9782c98b4a017522388b11aafd25bec03507216)]: As in previous, but with the number of epochs in `train_target.py` changed from 5 to 20.

## Baseline models

- Files in the `baseline` directory [[cf59c5](https://github.com/jedick/AI4citations/commit/cf59c51ab8d022070d65716bda1cbe4d704c9a51)].
- File names: {starting checkpoint}\_{training dataset}\_{split}.jsonl.
- These predictions are made using checkpoints from MultiVerS and Citation-Integrity; no additional training was done.
- See [the notebook](../doc/07_Baselines.ipynb) for more information.

## Starting checkpoint and rationale weight

- Files in the `ckpt_rationale` directory were created with ../model/script/ckpt_rationale.sh.
- These experiments fine-tuning models starting from different checkpoints using the SciFact and Citation-Integrity datasets
- The training uses two settings for rationale weight (15 to enable the rationale identification task in MultiVerS and 0 to disable it).
- Predictions are made for the test splits.
- Predictions for the dev splits are in `ckpt_rationale_dev`.
- See [the notebook](../doc/08_Checkpoints_and_Rationale_Weight.ipynb) for more information.

