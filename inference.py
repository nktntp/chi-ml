import sys
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
import tensorflow as tf
from tensorflow import keras

def validate_arguments():
    if len(sys.argv) != 3:
        raise ValueError("Exactly two arguments are required.")
    
    first_arg = sys.argv[1]
    second_arg = sys.argv[2]
    
    if first_arg != "--input":
        raise ValueError("First argument must be '--input'.")
    
    if not second_arg:
        raise ValueError("Second argument cannot be empty.")


validate_arguments()

LABELS = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 
          'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
          'a', 'b', 'd', 'e', 'f', 'g', 'h', 'n', 'q', 'r', 't']

model = keras.models.load_model('model.h5')
image_folder = sys.argv[2]

for filename in os.listdir(image_folder):
    if filename.endswith('.jpg') or filename.endswith('.png'):

        image_path = os.path.join(image_folder, filename)
        image = tf.io.read_file(image_path)
        image = tf.cond(tf.io.is_jpeg(image),
                        lambda: tf.io.decode_jpeg(image, channels=1),
                        lambda: tf.io.decode_png(image, channels=1))
        image = tf.image.resize(image, [28, 28], antialias=True)
        image = tf.image.convert_image_dtype(image, tf.float32)
        image = tf.expand_dims(image, axis=0)

        predictions = model.predict(image, verbose=0)
        predicted_class = tf.argmax(predictions, axis=1).numpy().item()
        print(f'{ord(LABELS[predicted_class]):03}, {image_path}')

    