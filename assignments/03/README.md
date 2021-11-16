# Assignment 3: Improving Low-Resource NMT

In this assignment we use fr-en data from the Tatoeba
corpus and investigate methods for improving low-resource NMT.

Your task is to experiment with techniques for improving
low-resource NMT systems.

## Baseline

The data used to train the baseline model was prepared using
the script `preprocess_data.sh`.
This may be useful if you choose to apply subword
segmentation or a data augmentation method.

## BPE dropout

Scripts and data have been added for experimenting with BPE dropout,
using the original BPE implementation by [Sennrich et al](https://github.com/rsennrich/subword-nmt)

Note: BPE dropout is applied to the training corpus before the training begins,
which is different from the approach proposed by [Provilkov et al](https://github.com/VProv/BPE-Dropout), where they re-segment the sentence again in each training batch.
