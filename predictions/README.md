## Predictions

For each prediction file, the checkpoints and model parameters used for training are listed below.
Commits to the ReadyCite repo are listed in brackets.

## Baseline models

- Files added in `baseline` directory [XXX]
- See [the notebook](../doc/07_Baselines.ipynb) for more information.

## Using the MultiVerS codebase

The models here start with the `fever_sci.ckpt` checkpoint.

- `citint_20241216a` [[5e08ba](https://github.com/jedick/ReadyCite/commit/5e08ba51295ecdbb42cfdd9b86908adb7b06c7f3)]: Model trained for 5 epochs.
- `citint_20241216b` [[74ed58](https://github.com/jedick/ReadyCite/commit/74ed58bb1cb34c206970d580cb6aaa046dedb80f)]: Model trained for 20 epochs.

## Using the Citation-Integrity codebase

The models here start with the HealthVer checkpoint (`healthver.ckpt`).

- `bestModel-001`: This is the best model from the [Citation-Integrity](https://github.com/ScienceNLP-Lab/Citation-Integrity) repository and was downloaded from [Google Drive](https://drive.google.com/drive/u/0/folders/11b6Z8iv2FXObWmLaqfYzgUQsaL4QgTT2?q=parent:11b6Z8iv2FXObWmLaqfYzgUQsaL4QgTT2).
- `citint_20241127` [[e10022](https://github.com/jedick/ReadyCite/commit/e10022ecc4a24646708f6dd81e40f20208d62860)]: This is my first reproduction of the Citation-Integrity model. Except for modification made to `requirements.txt` and imported packages, the codebase is identical to [this commit of Citation-Integrity](https://github.com/ScienceNLP-Lab/Citation-Integrity/commit/277152f9dfe3873455220f4cd15269474ab15617).
- `citint_20241128` [[cf8461](https://github.com/jedick/ReadyCite/commit/cf846148c39557c45d99e2fcbb3409adea4fede3)]: As in previous, but with the dataset in `val_dataloader` changed from `"test"` to `"val"`.
- `citint_20241129` [[d9782c](https://github.com/jedick/ReadyCite/commit/d9782c98b4a017522388b11aafd25bec03507216)]: As in previous, but with the number of epochs in `train_target.py` changed from 5 to 20.
