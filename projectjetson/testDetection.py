import joblib
import cv2
import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np
import albumentations
from google.cloud.firestore_v1 import SERVER_TIMESTAMP
from torch.utils.data import Dataset, DataLoader
from PIL import Image
import time
import firebase_admin
from firebase_admin import credentials, firestore

import warnings
import threading
import os

warnings.filterwarnings("ignore")

# Initialize Firebase Admin SDK
cred = credentials.Certificate("drowning-detection-main-firebase-adminsdk-jr5nn-21062399ce.json")
firebase_admin.initialize_app(cred)

# Load the binarized labels file
try:
    lb = joblib.load('lb.pkl')
    print("Label binarizer loaded successfully.")
except Exception as e:
    print(f"Error loading lb.pkl: {e}")
    exit(1)

# Define the CustomCNN model
class CustomCNN(nn.Module):
    def __init__(self):
        super(CustomCNN, self).__init__()
        self.conv1 = nn.Conv2d(3, 16, 5)
        self.conv2 = nn.Conv2d(16, 32, 5)
        self.conv3 = nn.Conv2d(32, 64, 3)
        self.conv4 = nn.Conv2d(64, 128, 5)
        self.fc1 = nn.Linear(128, 256)
        self.fc2 = nn.Linear(256, len(lb.classes_))
        self.pool = nn.MaxPool2d(2, 2)

    def forward(self, x):
        x = self.pool(F.relu(self.conv1(x)))
        x = self.pool(F.relu(self.conv2(x)))
        x = self.pool(F.relu(self.conv3(x)))
        x = self.pool(F.relu(self.conv4(x)))
        bs, _, _, _ = x.shape
        x = F.adaptive_avg_pool2d(x, 1).reshape(bs, -1)
        x = F.relu(self.fc1(x))
        x = self.fc2(x)
        return x

# Load the model and state_dict
print('Loading model and label binarizer...')
model = CustomCNN()
print('Model Loaded...')

# Load the model state_dict with error handling
try:
    model.load_state_dict(torch.load('model.pth', map_location=torch.device('cpu')))
    print('Loaded model state_dict...')
except RuntimeError as e:
    print(f"Error loading model: {e}")
    exit(1)

# Define augmentations
aug = albumentations.Compose([
    albumentations.Resize(224, 224),
])

class Detection:
    def __init__(self):
        self.drowning = 0
        self.ThersholdForDrowning = 20
        self.countDrowning = 0
        self.countNormal = 0
        self.alarm_thread = None
        self.alarm_active = False

    def detectDrowning(self, video_path):
        # Check if the video file exists
        if not os.path.exists(video_path):
            print(f"Video file not found at: {video_path}")
            return

        cap = cv2.VideoCapture(video_path)

        # Check if the video is opened successfully
        if not cap.isOpened():
            print('Error while trying to read video. Please check the path or file format.')
            return

        # Get FPS and set a default value if FPS is 0
        fps = cap.get(cv2.CAP_PROP_FPS)
        if fps == 0:
            fps = 30  # Default FPS value
        delay = 1 / fps  # Calculate the delay between frames based on FPS

        classification = "normal"
        frame_count = 0

        # Create a directory to save the frames
        if not os.path.exists('output_frames'):
            os.makedirs('output_frames')

        while cap.isOpened():
            start_time = time.time()  # Start time of the loop
            ret, frame = cap.read()
            if ret:
                frame_count += 1

                # Only process every 10th frame
                if frame_count % 10 == 0:
                    model.eval()
                    with torch.no_grad():
                        pil_image = Image.fromarray(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))
                        pil_image = aug(image=np.array(pil_image))['image']
                        pil_image = np.transpose(pil_image, (2, 0, 1)).astype(np.float32)
                        pil_image = torch.tensor(pil_image, dtype=torch.float)
                        pil_image = pil_image.unsqueeze(0)
                        outputs = model(pil_image)
                        _, preds = torch.max(outputs.data, 1)
                        self.calculateDrowning(lb.classes_[preds])

                    classification = lb.classes_[preds]

                    # Print classification result and FPS to terminal
                    print("Frame Classified as: ", classification)
                    print("FPS: ", int(1.0 / (time.time() - start_time)))

                # Save the frame as an image file
                cv2.imwrite(f'output_frames/frame_{frame_count}.jpg', frame)

                # Ensure the video maintains its original speed
                time.sleep(max(0, delay - (time.time() - start_time)))

            else:
                break

        cap.release()

        # Stop the alarm when video processing is done
        self.stopAlarm()

        print("classified as normal:", self.countNormal)
        print("classified as drowning: ", self.countDrowning)
        return 0

    def calculateDrowning(self, classClassified):
        if classClassified == 'drowning':
            self.drowning += 1
            if self.drowning >= self.ThersholdForDrowning:
                if not self.alarm_active:
                    self.startAlarm()
                self.alertDrowning()
                self.drowning = 0
            self.countDrowning += 1
        else:
            self.countNormal += 1
            self.drowning = 0
            if self.alarm_active:
                self.stopAlarm()

    def startAlarm(self):
        self.alarm_active = True
        self.alarm_thread = threading.Thread(target=self.playAlarm, daemon=True)
        self.alarm_thread.start()

    def stopAlarm(self):
        self.alarm_active = False
        if self.alarm_thread is not None:
            self.alarm_thread.join()

    def playAlarm(self):
        while self.alarm_active:
            # playsound('alarm.mp3')
            time.sleep(3)

    def alertDrowning(self):
        organizationId = "73311724355540472"
        sent = False
        text = "drowning alert"
        db = firestore.client()

        collectionBane = db.collection("lifeguardnotifications").add({
            "orgID": organizationId,
            "sent": sent,
            "text": text,
            "date": SERVER_TIMESTAMP
        })

# Path to video file


# Instantiate Detection class and run detection
d = Detection()
d.detectDrowning('E:/Flutter/drowning-detection-main/projectjetson/Videos/1.mp4')