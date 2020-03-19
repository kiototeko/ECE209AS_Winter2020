# ECE209AS_Winter2020

## Abstract
On the research paper with the title of "Synesthesia: Detecting Screen Content via Remote Acoustic Side Channels" by Daniel Genkin, Mihir Pattani, Roei Schuster and Eran Tromer, it is shown that subtle acoustic noises emanating from within computer LCD screens can be used to detect the content displayed on those same screens. This sound can be picked up easily by the microphone built into the screens, and with a Convolutional Neural Network (CNN) classifier, one can infer, for example, which website the victim was browsing.
In this work, we propose a way to counteract this vulnerability, specifically, by masking with band limited white noise the frequency range where the audible leakage is produced.

Participants:

* Julian de Gortari Briseno

## Introduction

Previous work demonstrated that it is not only possible to capture electromagnetic signals that emanate from computer screens and make a good inference of what the screen is displaying [1], but that by recording the sound made by the screen, you can also make a good guess. This isn’t only limited to CRT screens [2], as LCD screens have been shown to also have the same information leakage [3]. The information that is filtrated can only be obtained from a limited range of frequencies that happen to be in practically the upper limit of the human audible range (~20 kHz). The attacker only needs to get access either to the victim’s computer internal microphone, to a close-by smartphone’s microphone, or he can even extract the desired audio range by recording the output audio of a webcam call to the victim. As the relationship between the sound produced by the LCD screen's power supply and the colors represented in each of the pixel lines displayed on screen is a very complex one, a CNN model trained by a set of audio samples related with specific graphic displays is needed to make the inferences.
A countermeasure is proposed here in order to prevent an attacker from obtaining sensitive information. The defense mechanism consists of masking the sound made by the screen using band limited white noise, trying to ensure also that the noise isn’t heard by the user so that it doesn't become a nuisance. We only focus on the case of the attacker having direct access to the victim’s computer internal microphone, as this is the most extreme case that could happen, and the insights gained here would surely apply to the other situations. The original work we are basing on deals with website distinguishing, on-screen keyboard snooping and text extraction, but in this work we only focus on the first one, website distinguishing.

## System specifications

## Overview

The first phase in this project was dedicated to the replication of the experiment done in the original paper in order to get a functional classifier with which to get predictions about the websites visited in a certain time, given a set of audio samples. For this we first needed to discover the frequency range where the leakage signal appeared, extract the signal and process it with a special algorithm so that at the end, a representative trace a lot smaller than the entire signal recorded could be used as a training input for the CNN model. Afterwards, it was only a matter of repeating the process but with audio samples containing different amounts of noise.

## Obtaining samples

5-second audio samples were obtained from a set of 3 websites by using the Selenium module in python, which automates the action of web browsers, in this case making the web browser iterate between each one of the websites. 1200 samples were obtained in total for training by recording audio when each website was displayed, and 300 samples were obtained for testing. 50 samples were used for each level of noise tested. The audio samples were obtained with a sample rate of 96kHz and stored in a signed 32 bit WAVE file format (in the original experiment they recorded with a sample rate of 192 kHz). The audio recordings were made inside a wooden closet in order to prevent perturbation from environmental noise.

## Extracting the signal

Using the sound processing program, Sound eXchange (SoX), a spectrogram was created for several of the audio samples obtained in order to get a sense of where the leakage signal could be found. The original experiment found that this signal was modulated in amplitude and proceeded to demodulate it, but in our experiments we found that the modulated signal was missing its carrier. An example spectrogram is shown next, the signal of interest being on the range of 20 kHz and 28 kHz:

The signal was extracted using a band-pass filter around the range of 18 kHz and 30 kHz, and because of the nature of our it, a Costas Loop was emulated using a MatLab code obtained from [4], based on Hilbert transformations, so that we could input our filtered audio samples and obtain the correct demodulated signal.

## Processing the signal

Computer screens refresh at a rate of approximately 60 Hz, which means that the image displayed on screen is rendered 60 times in a second, so in this case, obtaining an audio sample of 1/60 s would be enough to capture the relationship between the content on screen and the sound produced, but as we want to get a sample with low noise, it is necessary to average a certain quantity of similar samples. Another problem found in the original experiment has to do with the fact that the refresh rate isn't exactly 60 Hz, it varies with a certain margin, so an algorithm that took that issue into account was proposed as shown next:

This algorithm basically uses Pearson correlation between chunks of different sizes in order to find all those samples that correspond to one period of the refresh rate. The chunks are of different sizes because of the different refresh rates that can appear, and a master chunks is found at first so to serve as our baseline. A threshold T is used to determine if the correlation index is high enough to consider the two chunks related, G is a list with the different sizes a chunk can have. In our case, because our sampling rate was of 96 kHz, recording one refresh rate of 60 Hz would contain a time series of 1600 values. In practice we found that using a size S of 1602 returned the greatest amount of related chunks. We omitted the outlier rejection part as not enough chunks were obtained to consider it useful, and we didn't put a limit on the number of weakly correlated consecutive chunks that were needed to trigger an error. The list of related chunks was averaged at then end and the representative chunk obtained was saved in a file.

## Training the classifier

As there were audio samples were the chunks simply didn't correlate strongly, only a subset was used to train the model, particularly, from the 1200 recorded audio fragments, only 450 could be used in total to ensure there were equal samples for each website (150 for each). We tried to copy the model exactly as it was described in the original paper: a CNN with 6 convolutional layers, a max pooling layer after every two, a fully connected layer of 512 outputs, a dropout layer of 0.9, and a softmax output layer with 3 outputs. The model was trained with SGD, with a 0.01 learning rate, 0.1 gradient clipping and 64 batch size, trained for 150 epochs. For the test set

## Testing the classifier with noisy samples

Band limited white noise was produced using SoX and it was played by the computer's speakers using 6 different sound pressure levels while recording a new rounds of 5-second audio samples, each round containing 50 of these audio samples for each of the three websites.


## Prior Literature

* [Synesthesia: Detecting Screen Content via Remote Acoustic Side Channels](https://www.cs.tau.ac.il/~tromer/synesthesia/synesthesia.pdf)

* [Electromagnetic Eavesdropping Risks of Flat-Panel Displays](https://www.cl.cam.ac.uk/~mgk25/pet2004-fpd.pdf)

* [YELP: Masking Sound-based Opportunistic Attacks in Zero-Effort Deauthentication](https://dl.acm.org/doi/abs/10.1145/3098243.3098259)
