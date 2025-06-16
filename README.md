# Automated Citation Verification

**_An ML Engineering Capstone Project_**

This project develops an NLP framework for automated validation of citations and claims, ensuring references accurately support stated information. In an era where scientific misinformation can have serious consequences, verifying that citations properly support the claims they reference is crucial for maintaining the integrity of scientific literature and preventing the spread of false information.

**The Problem**: Studies show that 10-20% or more of citations in scientific literature are inaccurate, failing to support the claims they reference. This undermines scientific credibility and can perpetuate misinformation. Our solution uses state-of-the-art transformer models to automatically classify citation accuracy as SUPPORT, REFUTE, or NEI (Not Enough Information).

<div align="center">
  <img src="./images/project_diagram.png" alt="MLE Capstone Project Diagram" style="width:60%;"/>
</div>

## Key Achievements

### **Superior Model Performance**
Our fine-tuned DeBERTa model achieves a **7 percentage point increase in average F1** over the best baseline model:

<table>
  <tr>
    <td></td>
    <td colspan="3">Macro F1 on test split</td>
  </tr>
  <tr>
    <td>Model</td>
    <td>SciFact</td>
    <td>Citation-Integrity</td>
    <td><i>Average</i></td>
  </tr>
  <tr>
    <td>SciFact baseline [1]</td>
    <td>0.81</td>
    <td>0.15</td>
    <td><i>0.48</i></td>
  </tr>
  <tr>
    <td>Citation-Integrity baseline [2]</td>
    <td>0.74</td>
    <td>0.44</td>
    <td><i>0.59</i></td>
  </tr>
  <tr>
    <td>Fine-tuned DeBERTa [3]</td>
    <td><strong>0.84</strong></td>
    <td><strong>0.47</strong></td>
    <td><strong><i>0.66</i></strong></td>
  </tr>
</table>

### **Production-Ready Deliverables**

