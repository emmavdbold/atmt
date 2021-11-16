#!usr/bin/env bash

pwd=`dirname "$(readlink -f "$0")"`
base=$pwd/../..
src=fr
tgt=en
data=$base/data/$tgt-$src/
bpe=$pwd/bpe_drop

# change into base directory to ensure paths are valid
cd $base

# Train model
python translate.py \
    --data $data/prepared_bpe_drop \
    --dicts $data/prepared_bpe_drop \
    --checkpoint-path $bpe/checkpoints/checkpoint_last.pt \
    --output $bpe/translations.bpe.txt
