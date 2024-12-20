#!/bin/sh
# Script to alternate training on citint and scifact, starting from healthver checkpoint
# 20241219 jmd

export CUDA_LAUNCH_BLOCKING=1
export TOKENIZERS_PARALLELISM=false

train_and_predict () {
  
  # Arguments for this function (not the script):
  # $1 starting checkpoint or cycle number (0-based)
  # $2 dataset for *training* (citintnm or scifact)
  # $3 number of epochs
  # $4 dataset for *predictions*

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

#  echo "python script/train_target.py --dataset $2 --gpus=1 --epochs=$3 --ckpt=$ckpt --gradient_checkpointing"
#  time python script/train_target.py --dataset $2 --gpus=1 --epochs=$3 --ckpt=$ckpt --gradient_checkpointing
  echo "outputting predictions to ../predictions/xtrain$3_$num_$4.jsonl"
  python multivers/predict.py \
    #--checkpoint_path checkpoints_user/$2/checkpoint/last.ckpt \
    --checkpoint_path /home/multivers/checkpoints/xtrain$3/xtrain$3_$num.ckpt \
    --input_file data_train/target/$4/claims_test.jsonl \
    --corpus_file data_train/target/$4/corpus.jsonl \
    --output_file ../predictions/xtrain$3_$num_$4.jsonl

#  mv checkpoints_user/$2/checkpoint/last.ckpt /home/multivers/checkpoints/xtrain$3_$num.ckpt
#  rm -rf checkpoints_user/$2/checkpoint/
#  mv checkpoints_user/$2 checkpoints_user/xtrain$3_$num

}

# Alternate training on citintnm and scifact for 5 epochs each (20 total)
xtrain5 () {
#  train_and_predict checkpoints/baseline/healthver.ckpt citintnm 5 citintnm
  train_and_predict 1 scifact 5 citintnm
#  train_and_predict 2 citintnm 5 citintnm
  train_and_predict 3 scifact 5 citintnm
}

# Alternate training on citintnm and scifact for 5 epochs each (20 total)
xtrain2 () {
#  train_and_predict checkpoints/baseline/healthver.ckpt citintnm 2 citintnm
  train_and_predict 1 scifact 2 citintnm
#  train_and_predict 2 citintnm 2 citintnm
  train_and_predict 3 scifact 2 citintnm
#  train_and_predict 4 citintnm 2 citintnm
  train_and_predict 5 scifact 2 citintnm
#  train_and_predict 6 citintnm 2 citintnm
  train_and_predict 7 scifact 2 citintnm
#  train_and_predict 8 citintnm 2 citintnm
  train_and_predict 9 scifact 2 citintnm
}

# Alternate training on citintnm and scifact for 1 epoch each (20 total)
xtrain1 () {
#  train_and_predict checkpoints/baseline/healthver.ckpt citintnm 1 citintnm
  train_and_predict 1 scifact 1 citintnm
#  train_and_predict 2 citintnm 1 citintnm
  train_and_predict 3 scifact 1 citintnm
#  train_and_predict 4 citintnm 1 citintnm
  train_and_predict 5 scifact 1 citintnm
#  train_and_predict 6 citintnm 1 citintnm
  train_and_predict 7 scifact 1 citintnm
#  train_and_predict 8 citintnm 1 citintnm
  train_and_predict 9 scifact 1 citintnm
#  train_and_predict 10 citintnm 1 citintnm
  train_and_predict 11 scifact 1 citintnm
#  train_and_predict 12 citintnm 1 citintnm
  train_and_predict 13 scifact 1 citintnm
#  train_and_predict 14 citintnm 1 citintnm
  train_and_predict 15 scifact 1 citintnm
#  train_and_predict 16 citintnm 1 citintnm
  train_and_predict 17 scifact 1 citintnm
#  train_and_predict 18 citintnm 1 citintnm
  train_and_predict 19 scifact 1 citintnm
}

# Usage:
# Run this script from the 'model' directory.
# To train for 1 epoch each (takes about 8 hours):
# sh script/xtrain.sh 1

if [[ $1 == "1" ]]
then
    xtrain1
elif [[ $1 == "2" ]]
then
    xtrain2
elif [[ $1 == "5" ]]
then
    xtrain5
else
    echo "Allowed options are: {1, 2, 5}."
fi
