#!/bin/sh

export CUDA_LAUNCH_BLOCKING=1
export TOKENIZERS_PARALLELISM=false

# Start with healthver checkpoint then alternate training on citint and scifact

# Arguments
# $1 starting checkpoint or cycle number (0-based)
# $2 dataset (citintnm or scifact)
# $3 number of epochs
train_predict () {

  # Test if $1 is numeric
  re='^[0-9]+$'
  if ! [[ $1 =~ $re ]] ; then
    # Not numeric: a starting checkpoint file; this is the first cycle
    ckpt=$1
    num=0
  else
    # Numeric: number of the current cycle
    num=$1
    last=$(($num-1))
    ckpt=/home/multivers/checkpoints/xtrain$3_$last.ckpt
  fi

  echo "python script/train_target.py --dataset $2 --gpus=1 --epochs=$3 --ckpt=$ckpt --gradient_checkpointing"
  time python script/train_target.py --dataset $2 --gpus=1 --epochs=$3 --ckpt=$ckpt --gradient_checkpointing
  echo "outputting predictions to ../predictions/xtrain$3_$num.jsonl"
  python multivers/predict.py \
    --checkpoint_path checkpoints_user/$2/checkpoint/last.ckpt \
    --input_file data_train/target/$2/claims_test.jsonl \
    --corpus_file data_train/target/$2/corpus.jsonl \
    --output_file ../predictions/xtrain$3_$num.jsonl

  mv checkpoints_user/$2/checkpoint/last.ckpt /home/multivers/checkpoints/xtrain$3_$num.ckpt
  rm -rf checkpoints_user/$2/checkpoint/
  mv checkpoints_user/$2 checkpoints_user/xtrain$3_$num

}

# Alternate training on citintnm and scifact for 5 epochs each
xtrain5 () {

  train_predict checkpoints/healthver.ckpt citintnm 5
  train_predict 1 scifact 5
  train_predict 2 citintnm 5
  train_predict 3 scifact 5
  train_predict 4 citintnm 5

}
