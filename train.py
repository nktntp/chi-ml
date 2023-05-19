import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
import tensorflow as tf
import tensorflow_datasets as tfds
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten, Conv2D, MaxPool2D


(ds_train, ds_test), ds_info = tfds.load("emnist/balanced", split=["train", "test"], shuffle_files=True, as_supervised=True, with_info=True)


def remove_lowercase(dataset):
    for i in range(36, 47):
        dataset = dataset.filter(lambda x, y: tf.not_equal(y, i))
    dataset = dataset.filter(lambda x, y: tf.not_equal(y, 18)) # I
    dataset = dataset.filter(lambda x, y: tf.not_equal(y, 24)) # O
    dataset = dataset.filter(lambda x, y: tf.not_equal(y, 26)) # Q
    return dataset

ds_train = remove_lowercase(ds_train)
ds_test = remove_lowercase(ds_test)

AUTO = tf.data.experimental.AUTOTUNE
BATCH_SIZE = 256
NUMBER_OF_EPOCHS = 10

LABELS = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 
          'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']

def transpose_and_flatten(image, label):
    image = tf.image.convert_image_dtype(image, dtype=tf.float32)
    image = tf.transpose(image, [1,0,2])
    label = tf.one_hot(label, depth=len(LABELS))
    return image, label

trainloader = (
    ds_train
    .shuffle(1024)
    .map(transpose_and_flatten, num_parallel_calls=AUTO)
    .batch(BATCH_SIZE)
    .prefetch(AUTO)
)

testloader = (
    ds_test
    .map(transpose_and_flatten, num_parallel_calls=AUTO)
    .batch(BATCH_SIZE)
    .prefetch(AUTO)
)

model = Sequential()
model.add(Conv2D(24,kernel_size=5, padding='same', activation='relu', input_shape=(28, 28 ,1)))
model.add(MaxPool2D())
model.add(Conv2D(48,kernel_size=5, padding='same', activation='relu'))
model.add(MaxPool2D())
model.add(Conv2D(64,kernel_size=5, padding='same', activation='relu'))
model.add(MaxPool2D(padding='same'))
model.add(Flatten())
model.add(Dense(256, activation='relu'))
model.add(Dense(36, activation='softmax'))

model.compile(optimizer="adam", loss="categorical_crossentropy", metrics=["accuracy"])
history = model.fit(trainloader, epochs=NUMBER_OF_EPOCHS, validation_data=testloader)

model.save('model.h5')