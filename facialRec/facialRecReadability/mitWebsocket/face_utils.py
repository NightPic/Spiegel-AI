import numpy as np
import os

face_descriptors = []
labels = []
label_index = 0

def save_face_data():
    np.savez('face_data.npz', face_descriptors=face_descriptors, labels=labels)

def load_face_data():
    global face_descriptors, labels, label_index
    if os.path.exists('face_data.npz'):
        data = np.load('face_data.npz', allow_pickle=True)
        face_descriptors = data['face_descriptors'].tolist()
        labels = data['labels'].tolist()
        label_index = len(labels)

def add_new_face(face_descriptor, label):
    face_descriptors.append(face_descriptor)
    labels.append(label)
    save_face_data()

def recognize_face(face_descriptor):
    if len(face_descriptors) == 0:
        return None
    distances = np.linalg.norm(np.array(face_descriptors) - face_descriptor, axis=1)
    min_distance = np.min(distances)
    if min_distance < 0.6:  # Threshold for recognizing a face can be tuned (euklidischer Abstand)
        index = np.argmin(distances)
        return labels[index]
    else:
        return None
