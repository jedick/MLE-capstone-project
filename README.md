# 📚 ReadyCite: AI-Driven Fact Checking for Scientific Citations

## 🎯 Project Overview

ReadyCite is an innovative machine learning system designed to address a critical challenge in scientific literature: quotation errors. By automatically detecting inaccurate citations, this project aims to enhance the integrity and reliability of academic publications.

## ✨ Key Features

- **Automated Citation Checking**: Identify citations that do not accurately support the claims made in scientific manuscripts
- **Multi-Dataset Training**: Leverages diverse datasets including SciFact, Citation-Integrity, and Fever for comprehensive learning
- **Advanced NLP Techniques**: Utilizes state-of-the-art natural language processing models like Longformer and BERT
- **Scalable Architecture**: Designed to process massive scientific literature datasets

## 🔍 Problem Statement

Quotation errors are unfortunately common in scientific literature, with studies suggesting 10-20% of citations may be inaccurate. These errors can:
- Undermine research credibility
- Propagate misinformation
- Waste researchers' time in tracing citation origins

## 🛠 Technical Approach

The project is structured in three progressive phases:

1. **Initial Model Training** 
   - Use preprocessed datasets with abstracts and evidence sentences
   - Develop baseline citation accuracy classification

2. **Evidence Retrieval Pipeline**
   - Expand from abstracts to full-text PDF processing
   - Implement advanced sentence retrieval techniques (BM25, MonoT5 reranking)

3. **Large-Scale Deployment**
   - Cloud deployment
   - Processing extensive databases like bioRxiv

## 📊 Data Sources

- **SciFact**: 1,409 scientific claims verified against 5,183 abstracts
- **Citation-Integrity**: 3,063 citation instances from biomedical publications
- **Fever**: 185,445 claims from Wikipedia (pre-training)

## 🚀 Planned Deliverables

- Web application for citation accuracy verification
- Open-source machine learning models
- Detailed research documentation

## 🧰 Technologies

- Python
- PyTorch
- Transformers (BERT, Longformer)
- Natural Language Processing Libraries
- Machine Learning Frameworks

## 📋 Project Status

**Current Phase**: Model Training and Validation
- Reproducing Citation-Integrity model
- Experimenting with training epochs and datasets

## 🤝 Contributing

Interested in improving scientific literature integrity? Contributions are welcome! Please read our contribution guidelines.

## 📞 Contact

Jeffrey Dick - Project Lead