- **🏋 [PyVers Python Package](https://github.com/jedick/pyvers)**: Comprehensive framework for model training with multi-dataset ingestion, 🤗 Hugging Face integration, and ⚡ PyTorch Lightning for scalable training
- **🔀 [Fine-tuned Model](https://huggingface.co/jedick/DeBERTa-v3-base-mnli-fever-anli-scifact-citint)**: Publicly available model ready for inference
- **🌐 [AI4Citations Web Application](https://huggingface.co/spaces/jedick/AI4citations)**: **Live application** on Hugging Face Spaces where users can input claims and evidence to get verification results and provide feedback for model improvement
- **</> [Application Repository](https://github.com/jedick/AI4citations)**: Complete source code for [Gradio](https://github.com/gradio-app/gradio) frontend and evidence retrieval modules

### **Technical Innovation**
- Improvement on state-of-the-art baselines that use the MultiVerS model based on Longformer
- Multi-dataset training approach combining SciFact and Citation-Integrity datasets
- Evidence retrieval from PDFs using text similarity (BM25-based), semantic search (BERT-based), or LLMs (OpenAI API).
- Comprehensive evaluation framework with detailed performance metrics
- Feedback functionality implemented with Hugging Face Datasets
- API access to inference through the Gradio app

## Project Development Timeline

This project follows a systematic approach covering all aspects of the machine learning engineering lifecycle:

| Phase | Component | Description |
|-------|-----------|-------------|
| 🎯 | **Problem Definition** | [Initial project ideas](https://docs.google.com/document/d/1QMHkzGv1kPJtFDiK-1YWUcK4C_ysJywW/edit?usp=sharing&ouid=111099330977735872115&rtpof=true&sd=true) identifying citation accuracy as a critical scientific integrity issue |
| 📊 | **Data Collection** | [Data directory](data) with curated datasets from SciFact and Citation-Integrity |
| 📝 | **Project Proposal** | [Detailed proposal](notebooks/00_Project-Proposal.md) outlining approach and deliverables |
| 🔍 | **Literature Review** | [Research survey](notebooks/01_Reproduction-of-Citation-Integrity.ipynb) reproducing Citation-Integrity methodology |
| 🧹 | **Data Wrangling** | Notebooks for [Citation-Integrity](notebooks/02_Data-Wrangling-for-Citation-Integrity.ipynb) and [SciFact](notebooks/03_Data-Wrangling-for-SciFact.ipynb) preprocessing |
| 🔬 | **Data Exploration** | Analysis notebooks for [Citation-Integrity](notebooks/04_Data-Exploration-for-Citation-Integrity.ipynb) and [SciFact](notebooks/05_Data-Exploration-for-SciFact.ipynb) |
| 📍 | **Baseline Models** | [MultiVerS baseline](notebooks/06_Baselines.ipynb) and [checkpoint analysis](notebooks/07_Checkpoints-and-Rationale-Weight.ipynb) with custom [evaluation metrics](notebooks/eval.py) |
| 🧪 | **Model Experimentation** | [Blog post](https://jedick.github.io/blog/experimenting-with-transformer-models-for-citation-verification/) on fine-tuning DeBERTa across multiple datasets |
| 🪜 | **Scaling Prototype** | [Scaling implementation](notebooks/08_Scaling-Up.ipynb) for production readiness |
| 📐 | **Deployment Planning** | [Engineering plan](notebooks/09_Deployment-and-Engineering-Plan.md) and [architecture design](notebooks/10_Deployment-Architecture.md) |
| 💫 | **Production Deployment** | [Blog post](https://jedick.github.io/blog/deploying-AI4citations-from-research-to-production/) documenting deployment process |
| ❇ | **Project Sharing** | Public repositories (this one, [pyvers](https://github.com/jedick/pyvers), [AI4citations](https://github.com/jedick/AI4citations)) and [live application](https://huggingface.co/spaces/jedick/AI4citations) |

## Data Sources

The project combines two high-quality datasets for biomedical citations with consistent labeling and preprocessing:

### SciFact Dataset
- **Scope**: 1,409 scientific claims verified against 5,183 abstracts
- **Source**: [GitHub Repository](https://github.com/allenai/scifact) | [Research Paper](https://doi.org/10.18653/v1/2020.emnlp-main.609)
- **Main Topics**: gene expression, cancer, treatment, infection
- **Data Quality**: Enhanced test fold with labels and abstract IDs from [`scifact_10`](https://github.com/dwadden/multivers/blob/main/script/get_data_train.sh)

### Citation-Integrity Dataset
- **Scope**: 3,063 citation instances from biomedical publications
- **Source**: [GitHub Repository](https://github.com/ScienceNLP-Lab/Citation-Integrity/) | [Research Paper](https://doi.org/10.1093/bioinformatics/btae420)
- **Main Topics**: cells, cancer, COVID-19, patients

**Technical Approach**: Both datasets follow the [MultiVerS data format](https://github.com/dwadden/multivers/blob/main/doc/data.md), enabling consistent model training and evaluation across different domains.

## Novel Insights and Lessons Learned

This project uncovered several findings that weren't documented in existing literature or course materials:

### 🔄 **Sentence Pair Ordering Matters**
- **Discovery**: The order of sentence pairs in transformer tokenization significantly impacts performance
- **Investigation**: Model documentation and papers lack clarity on proper ordering for natural language inference
- **Solution**: Experiments revealed DeBERTa was trained with evidence-before-claim ordering
- **Impact**: Maintaining consistent ordering between fine-tuning and inference improved classification accuracy
- **Implementation**: The pyvers package enforces this ordering, enhancing model reliability

### 📈 **Rethinking Overfitting in Deep Learning**
- **Conventional Wisdom**: Classical ML teaches that overfitting hurts generalization
- **Surprising Finding**: Fine-tuning pretrained transformers on small datasets shows apparent overfitting after 1-2 epochs, yet continued training improves test accuracy
- **Insight**: The bias-variance tradeoff behaves differently for large parameter models
- **Documentation**: Detailed analysis in [blog post](https://jedick.github.io/blog/experimenting-with-transformer-models-for-citation-verification/#the-paradox-of-rising-loss-and-improving-accuracy) with connections to "benign overfitting" research
- **Practical Impact**: Optimized training schedules based on test performance rather than traditional early stopping

## Future Development Opportunities

- **Class Imbalance Handling**: Implement loss function reweighting similar to MultiVerS approach
- **Data Augmentation**: Integrate libraries like [TextAttack](https://github.com/QData/TextAttack), [TextAugment](https://github.com/dsfsi/textaugment), or [nlpaug](https://github.com/makcedward/nlpaug) for synthetic data generation
- **Efficient Fine-tuning**: Explore Low-rank Adaptation (LoRA) for faster training and overfitting mitigation
- **Expanded Domains**: Extend beyond biomedical literature to other scientific disciplines
- **Real-time Processing**: Optimize inference speed for large-scale document processing

## Acknowledgments

Special thanks to Divya Vellanki, my mentor, for invaluable guidance and encouragement throughout this project.

The Springboard MLE bootcamp provided the foundational knowledge and structured approach that made this project possible.

This work builds upon significant contributions from the research community:
- Citation-Integrity dataset by [Sarol et al. (2024)](https://doi.org/10.1093/bioinformatics/btae420)
- DeBERTa model by [He et al. (2021)](https://doi.org/10.48550/arXiv.2006.03654)
- MultiVerS model by [Wadden et al. (2021)](https://doi.org/10.48550/arXiv.2112.01640)
- SciFact dataset by [Wadden et al. (2020)](https://arxiv.org/abs/2004.14974)
- Longformer model by [Beltagy et al. (2020)](https://doi.org/10.48550/arXiv.2004.05150)

---

**References:**
- [1] MultiVerS pretrained on FeverSci and fine-tuned on SciFact by [Wadden et al. (2021)](https://doi.org/10.48550/arXiv.2112.01640)
- [2] MultiVerS pretrained on HealthVer and fine-tuned on Citation-Integrity by [Sarol et al. (2024)](https://doi.org/10.1093/bioinformatics/btae420)
- [3] DeBERTa v3 [pretrained on multiple NLI datasets](https://huggingface.co/MoritzLaurer/DeBERTa-v3-base-mnli-fever-anli) and fine-tuned on shuffled data from SciFact and Citation-Integrity in this project
