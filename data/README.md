# Collection of publicly available data

## SciFact

Copied from https://scifact.s3-us-west-2.amazonaws.com/release/latest/data.tar.gz, which is linked from https://github.com/allenai/scifact

[License](https://github.com/allenai/scifact?tab=License-1-ov-file):
> All claims and evidence annotations -- in the files `claims_*.jsonl` -- are released under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
> The abstracts in the corpus -- in the file `corpus.jsonl` -- are part of the Semantic Scholar [S2ORC dataset](https://github.com/allenai/s2orc) and are licensed under [ODC-By 1.0](https://opendatacommons.org/licenses/by/1-0/).

See [schema information](https://github.com/allenai/scifact/blob/master/doc/data.md) and the [publication](https://doi.org/10.18653/v1/2020.emnlp-main.609) for details.

## Citation-Integrity

Copied from https://drive.google.com/drive/u/0/folders/11b6Z8iv2FXObWmLaqfYzgUQsaL4QgTT2, which is linked from https://github.com/ScienceNLP-Lab/Citation-Integrity/

License: Not specified. The [GitHub repository](https://github.com/ScienceNLP-Lab/Citation-Integrity/) is available under an MIT license.

## Smith_and_Cumberledge

Modified from the dataset available at: https://repository.ahu.edu/handle/20.500.12521/8

License: Not specified. The [journal article](https://doi.org/10.1098/rspa.2020.0538) is © 2020 The Author(s).

Description: Dataset of quotation accuracy in general science journals.
Human annotations of citations in *Science*, *Science Advances*, *PNAS*, *Nature Communications*, and *Nature*.
There are 250 rows of data (50 rows for each journal), with columns named `File Names`, `Article`, `References`, `Reviewer`, `Category`, and `String Cite`.
*Because of the smaller size of this dataset, it will not be used here.*

## Other sources

[Dmonte et al. (2024)](https://doi.org/10.48550/arXiv.2408.14317) list 31 English-langauge datasets used for automated claim-verification systems. The median number of instances is 12500, with an IQR of 1751 to 23662. With the possible exceptions of **SciFact** (listed above) and **SciFact-Open**, these datasets do not address quotation accuracy in peer-reviewed scientific publications and will not be used in this project.