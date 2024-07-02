import cv2
import face_recognition
import numpy as np

# Load the Haar cascade for face detection
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')

# Initialize data storage for face encodings and corresponding labels
face_encodings = []
labels = []
label_index = 0

def add_new_face(face_encoding, label):
    face_encodings.append(face_encoding)
    labels.append(label)

def recognize_face(face_encoding):
    if len(face_encodings) == 0:
        return None
    distances = face_recognition.face_distance(face_encodings, face_encoding)
    min_distance = np.min(distances)
    if min_distance < 0.6:  # Threshold for recognizing a face can be tuned
        index = np.argmin(distances)
        return labels[index]
    else:
        return None

cap = cv2.VideoCapture(0)

while True:
    ret, frame = cap.read()
    if not ret:
        break

    # Convert the frame to RGB (face_recognition expects RGB)
    rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5, minSize=(30, 30))

    for (x, y, w, h) in faces:
        cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)

        # Extract the face region
        face_region = rgb_frame[y:y + h, x:x + w]

        # Compute face encoding using face_recognition library
        face_encodings_in_frame = face_recognition.face_encodings(rgb_frame, [(y, x + w, y + h, x)])
        if face_encodings_in_frame:
            face_encoding = face_encodings_in_frame[0]

            # Try to recognize the face
            label = recognize_face(face_encoding)
            if label is None:
                label = f"Person {label_index}"
                add_new_face(face_encoding, label)
                label_index += 1

            # Display the label
            cv2.putText(frame, label, (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)

    cv2.imshow("Frame", frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
