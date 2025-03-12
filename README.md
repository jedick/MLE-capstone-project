# 📚 ReadyCite

***AI-Powered Fact Checking for Scientific Citations***

## Project Overview

🎯 Studies suggest that 10-20% of scientific citations may be inaccurate, in that the cited source does not support the claim being made.
These errors can undermine research credibility, propagate misinformation, and waste researchers' time in tracing citation origins.
By automatically detecting inaccurate citations, this project aims to enhance the integrity and reliability of academic publications.

🛠 This project has several components.
At the core is a claim verification system that uses a claim statement and evidence sentences to assign a label denoting the relationship: Refute, Support, or Not Enough Information (NEI).
This claim verification system is based on the [MultiVerS model](https://github.com/dwadden/multivers) which uses the Longformer transformer for handling long input sequences.
It is trained using diverse datasets including Fever, [SciFact](https://doi.org/10.18653/v1/2020.emnlp-main.609), and [Citation-Integrity](https://doi.org/10.1093/bioinformatics/btae420) for applicability to scientific texts.

🚀 Additional components, currently in development, are an atomic claim generator that uses an LLM to identify individual claims in a complex input text.
Such a system was recently demonstrated as part of the [Search-Augmented Factuality Evaluator (SAFE)](https://doi.org/10.48550/arXiv.2403.18802).
An evidence retrieval module (such as BM25) will be used to extract evidence sentences from PDFs in a database or provided by the user.

## 📊 Data Sources

- **SciFact**: 1,409 scientific claims verified against 5,183 abstracts
- **Citation-Integrity**: 3,063 citation instances from biomedical publications
- **Fever**: 185,445 claims from Wikipedia (pre-training)

## 🧰 Planned Deliverables

- Web application for citation accuracy verification
- Open-source machine learning models
- Detailed research and system documentation

## 📋 Documentation

See the **doc** directory for write-ups and Jupyter notebooks:
- [Motivation](doc/00_Motivation-Scope-Data.md) and [project proposal](doc/01_Project-Proposal.md)
- Reproduction of [Citation-Integrity](doc/02_Reproduction-of-Citation-Integrity.ipynb) model
- Data wrangling: [Citation-Integrity](doc/03_Data-Wrangling-for-Citation-Integrity.ipynb) and [SciFact](doc/04_Data-Wrangling-for-SciFact.ipynb)
- Data exploration: [Citation-Integrity](doc/05_Data-Exploration-for-Citation-Integrity.ipynb) and [SciFact](doc/06_Data-Exploration-for-SciFact.ipynb)
- Model [baselines](doc/07_Baselines.ipynb) and starting [checkpoints](doc/08_Checkpoints_and_Rationale_Weight.ipynb)
