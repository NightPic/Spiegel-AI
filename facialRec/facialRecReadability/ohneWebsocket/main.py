import cv2
import dlib
import numpy as np
import os

from face_utils import save_face_data, load_face_data, add_new_face, recognize_face
from profile_utils import output_detected_profile, load_profiles

# Load models
detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor('shape_predictor_68_face_landmarks.dat')
facerec = dlib.face_recognition_model_v1('dlib_face_recognition_resnet_model_v1.dat')

# Initialize data storage for face descriptors and corresponding labels
face_descriptors = []
labels = []
label_index = 0

cap = cv2.VideoCapture(0)
load_face_data()
profiles = load_profiles()

while True:
    ret, frame = cap.read()
    if not ret:
        break

    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    faces = detector(gray)

    for face in faces:
        x1, y1, x2, y2 = face.left(), face.top(), face.right(), face.bottom()
        cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 2)

        # Get the facial landmarks
        landmarks = predictor(gray, face)

        # IMPORTANT: Use the original frame, not the gray frame, for feature extraction
        face_descriptor = np.array(facerec.compute_face_descriptor(frame, landmarks))

        # Try to recognize the face
        label = recognize_face(face_descriptor)
        if label is None:
            label = f"profil{label_index}"
            add_new_face(face_descriptor, label)
            label_index += 1

        # Output the detected profile as JSON and save it
        output_detected_profile(profiles, label)

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
