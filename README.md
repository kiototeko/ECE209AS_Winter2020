# Guarding against Screen Content Detection via Remote Acoustic Side Channels

## Abstract
On the research paper with the title of **Synesthesia: Detecting Screen Content via Remote Acoustic Side Channels** by Daniel Genkin, Mihir Pattani, Roei Schuster and Eran Tromer, it is shown that subtle acoustic noises emanating from within computer LCD screens can be used to detect the content displayed on those same screens. This sound can be picked up easily by built-in microphones in laptop computers, and with a Convolutional Neural Network (CNN) classifier, one can infer, for example, which websites the victim was browsing.
In this work, we propose a way to counteract this vulnerability, by masking the audible leakage signal with high-pass filtered white noise. We show that by doing this we can reduce down to two thirds the chances of the attacker obtaining informative samples to infer the screen content. We also discover that not all LCD displays emit the same amplitude modulated signals as described on the paper referenced above, so a procedure to deal with these particularities is shown.

### Participants:

* Julian de Gortari Briseno

## About the code

* In *code/SignalExtract* is all the code used for processing the audio samples, from filtering and demodulating the AM signal, to running the chunking algorithm and getting the averaged chunk. *newCosstas.m* is the program used for this, while *snr.m* was used to get the SNR of the sets of samples.

* *code/getWebsites.py* was used to get the audio samples from each website, and later it was also used to play the white noise.

* *code/noise_command.sh* is the Bash command used to produce our high-pass filtered noise.

* *code/cnn.py* is where the CNN model is.
