## Predictions

For each prediction file, the checkpoints and model parameters used for training are listed below.
Commits to the ReadyCite repo are listed in brackets.

## Using the MultiVerS codebase (December 2024)

The models here start with the FEVER checkpoint (`fever_sci.ckpt`).

- `citint_20241216` [XXX]: Model trained for 5 epochs.

## Using the Citation-Integrity codebase (November 2024)

The models here start with the HealthVer checkpoint (`healthver.ckpt`).

- `bestModel-001`: This is the best model from the [Citation-Integrity](https://github.com/ScienceNLP-Lab/Citation-Integrity) repository and was downloaded from [Google Drive](https://drive.google.com/drive/u/0/folders/11b6Z8iv2FXObWmLaqfYzgUQsaL4QgTT2?q=parent:11b6Z8iv2FXObWmLaqfYzgUQsaL4QgTT2).
- `citint_20241127` [[e10022](https://github.com/jedick/ReadyCite/commit/e10022ecc4a24646708f6dd81e40f20208d62860)]: This is my first reproduction of the Citation-Integrity model. Except for modification made to `requirements.txt` and imported packages, the codebase is identical to [this commit of Citation-Integrity](https://github.com/ScienceNLP-Lab/Citation-Integrity/commit/277152f9dfe3873455220f4cd15269474ab15617).
- `citint_20241128` [[cf8461](https://github.com/jedick/ReadyCite/commit/cf846148c39557c45d99e2fcbb3409adea4fede3)]: As in previous, but with the dataset in `val_dataloader` changed from `"test"` to `"val"`.
- `citint_20241129` [[d9782c](https://github.com/jedick/ReadyCite/commit/d9782c98b4a017522388b11aafd25bec03507216)]: As in previous, but with the number of epochs in `train_target.py` changed from 5 to 20.
