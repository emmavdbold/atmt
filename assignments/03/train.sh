#!usr/bin/env bash

pwd=`dirname "$(readlink -f "$0")"`
base=$pwd/../..
src=fr
tgt=en
data=$base/data/$tgt-$src/

# create model directory
mkdir -p bpe_drop
mkdir -p bpe_drop/checkpoints

bpe=$pwd/bpe_drop

# change into base directory to ensure paths are valid
cd $base

# Train model
python train.py --data $data/prepared_bpe_drop --source-lang $src --target-lang $tgt --save-dir $bpe/checkpoints --log-file $bpe/bpe.log
