#!/bin/sh
# Script to test different starting checkpoints and rationale weight
# 20241219 jmd

export CUDA_LAUNCH_BLOCKING=1
export TOKENIZERS_PARALLELISM=false

train_and_predict () {
  
  # Arguments for this function (not the script):
  # $1 starting checkpoint
  # $2 dataset
  # $3 number of epochs
  # $4 rationale weight (default in multivers/model.py is 15.0)

  echo "python script/train_target.py --dataset $2 --gpus=1 --epochs=$3 --ckpt=checkpoints/baseline/$1.ckpt --gradient_checkpointing --rationale_weight=$4"
  time python script/train_target.py --dataset $2 --gpus=1 --epochs=$3 --ckpt=checkpoints/baseline/$1.ckpt --gradient_checkpointing --rationale_weight=$4
  echo "outputting predictions to ../predictions/$1_$2.jsonl"
  python multivers/predict.py \
    --checkpoint_path checkpoints_user/$2/checkpoint/last.ckpt \
    --input_file data_train/target/$2/claims_test.jsonl \
    --corpus_file data_train/target/$2/corpus.jsonl \
    --output_file ../predictions/$1_$2_$4.jsonl

  mv checkpoints_user/$2/checkpoint/last.ckpt /home/multivers/checkpoints/$1_$2.ckpt
  rm -rf checkpoints_user/$2/checkpoint/
  mv checkpoints_user/$2 checkpoints_user/$1_$2

}

# Train on citint with rationale_weight = 15
citint_15 () {
  train_and_predict fever_sci citint 5 15
  train_and_predict covidfact citint 5 15
  train_and_predict healthver citint 5 15
  train_and_predict scifact citint 5 15
}

# Train on citint with rationale_weight = 0
citint_0 () {
  train_and_predict fever_sci citint 5 0
  train_and_predict covidfact citint 5 0
  train_and_predict healthver citint 5 0
  train_and_predict scifact citint 5 0
}

# Train on scifact with rationale_weight = 15
scifact_15 () {
  train_and_predict fever_sci scifact 5 15
  train_and_predict covidfact scifact 5 15
  train_and_predict healthver scifact 5 15
  train_and_predict scifact scifact 5 15
}

# Train on scifact with rationale_weight = 0
scifact_0 () {
  train_and_predict fever_sci scifact 5 0
  train_and_predict covidfact scifact 5 0
  train_and_predict healthver scifact 5 0
  train_and_predict scifact scifact 5 0
}

# Usage:
# Run this script from the 'model' directory.
# sh script/ckpt_rationale.sh citint_15
# Takes about 10 hours for citint, 5 hours for scifact

if [[ $1 == "citint_15" ]]
then
  citint_15
elif [[ $1 == "citint_0" ]]
then
  citint_0
elif [[ $1 == "scifact_15" ]]
then
  scifact_15
elif [[ $1 == "scifact_0" ]]
then
  scifact_0
else
    echo "Allowed options are: {citintnm, citint}."
fi
