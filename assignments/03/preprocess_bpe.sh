#!usr/bin/env bash

# Script for applying BPE to all data
# /preprocessed/ folder should already exist

pwd=`dirname "$(readlink -f "$0")"`
base=$pwd/../..
src=fr
tgt=en
data=$base/data/$tgt-$src/

# change into base directory to ensure paths are valid
cd $base

# create new directory for all bpe-related preprocessing files
mkdir -p $data/preprocessed_bpe

# learn a BPE model on the training data from both languages and create vocabulary files along the way
subword-nmt learn-joint-bpe-and-vocab \
    --input $data/preprocessed/train.$src $data/preprocessed/train.$tgt \
    --write-vocabulary $data/preprocessed_bpe/vocab.$src $data/preprocessed_bpe/vocab.$tgt \
    --output $data/preprocessed_bpe/codes_"$tgt-$src".bpe \
    --symbols 4000 \
    --total-symbols

# apply the BPE model to all data on both source and target side
for split in train valid test tiny_train
do
    subword-nmt apply-bpe \
        --codes $data/preprocessed_bpe/codes_"$tgt-$src".bpe \
        --vocabulary $data/preprocessed_bpe/vocab.$src \
        --vocabulary-threshold 10 \
        < $data/preprocessed/$split.$src > $data/preprocessed_bpe/$split.$src
    subword-nmt apply-bpe \
        --codes $data/preprocessed_bpe/codes_"$tgt-$src".bpe \
        --vocabulary $data/preprocessed_bpe/vocab.$tgt \
        --vocabulary-threshold 10 \
        < $data/preprocessed/$split.$tgt > $data/preprocessed_bpe/$split.$tgt
done

echo "BPE done!"

# create new directory with BPE-data ready for model
mkdir -p $data/prepared_bpe

# preprocess all files for model training (adapted from preprocess_data.sh)
python preprocess.py --target-lang $tgt --source-lang $src --dest-dir $data/prepared_bpe/ --train-prefix $data/preprocessed_bpe/train --valid-prefix $data/preprocessed_bpe/valid --test-prefix $data/preprocessed_bpe/test --tiny-train-prefix $data/preprocessed_bpe/tiny_train --threshold-src 1 --threshold-tgt 1 --num-words-src 4000 --num-words-tgt 4000

echo "Preprocessing done!"
