#!/bin/sh
# Script to alternate training on citint and scifact, starting from healthver checkpoint
# 20241219 jmd

export CUDA_LAUNCH_BLOCKING=1
export TOKENIZERS_PARALLELISM=false

train_and_predict () {
  
  # Arguments for this function (not the script):
  # $1 starting checkpoint
  # $2 dataset (citintnm or scifact)
  # $3 number of epochs

  echo "python script/train_target.py --dataset $2 --gpus=1 --epochs=$3 --ckpt=checkpoints/baseline/$1.ckpt --gradient_checkpointing"
  time python script/train_target.py --dataset $2 --gpus=1 --epochs=$3 --ckpt=checkpoints/baseline/$1.ckpt --gradient_checkpointing
  echo "outputting predictions to ../predictions/$1_$2.jsonl"
  python multivers/predict.py \
    --checkpoint_path checkpoints_user/$2/checkpoint/last.ckpt \
    --input_file data_train/target/$2/claims_test.jsonl \
    --corpus_file data_train/target/$2/corpus.jsonl \
    --output_file ../predictions/$1_$2.jsonl

  mv checkpoints_user/$2/checkpoint/last.ckpt /home/multivers/checkpoints/$1_$2.ckpt
  rm -rf checkpoints_user/$2/checkpoint/
  mv checkpoints_user/$2 checkpoints_user/$1_$2

}

# Train on citintnm from different starting checkpoints for 5 epochs each
citintnm () {
  train_and_predict fever_sci citintnm 5
  train_and_predict covidfact citintnm 5
  ## This is identical to the first step of xtrain5 so copy the predictions from there...
  #train_and_predict healthver citintnm 5
  train_and_predict scifact citintnm 5
  train_and_predict bestModel-001 citintnm 5
}

# Train on citint from different starting checkpoints for 5 epochs each
citint () {
  train_and_predict fever_sci citint 5
  train_and_predict covidfact citint 5
  train_and_predict healthver citint 5
  train_and_predict scifact citint 5
  train_and_predict bestModel-001 citint 5
}


# Usage:
# Run this script from the 'model' directory.
# sh script/cpcomp.sh citintnm

if [[ $1 == "citintnm" ]]
then
    citintnm
elif [[ $1 == "citint" ]]
then
    citint
else
    echo "Allowed options are: {citintnm, citint}."
fi
