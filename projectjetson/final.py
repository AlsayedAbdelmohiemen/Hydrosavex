import cv2
import firebase_admin
from firebase_admin import credentials, firestore
import threading
import time
import warnings
from ultralytics import YOLO
from collections import defaultdict
import numpy as np
from google.cloud.firestore_v1 import SERVER_TIMESTAMP
import argparse

# Ignore warnings
warnings.filterwarnings("ignore")

def initialize_yolo():
    model = YOLO(r"E:\Flutter\drowning-detection-main\projectjetson\best.pt")
    return model

def start_video_capture(video_source):
    if video_source == '0':
        cap = cv2.VideoCapture(0)  # Open webcam
    else:
        cap = cv2.VideoCapture(video_source)  # Open video file
    if not cap.isOpened():
        print("Error: Could not open video.")
        exit()
    return cap

# Parse command-line arguments
def parse_args():
    parser = argparse.ArgumentParser(description="Drowning Detection Application")
    parser.add_argument('--conf', type=float, default=0.5, help="Confidence threshold for YOLO detection (default: 0.45)")
    parser.add_argument('--video', type=str, default='0', help="Path to the video file (use '0' for webcam, default: None)")
    parser.add_argument('--threshold', type=int, default=14, help="Threshold for object detection (default: 5)")
    return parser.parse_args()

# Initialize Firebase Admin SDK
def initialize_firebase():
    cred = credentials.Certificate("drowning-detection-main-firebase-adminsdk-jr5nn-21062399ce.json")
    firebase_admin.initialize_app(cred)
    db = firestore.client()
    return db

# Drowning detector class
class DrowningDetector:
    def __init__(self, threshold):  # Corrected __init__ method
        self.threshold_for_drowning = threshold  # Threshold in seconds
        self.object_tracker = defaultdict(lambda: {
            "drowning_count": 0,
            "normal_count": 0,
            "last_drowning_time": None,
            "last_checked_time": None,
            "alert_sent": False,
        })


    def calculateDrowning(self, object_id, class_classified, current_time):
        if class_classified == 'drowning':
            if self.object_tracker[object_id]["last_drowning_time"] is None:
                self.object_tracker[object_id]["last_drowning_time"] = current_time

            if self.object_tracker[object_id]["last_checked_time"] is None or current_time - self.object_tracker[object_id]["last_checked_time"] >= 1:
                self.object_tracker[object_id]["drowning_count"] += 1
                self.object_tracker[object_id]["last_checked_time"] = current_time
                elapsed_time = current_time - self.object_tracker[object_id]["last_drowning_time"]

                if elapsed_time >= self.threshold_for_drowning and not self.object_tracker[object_id]["alert_sent"]:
                    self.alertDrowning(object_id)
                    self.object_tracker[object_id]["alert_sent"] = True
        else:
            self.reset_object_state(object_id)

    def reset_object_state(self, object_id):
        self.object_tracker[object_id].update({
            "drowning_count": 0,
            "normal_count": 0,
            "last_drowning_time": None,
            "last_checked_time": None,
            "alert_sent": False,
        })

    def alertDrowning(self, object_id):
        thread = threading.Thread(target=self._send_alert_to_firestore, args=(object_id,), daemon=True)
        thread.start()

    def _send_alert_to_firestore(self, object_id):
        organizationId = "73311724355540472"
        db = firestore.client()
        text = f"Alert: Possible drowning detected for object ID {object_id}"
        db.collection("lifeguardnotifications").add({
            "orgID": organizationId,
            "sent": False,
            "text": text,
            "date": SERVER_TIMESTAMP
        })

# Process frame for detection and tracking
def process_frame(frame, model, drowning_detector, current_time):
    results = model.track(frame, conf=0.5, persist=True, iou=0.5, tracker="botsort.yaml")

    for result in results:
        boxes = result.boxes.xyxy.cpu().numpy()
        confidences = result.boxes.conf.cpu().numpy()
        class_ids = result.boxes.cls.cpu().numpy()
        ids = result.boxes.id

        if ids is None:
            ids = np.arange(len(boxes))  # Assign temporary IDs if None
        else:
            ids = ids.cpu().numpy()

        for i, box in enumerate(boxes):
            if confidences[i] > 0.5:
                x1, y1, x2, y2 = box
                label = class_ids[i]
                object_id = ids[i]
                class_name = "drowning" if label == 0 else "normal"  # Assuming class 0 is drowning

                # Define colors for "normal" and "drowning"
                if class_name == "drowning":
                    color = (0, 0, 255)  # Red for drowning
                else:
                    color = (0, 255, 0)  # Green for normal

                drowning_detector.calculateDrowning(object_id, class_name, current_time)
                drowning_count = drowning_detector.object_tracker[object_id]["drowning_count"]

                # Draw bounding box with the appropriate color
                cv2.rectangle(frame, (int(x1), int(y1)), (int(x2), int(y2)), color, 2)

                # Annotate with object ID, classification, and drowning count
                label_text = f"ID: {int(object_id)}, {class_name.capitalize()}: {drowning_count}"
                cv2.putText(frame, label_text, (int(x1), int(y1) - 10),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.8, color, 2)

    return frame


# Main function
def main():
    args = parse_args()
    db = initialize_firebase()
    model = initialize_yolo()
    drowning_detector = DrowningDetector(threshold=args.threshold)
    cap = start_video_capture(args.video)
    # Create the window before resizing it
    cv2.namedWindow('Drowning Detection - YOLO Tracking', cv2.WINDOW_NORMAL)
    target_fps = 100  # Desired frames per second
    frame_interval = 1.0 / target_fps  # Time interval between frames
    last_frame_time = 0

    while True:
        ret, frame = cap.read()
        current_time = time.time()
        if current_time - last_frame_time >= frame_interval:
            last_frame_time = current_time
            if not ret:
                print("Error: Failed to read frame.")
                break
            # Get the dimensions of the frame
            height, width = frame.shape[:2]

            # Resize the window to match the frame size
            cv2.resizeWindow('Drowning Detection - YOLO Tracking', width, height)
            frame = process_frame(frame, model, drowning_detector, current_time)
            cv2.imshow('Drowning Detection - YOLO Tracking', frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()
