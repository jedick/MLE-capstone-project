# ML Capstone Project

This project develops an NLP framework for automated validation of citations and claims, ensuring references accurately support stated information.
We build on established datasets and models to classify citation accuracy as SUPPORT, REFUTE, or NEI (Not Enough Information).

## Highlights

- Reproduction of state-of-the-art scientific claim verification baselines - [baselines](baselines)
  - Uses MultiVerS model, based on Longformer
- Development of Python package with ML engineering capabilities - [pyvers](https://github.com/jedick/pyvers)
  - Ingestion of multiple data sources using consistent labeling -- both data files and HuggingFace datasets
  - Uses HF models pretrained on natural language inference (NLI) datasets to support the claim verification task
  - Fine-tunes models using Pytorch Lightning for scalable model training, evaluation, and reporting
- Deployment of final model to HuggingFace - [fine-tuned model](https://huggingface.co/jedick/DeBERTa-v3-base-mnli-fever-anli-scifact-citint)
- Web app for end users - [AI4citations](https://github.com/jedick/AI4citations)
  - Input a claim and evidence statements to get results
  - Barchart visualization of class probabilities
  - Choose from pre-trained and fine-tuned models

## Milestones

All the steps of the project, from data exploration and processing to model training and deployment are recorded in notebook and blog posts.

- **Proposal**: [Project proposal](notebooks/00_Project-Proposal.md)
- **Data Wrangling**: 
  - [Citation-Integrity](notebooks/02_Data-Wrangling-for-Citation-Integrity.ipynb)
  - [SciFact](notebooks/03_Data-Wrangling-for-SciFact.ipynb)
- **Data Exploration**:
  - [Citation-Integrity](notebooks/04_Data-Exploration-for-Citation-Integrity.ipynb)
  - [SciFact](notebooks/05_Data-Exploration-for-SciFact.ipynb)
- **Baselines** - reproductions and baselines using the MultiVerS model fine-tuned on single datasets:
  - [Citation-Integrity model](notebooks/01_Reproduction-of-Citation-Integrity.ipynb)
  - [Model baselines](notebooks/06_Baselines.ipynb)
  - [Comparison of starting checkpoints](notebooks/07_Checkpoints_and_Rationale_Weight.ipynb)
  - [eval.py](notebooks/eval.py) - Metrics calculation module
- **Model Development** - more recent transformer models fine-tuned on multiple datasets:
  - [Experiments with different transformer models](https://jedick.github.io/blog/experimenting-with-transformer-models/) (blog post)
  - [Scaling up the model](notebooks/08_Scaling_Up.ipynb)

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

## Acknowledgments

This project builds upon several significant contributions from the scientific community:

- SciFact dataset by [Wadden et al., 2020](https://arxiv.org/abs/2004.14974)
- Citation-Integrity dataset by [Sarol et al., 2024](https://doi.org/10.1093/bioinformatics/btae420)
- MultiVerS model by [Wadden et al., 2021](https://doi.org/10.48550/arXiv.2112.01640)
- Longformer model by [Beltagy et al., 2020](https://doi.org/10.48550/arXiv.2004.05150)

