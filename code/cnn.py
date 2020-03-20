import numpy as np
import tensorflow as tf
import os
import random
from tensorflow.keras import datasets, layers, models
import matplotlib.pyplot as plt
import pdb
import scipy.io
from tensorflow.keras.models import load_model
import sys
from sklearn.metrics import classification_report
"""
Part of the code shown here was extracted from the Tensorflow tutorials in the official page
"""

def extract_samples(files_path, test):
	filenames = os.listdir(files_path)
	all = {}
	counter = [0,0,0]
	for f in filenames:
		nam, ext = os.path.splitext(f)	
		if(ext == '.mat' and nam[0] in ['0','1','2']):
			if(not test and counter[int(nam[0])] >= 150):
				continue
			all[nam] = scipy.io.loadmat(files_path + f)['cc'][0][0:1600]
			counter[int(nam[0])] += 1

	return all
	
if(int(sys.argv[1]) == 0):

	x_train = []
	y_train = []
	x_val = []
	y_val = []
	x_test = []
	y_test = []
	count = 0



	all = extract_samples('/home/kiototeko/tareas/iotsec/python/samples2/', False)
	test_all = extract_samples('/home/kiototeko/tareas/iotsec/python/samples/', False)


	keys = list(all.keys())
	random.shuffle(keys)
	data = np.array(list(all.values()))
	std = np.std(data)
	mean = np.mean(data)


	for i,k in enumerate(keys):
		if(i < int(len(keys)*0.7)):
			x_train.append((all[k]-mean)/std)
			y_train.append(int(k[0]))
		else:
			x_val.append((all[k]-mean)/std)
			y_val.append(int(k[0]))

	test_keys = list(test_all.keys())
	test_data = np.array(list(test_all.values()))
	test_std = np.std(test_data)
	test_mean = np.mean(test_data)

	for i,k in enumerate(test_keys):
		x_test.append((test_all[k]-test_mean)/test_std)
		y_test.append(int(k[0]))

	x_train = np.array(x_train)
	x_train = np.concatenate(x_train).reshape(-1,len(x_train[0]),1)
	y_train = np.array(y_train) #.reshape(-1,len(y_train[0]),1)
	x_val = np.array(x_val).reshape(-1,len(x_val[0]),1)
	y_val = np.array(y_val) #.reshape(-1,len(y_val[0]),1)

	x_test = np.array(x_test).reshape(-1, len(x_test[0]),1)
	y_test = np.array(y_test)

	model = models.Sequential()
	model.add(layers.Conv1D(16,24, activation='relu', input_shape=(len(x_train[0]),1)))
	model.add(layers.Conv1D(32, 24, activation='relu'))
	model.add(layers.MaxPooling1D(4, strides=2))
	model.add(layers.Conv1D(64, 24, activation='relu'))
	model.add(layers.Conv1D(64, 24, activation='relu'))
	model.add(layers.MaxPooling1D(4, strides=2))
	model.add(layers.Conv1D(64, 24, activation='relu'))
	model.add(layers.Conv1D(64, 24, activation='relu'))
	model.add(layers.MaxPooling1D(4, strides=2))
	model.add(layers.Flatten())
	model.add(layers.Dense(512, activation='relu'))
	model.add(layers.Dropout(0.9))
	model.add(layers.Dense(3, activation='softmax'))


	opt = tf.keras.optimizers.SGD(learning_rate=0.01, clipvalue=0.1)


	model.compile(optimizer= opt, #'adadelta', #opt,
		      loss='sparse_categorical_crossentropy',
		      metrics=['accuracy'])


	epochs = 150

	history = model.fit(x=x_train, y=y_train, batch_size=32, steps_per_epoch=len(x_train)/32, validation_steps=len(x_val) / 32,
		            epochs=epochs, validation_data=(x_val, y_val))



	plt.plot(history.history['loss'], label='loss')
	plt.plot(history.history['val_loss'], label = 'val_loss')
	plt.xlabel('Epoch')
	plt.ylabel('Loss')
	plt.ylim([0, 0.5])
	plt.legend(loc='lower right')

	test_loss, test_acc = model.evaluate(x_test, y_test, verbose=2)
	model.save('my_model.h5')

elif(int(sys.argv[1]) == 1):
	model = load_model('my_model.h5')
	x_test = []
	y_test = []
	test_all = extract_samples(sys.argv[2] + '/', True)
	test_keys = list(test_all.keys())
	test_data = np.array(list(test_all.values()))
	test_std = np.std(test_data)
	test_mean = np.mean(test_data)
	for i,k in enumerate(test_keys):
		x_test.append((test_all[k]-test_mean)/test_std)
		y_test.append(int(k[0]))
	x_test = np.array(x_test).reshape(-1, len(x_test[0]),1)
	y_test = np.array(y_test)

	predictions = model.predict(x_test)
	predictions_bool = np.argmax(predictions, axis=1)
	#print(classification_report(y_test, predictions_bool))
	test_loss, test_acc = model.evaluate(x_test, y_test, verbose=2)

	
