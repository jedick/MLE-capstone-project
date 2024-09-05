# readycite

Quotation errors are unfortunately common in the scientific literature ([Jergas and Baethge, 2015](https://doi.org/10.7717/peerj.1364); [Mogull, 2017](https://doi.org/10.1371/journal.pone.0184727)). This type of error occurs when a claim is not supported by the provided citation. The standard advice to avoid quotation errors is: "*Read before you cite*" ([Steel, 1996](https://doi.org/10.1016/S0140-6736\(05\)66108-9); [Simkin and Roychowdhury, 2003](https://www.complex-systems.com/issues/14-3/)).

Human judgment (informed by actually reading the cited reference) is essential to prevent quotation errors. At the same time, machine learning is emerging as a useful method of claim verification. Automatic detection of quotation errors would help writers, reviewers, editors, and publishers to improve the quality of the scientific record.

The aim of this project is to build a machine learning system that identifies quotation errors in a source text. Given a manuscript together with the text of the cited references, the algorithm will produce a list of claims (i.e., sentences with a citation) and a classification of whether each claim is adequately supported by the citation.

This project will utilize techniques of natural language processing (NLP) together with large language models (LLMs) and retrieval augmented generation (RAG).

## Training data

Many studies of quotation accuracy have been published, but few provide the raw data required to train a model. These data should include the list of claims, citations, and human annotations of citation accuracy. Datasets from the following studies will be used in training:

[Sarol et al. (2024)](https://doi.org/10.1093/bioinformatics/btae420): **Citation-Integrity** is a corpus based on citations to 100 highly-cited biomedical publications with full text available from the PubMed Central Open Access Subset. Citing articles were randomly selected from those that cite the reference article multiple times. According to the authors, "A total of 3063 citation instances corresponding 3420 cita­tion context sentences and 3791 evidence sentences were annotated". Their data and NLP model are available on [GitHub](https://github.com/ScienceNLP-Lab/Citation-Integrity/) and [Google Drive](https://drive.google.com/drive/u/0/folders/11b6Z8iv2FXObWmLaqfYzgUQsaL4QgTT2).

[Smith and Cumberledge (2020)](https://doi.org/10.1098/rspa.2020.0538): Dataset of quotation accuracy in general science journals. Human annotations of 250 citations in *Science*, *Science Advances*, *PNAS*, *Nature Communications*, and *Nature*. Data are available at [AHU Digital Repository](http://hdl.handle.net/20.500.12521/8).

[Wadden et al. (2020)](https://doi.org/10.18653/v1/2020.emnlp-main.609): "The **SciFact** dataset consists of 1,409 scientific claims verified against a corpus of 5,183 abstracts." The claims are written by experts, paired with abstracts, and annotated with labels and rationales. [GitHub](https://github.com/allenai/scifact) and [AI2 leaderboard](https://leaderboard.allenai.org/scifact/submissions/public)

### Training task 1: Claim verification

In this stage, evidence sentences or abstracts available in the **Citation-Integrity** and **SciFact** datasets will be used for training the model. The total number of citation instances to be used for training is approximately 4,800.

The **SciFact** dataset contains abstracts of articles rather than human-identified evidence sentences (which are in the **Citation-Integrity** dataset). Wadden et al. (2020) state that "evidence is found in the abstract in more than 60% of cases", but this implies that evidence for a considerable number of claims is not in the abstract. Therefore, the second	 task for this project is evidence retrieval from source documents.

### Training task 2: Evidence retrieval

In this stage, evidence sentences are not given, but will be obtained from source documents (e.g. PDFs of journal articles) using evidence retrieval algorithms. The size of the input data that must be processed to gather evidence sentences is much larger than the number of citation instances. Taking 100 sentences in a journal article as a low estimate ([the median for papers in PubMed Central is closer to 166](https://quantifyinghealth.com/length-of-a-research-paper)), *at least 175,900 sentences would need to be processed* to verify the citations available in the datasets listed above (**Citation-Integrity**: 100 × 100 reference articles; **Smith_and_Cumberledge**: 100 × 250 reference articles; **SciFact**: 100 × ca. 1,409 reference articles, not counting "distractor abstracts" added to the corpus).

### Other sources

[Dmonte et al. (2024)](https://doi.org/10.48550/arXiv.2408.14317) list 31 English-langauge datasets used for automated claim-verification systems. The median number of instances is 12500, with an IQR of 1751 to 23662. With the possible exceptions of **SciFact** (listed above) and **SciFact-Open**, these datasets do not address citation accuracy in peer-reviewed scientific publications and will not be used in this project.

## End-to-end: Processing user-provided documents

Because of the difficulty of automatically accessing content from a reference list (even with a DOI, many articles are paywalled), the user-provided input must include both the source text and the text of all references.

## Scaling up: Analyzing bioRxiv

TODO

## Glossary

- Reference error - broad class that includes quotation errors and citation errors. The definitions given below are derived from other authors (e.g. [Eichorn and Yankauer, 1987](https://doi.org/10.2105/AJPH.77.8.1011); Smith and Cumberledge, 2020; [Lang, 2023](https://doi.org/10.3897/ese.2023.e94153)).
	- Quotation error - a reference error in which the content of the cited reference does not support the claim made by the authors, or there is some other inconsistency between the authors' proposition and the cited reference. **Detecting this type of error is the goal of this project.**
	- Citation error - a reference error in which the reference text has incorrect bibliographic information (e.g., a typographical error).
- Citation instance - a single instance of a citation in a citing article (Sarol et al., 2024).
- Citation sentence (syn. citance) - the sentence containing a citation (Sarol et al., 2024).
- Reference article - the article being cited (Sarol et al., 2024).
- Citation accuracy (syn. quotation accuracy) - A label that describes whether a citation supports a claim. **The model will be trained on datasets with these labels.** Various authors use different classifications, described below.
	- Claim verification:  Labels include Support, Refute, or Neutral (Not Enough Information) (Sarol et al., 2024; Wadden et al., 2020).
	- Proposition substantiation: Fully substantiated, Partially substantiated, Unsubstantiated, Impossible to substantiate (Smith and Cumberledge, 2020)

## Keywords

Quotation accuracy, Quotation error, Citation accuracy, Citation bias, Citation distortion, Citation integrity, Misattribution, Miscitation, Misinformation
