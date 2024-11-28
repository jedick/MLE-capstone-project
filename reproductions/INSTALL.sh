# Installation notes by JMD on 2024-11-27

# Put claims_train.jsonl, claims_dev.jsonl, and claims_test.json in `data_train/target/scifact_10/`
# These are not the same files as in the `data` directory in Citation-Integrity github
Data files were downloaded from https://drive.google.com/drive/u/0/folders/11b6Z8iv2FXObWmLaqfYzgUQsaL4QgTT2?q=parent:11b6Z8iv2FXObWmLaqfYzgUQsaL4QgTT2

# Setup conda environment with working python version
conda create -n multivers python=3.8
conda activate multivers

# Install required packages for multivers
# Notes:
# - removed bertviz and FocalLoss import from multivers/model.py
# - renamed torch to pytorch
# Use -c conda forge to avoid this error: PackagesNotFoundError: The following packages are not available from current channels
conda install --file requirements.txt -c conda-forge

# Install the CUDA flavor of pytorch
# Run this to check GPU's CUDA version
nvidia-smi
# See https://pytorch.org/get-started/previous-versions/
# Note: run this *after* installing requirements.txt to avoid error with pandas import:
# ValueError: numpy.dtype size changed, may indicate binary incompatibility. Expected 96 from C header, got 88 from PyObject
conda install pytorch==1.7.1 torchvision==0.8.2 torchaudio==0.7.2 cudatoolkit=11.0 -c pytorch

# Don't use pytorch 2.4.1 ... getting an error
# RuntimeError: one of the variables needed for gradient computation has been modified by an inplace operation: [torch.cuda.HalfTensor [16, 512, 61]], which is output 0 of AsStridedBackward0, is at version 1; expected version 0 instead. Hint: enable anomaly detection to find the operation that failed to compute its gradient, with torch.autograd.set_detect_anomaly(True).

# Get healthver checkpoint - this is set by arguments in train_target.py
# Note modified wget command in get_checkpoint.py to continue interrupted download
python get_checkpoint.py healthver

# NOTUSED: Get Longformer checkpoint (see https://github.com/dwadden/multivers/tree/main)
# python get_checkpoint.py longformer_large_science

# Are all requirements and data in place? Try this to find out:
python train_target.py --dataset scifact_10 --gpus=1
# The following error occurs if transformer model can't be loaded from huggingface... just try again
# ValueError: Connection error, and we cannot find the requested files in the cached path. Please try again or make sure your Internet connection is on.

# Now start the training
# Takes about 3 hours
# Results saved in checkpoints_user --> last.ckpt renamed to CitationIntegrity_20241127.ckpt
CUDA_LAUNCH_BLOCKING=1 TOKENIZERS_PARALLELISM=false python train_target.py --dataset scifact_10 --gpus=1 --gradient_checkpointing > ./output.txt 2>&1

# Make predictions - about 1.5 minutes
python multivers/predict.py \
  --checkpoint_path=checkpoints/CitationIntegrity_20241127.ckpt \
  --input_file=data_train/target/scifact_10/claims_test.jsonl \
  --corpus_file=data_train/target/scifact_10/corpus.jsonl \
  --output_file=predictions/CitationIntegrity_20241127.jsonl

# Trying --checkpoint_path=checkpoints/fever_sci.ckpt
# Trying --checkpoint_path=checkpoints/healthver.ckpt
# Trying --checkpoint_path=checkpoints/longformer_large_science.ckpt
# RuntimeError: Error(s) in loading state_dict for MultiVerSModel: size mismatch for encoder.embeddings.word_embeddings.weight:
# copying a param with shape torch.Size([50275, 1024]) from checkpoint, the shape in current model is torch.Size([50278, 1024]).
# ... this is because there are three more tokens in data_train.py compared to original MultiVerS:
#
#        "citation_start": "<|cit|>",
#        "multi_citation_start": "<|multi_cit|>",
#        "other_citation_start": "<|other_cit|>",

# View the differences between original and modified MultiVerS files
# (dwadden/multivers -> ScienceNLP-Lab/Citation-Integrity)
git diff f76d724 13ebe74
