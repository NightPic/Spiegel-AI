import cv2
import dlib
import numpy as np
import threading
import time

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
    if not face_descriptors:
        return None
    distances = np.linalg.norm(np.array(face_descriptors) - face_descriptor, axis=1)
    min_distance = np.min(distances)
    if min_distance < 0.6:
        index = np.argmin(distances)
        return labels[index]
    else:
        return None

frame_buffer = None
frame_lock = threading.Lock()
shutdown_event = threading.Event()

def capture_thread(cap):
    global frame_buffer
    while not shutdown_event.is_set():
        ret, frame = cap.read()
        if not ret:
            break
        with frame_lock:
            frame_buffer = frame

def process_thread():
    global frame_buffer, label_index  # Declare label_index as global
    frame_skip = 10
    frame_count = 0
    while not shutdown_event.is_set():
        with frame_lock:
            frame = frame_buffer
        if frame is None:
            continue

        frame_count += 1
        if frame_count % frame_skip != 0:
            continue

        small_frame = cv2.resize(frame, (0, 0), fx=0.5, fy=0.5)
        gray = cv2.cvtColor(small_frame, cv2.COLOR_BGR2GRAY)
        faces = detector(gray)

        for face in faces:
            x1, y1, x2, y2 = (int(face.left() * 2), int(face.top() * 2), int(face.right() * 2), int(face.bottom() * 2))
            cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 2)
            scaled_face = dlib.rectangle(left=face.left(), top=face.top(), right=face.right(), bottom=face.bottom())
            landmarks = predictor(gray, scaled_face)
            face_descriptor = np.array(facerec.compute_face_descriptor(small_frame, landmarks))

            label = recognize_face(face_descriptor)
            if label is None:
                label = f"Person {label_index}"
                add_new_face(face_descriptor, label)
                label_index += 1  # Correctly incrementing the global variable

            cv2.putText(frame, label, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)

        cv2.imshow("Frame", frame)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            shutdown_event.set()


cap = cv2.VideoCapture(0)

capture_thread = threading.Thread(target=capture_thread, args=(cap,))
process_thread = threading.Thread(target=process_thread)

capture_thread.start()
process_thread.start()

capture_thread.join()
process_thread.join()

cap.release()
cv2.destroyAllWindows()
