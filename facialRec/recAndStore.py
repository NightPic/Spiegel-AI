import cv2
import dlib
import numpy as np

# Load models
detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor('shape_predictor_68_face_landmarks.dat')
facerec = dlib.face_recognition_model_v1('dlib_face_recognition_resnet_model_v1.dat')

# Initialize data storage for face descriptors and corresponding labels
face_descriptors = []
labels = []
label_index = 0

def add_new_face(face_descriptor, label):
    face_descriptors.append(face_descriptor)
    labels.append(label)

def recognize_face(face_descriptor):
    if len(face_descriptors) == 0:
        return None
    distances = np.linalg.norm(np.array(face_descriptors) - face_descriptor, axis=1)
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
            label = f"Person {label_index}"
            add_new_face(face_descriptor, label)
            label_index += 1

        # Display the label
        cv2.putText(frame, label, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)

        # Draw the landmarks
        for n in range(0, 68):
            x = landmarks.part(n).x
            y = landmarks.part(n).y
            cv2.circle(frame, (x, y), 1, (255, 0, 0), -1)

    cv2.imshow("Frame", frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
