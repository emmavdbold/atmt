#!usr/bin/env bash

# Script for applying BPE to all data, with BPE dropout for training data
# /preprocessed/ folder should already exist

pwd=`dirname "$(readlink -f "$0")"`
base=$pwd/../..
src=fr
tgt=en
data=$base/data/$tgt-$src/

# change into base directory to ensure paths are valid
cd $base

# create new directory for all bpe-related preprocessing files in dropout setting
mkdir -p $data/preprocessed_bpe_drop

# learn a BPE model on the training data from both languages and create vocabulary files along the way
subword-nmt learn-joint-bpe-and-vocab \
    --input $data/preprocessed/train.$src $data/preprocessed/train.$tgt \
    --write-vocabulary $data/preprocessed_bpe_drop/vocab.$src $data/preprocessed_bpe_drop/vocab.$tgt \
    --output $data/preprocessed_bpe_drop/codes_"$tgt-$src".bpe \
    --symbols 4000 \
    --total-symbols

# apply BPE with dropout to training data
for split in train tiny_train
do
    subword-nmt apply-bpe \
        --codes $data/preprocessed_bpe_drop/codes_"$tgt-$src".bpe \
        --vocabulary $data/preprocessed_bpe_drop/vocab.$src \
        --vocabulary-threshold 10 \
        --dropout 0.1 \
        < $data/preprocessed/$split.$src > $data/preprocessed_bpe_drop/$split.$src
    subword-nmt apply-bpe \
        --codes $data/preprocessed_bpe_drop/codes_"$tgt-$src".bpe \
        --vocabulary $data/preprocessed_bpe_drop/vocab.$tgt \
        --vocabulary-threshold 10 \
        --dropout 0.1 \
        < $data/preprocessed/$split.$tgt > $data/preprocessed_bpe_drop/$split.$tgt
done

# apply BPE without dropout to valid and test data
for split in valid test
do
    subword-nmt apply-bpe \
        --codes $data/preprocessed_bpe_drop/codes_"$tgt-$src".bpe \
        --vocabulary $data/preprocessed_bpe_drop/vocab.$src \
        --vocabulary-threshold 10 \
        < $data/preprocessed/$split.$src > $data/preprocessed_bpe_drop/$split.$src
    subword-nmt apply-bpe \
        --codes $data/preprocessed_bpe_drop/codes_"$tgt-$src".bpe \
        --vocabulary $data/preprocessed_bpe_drop/vocab.$tgt \
        --vocabulary-threshold 10 \
        < $data/preprocessed/$split.$tgt > $data/preprocessed_bpe_drop/$split.$tgt
done

echo "BPE done!"

# preprocess all files for model training (adapted from preprocess_data.sh)
# note: training files with dropout specified
python preprocess.py --target-lang $tgt --source-lang $src --dest-dir $data/prepared_bpe_drop/ --train-prefix $data/preprocessed_bpe_drop/train --valid-prefix $data/preprocessed_bpe_drop/valid --test-prefix $data/preprocessed_bpe_drop/test --tiny-train-prefix $data/preprocessed_bpe_drop/tiny_train --threshold-src 1 --threshold-tgt 1 --num-words-src 4000 --num-words-tgt 4000

echo "Preprocessing done!"
