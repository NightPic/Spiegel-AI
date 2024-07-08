import cv2
import dlib
import numpy as np
import os
import time  # Import time module

from face_utils import save_face_data, load_face_data, add_new_face, recognize_face
from profile_utils import output_detected_profile, load_profiles
from websocket_utils import initiate_websocket_connection, send_profiles

# Start WebSocket connection
initiate_websocket_connection()

# Load models
detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor('shape_predictor_68_face_landmarks.dat')
facerec = dlib.face_recognition_model_v1('dlib_face_recognition_resnet_model_v1.dat')

# Initialize data storage for face descriptors and corresponding labels
face_descriptors = []
labels = []
label_index = 0
last_recognized_label = None

cap = cv2.VideoCapture(0)
load_face_data()

last_analysis_time = time.time()  # Initialize the last analysis time

while True:
    ret, frame = cap.read()
    if not ret:
        break

    current_time = time.time()
    if (current_time - last_analysis_time) * 1000 >= 100:  # Check if 100ms have passed
        last_analysis_time = current_time

        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        faces = detector(gray)

        for face in faces:
            x1 = face.left()
            y1 = face.top()
            x2 = face.right()
            y2 = face.bottom()
            landmarks = predictor(gray, face)
            face_descriptor = facerec.compute_face_descriptor(frame, landmarks)
            face_descriptor = np.array(face_descriptor)

            label = recognize_face(face_descriptor)
            if label is None:
                label = f"Person {label_index}"
                add_new_face(face_descriptor, label)
                label_index += 1

            profiles = load_profiles()
            output_detected_profile(profiles, label, send_profiles)
            last_recognized_label = label

            # Display the label
            cv2.putText(frame, label, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)

            # Draw the landmarks
            for n in range(0, 68):
                x = landmarks.part(n).x
                y = landmarks.part(n).y
                cv2.circle(frame, (x, y), 1, (255, 0, 0), -1)

            break  # Only process the first detected face

    cv2.imshow("Frame", frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
