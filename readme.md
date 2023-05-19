# Problem statement
The task is to design a neural network that can classify small squared black&white image (VIN character boxes) with single handwritten character on it. 

# Data Overview
 This task was solved by leveraging __EMNIST Balanced__ dataset. The dataset consists of 131,600 characters and 47 classes. What makes the __EMNIST Balanced__ dataset unique is that it ensures a balanced number of samples for each class. This means that each character class has the same number of samples, reducing the likelihood of bias in training the neural network.

## Data Preprocessing
The training dataset was preprocessed to match the conditions of the problem statement.

Since VIN code is a combination of Latin capital letters (A-Z) with exception of "Q", "O" and "I" and digits (0-9), the data corresponding to the lowercase letters and letters "Q", "O" and "I" was removed from the dadaset. 

# Model Architecture Selection

A typical CNN design begins with feature extraction and finishes with classification. Feature extraction is performed by alternating convolution layers with subsambling layers. Classification is performed with dense layers followed by a final softmax layer.

## Number of convolution-subsambling pairs.

We've compared model performance based on number of convolution-subsambling pairs (__n_layers__). There were 3 values ​​of __n_layers__ were considered: 1, 2 and 3.

- 784 - __[24C5-P2]__ - 256 - 36
- 784 - __[24C5-P2]__ - __[48C5-P2]__ - 256 - 36
- 784 - __[24C5-P2]__ - __[48C5-P2]__ - __[64C5-P2]__ - 256 - 36

The results of the experiment are shown in the graph below.

![stats1](/assets/stats1.png)

From the above experiment, it seems that 3 pairs of convolution-subsambling is slightly better than 2 pairs. However for efficiency, the improvement doesn't warrant the additional computional cost, so it was decided to use __n_layers__ = 2.

## Number of feature maps

We've compared model performance based on number of feature maps in the fitst layer (__n_maps__). 

- 784 - [__8__ C5-P2] - [__16__ C5-P2] - 256 - 36
- 784 - [__16__ C5-P2] - [__32__ C5-P2] - 256 - 36
- 784 - [__24__ C5-P2] - [__48__ C5-P2] - 256 - 36
- 784 - [__32__ C5-P2] - [__64__ C5-P2] - 256 - 36
- 784 - [__48__ C5-P2] - [__96__ C5-P2] - 256 - 36
- 784 - [__64__ C5-P2] - [__128__ C5-P2] - 256 - 36

The results of the experiment are shown in the graph below.

![stats2](/assets/stats2.png)

From the above experiment, it seems that __n_maps__ = 48 gives the most optimal results.

## Number of neurons in the dense layer.

We've compared model performance based on number of neurons in the first dense layer (__n_neurons__).

- 784 - [48C5-P2] - [96C5-P2] - __0__ - 36
- 784 - [48C5-P2] - [96C5-P2] - __32__ - 36
- 784 - [48C5-P2] - [96C5-P2] - __64__ - 36
- 784 - [48C5-P2] - [96C5-P2] - __128__ - 36
- 784 - [48C5-P2] - [96C5-P2] - __256__ - 36
- 784 - [48C5-P2] - [96C5-P2] - __512__ - 36
  
The results of the experiment are shown in the graph below.

![stats3](/assets/stats3.png)

From the above experiment, we can conclude that the performance of the model does not strongly depend on the number of neurons in the layer. It seems that __n_neurons__ = 128 is the most optimal.

## Dropout rate 

We've compared model performance based on dropout rate (__rate__). 

- 0%, 10%, 20%, 30%, 40%, 50%, 60%, or 70%

The results of the experiment are shown in the graph below.

![stats4](/assets/stats4.png)

From the above experiment, it seems that __rate__ = 0.2 is the most optimal.

The result model architecture is:

784 - [48C5-P2] - [96C5-P2] - 256 - 36

# Model training

The model was trained usig __Adam__ optimizer and __Categorical crossentropy__ loss function. The __Adam__ optimizer is a popular choice in deep learning due to its adaptive learning rates and momentum, which helps the model converge efficiently during training.

![training](/assets/training.png)

The resulting accuracy of the model on the test sample is 93.5%. 

We built a confusion matrix to determine which classes are misclassified more often.

![matrix](/assets/matrix.png)

We can see that the model generally performs quite well on test data, with the exception of a pair 1: "L" which can be quite confusing in handwritten form.

# User Guide

## Executing with requirements.txt

1. Create vertual environment

    python3.9 -m venv venv

2. Activate the environment

    source venv/bin/activate
    
3. install dependencies from requirements.txt 

    pip3 install -r requirements.txt

4. run inference.py by specifing flag "--input" and path to the data folder.

    python3 inference.py --input "folder with images"

## Output example

![output](/assets/output.png)