# 🏊‍♂️ HydroSaveX — Smart AI Drowning Detection & Emergency Response System

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Python-%233776AB.svg?style=for-the-badge&logo=python&logoColor=white" alt="Python" />
  <img src="https://img.shields.io/badge/PyTorch-%23EE4C2C.svg?style=for-the-badge&logo=PyTorch&logoColor=white" alt="PyTorch" />
  <img src="https://img.shields.io/badge/YOLOv8-%2300FFFF.svg?style=for-the-badge&logo=yolo&logoColor=black" alt="YOLOv8" />
  <img src="https://img.shields.io/badge/NVIDIA%20Jetson-%2376B900.svg?style=for-the-badge&logo=nvidia&logoColor=white" alt="NVIDIA Jetson" />
  <img src="https://img.shields.io/badge/Firebase-%23FFA611.svg?style=for-the-badge&logo=firebase&logoColor=white" alt="Firebase" />
  <img src="https://img.shields.io/badge/OpenCV-%235C3EE8.svg?style=for-the-badge&logo=opencv&logoColor=white" alt="OpenCV" />
</p>

**HydroSaveX** is an end-to-end intelligent aquatic safety and life-saving platform. It combines **Edge AI Computer Vision on NVIDIA Jetson** with a **real-time role-based Flutter mobile application** backed by **Firebase**. The system continuously monitors swimming pools through overhead and underwater cameras, detects drowning distress in milliseconds, triggers immediate on-site alarms, and dispatches rich emergency alerts to lifeguards and medical responders.

---

## 📸 Application Screenshots Showcase

> [!NOTE]
> High-resolution walkthrough of the mobile application across branding, onboarding, multi-role authentication, real-time rescue dispatch, emergency triage, organization facility management, medical dispatch, home pool monitoring, and interactive first-aid guidance.

### 🌟 Branding & Splash Screen
| ☀️ Splash Screen (Light) | 🌙 Splash Screen (Dark) |
| :---: | :---: |
| ![Splash Screen Light](screenshots/00_splash_screen.png) | ![Splash Screen Dark](screenshots/00_splash_screen_dark.png) |
| *Official HydroSaveX launch screen (Light)* | *Official HydroSaveX launch screen (Dark)* |

### 🚀 Onboarding & Multi-Role Authentication
| 🌟 Onboarding: Welcome | 🚀 Onboarding: Control |
| :---: | :---: |
| ![Welcome Screen](screenshots/01_onboarding_1.png) | ![Control Screen](screenshots/02_onboarding_2.png) |
| *Personalized welcome & system intro* | *Effortless pool facility control* |

| 🔐 Secure Sign In (English) | 🌍 التسجيل والدخول (عربي RTL) |
| :---: | :---: |
| ![Login Screen](screenshots/03_login.png) | ![Login Arabic](screenshots/23_login_arabic.png) |
| *Role-based authentication & session persistence* | *Full Arabic localization & RTL layout support* |

| 👥 Multi-Role Registration | 👤 User Profile Management |
| :---: | :---: |
| ![Sign Up Screen](screenshots/04_signup.png) | ![Profile Screen](screenshots/09_profile.png) |
| *Organization Manager, Lifeguard & Medic registration* | *Account credentials & role verification* |

### 🚨 Lifeguard Emergency Response & Operations
| 🚨 Real-time Drowning Alerts | 📋 Incident Triage & Report |
| :---: | :---: |
| ![Lifeguard Alerts](screenshots/05_lifeguard_alerts.png) | ![Incident Report](screenshots/07_incident_report.png) |
| *Instant push alert with timestamp & AI detection log* | *Triage: Need CPR, Ambulance, or False Alarm* |

| ⚙️ Lifeguard Hub (Dark Theme) | ⏱️ Rescue Stopwatch & Timer |
| :---: | :---: |
| ![Settings Menu](screenshots/06_settings_menu.png) | ![Rescue Timer](screenshots/11_rescue_timer.png) |
| *Quick access to profile, alerts, theme & logs* | *Precise response-time tracking down to seconds* |

| 📊 Daily Incident Reports | 🎨 Lighthouse Day/Night Switcher |
| :---: | :---: |
| ![Daily Reports](screenshots/12_daily_reports_lifeguard.png) | ![Theme Switcher](screenshots/08_theme_screen.png) |
| *Historical logs & incident triage archive* | *Interactive Day/Night switcher with animated art* |

### 🚑 Medical Team Dispatch & Incident Logging
| 🚨 Medical Team Notifications | 📝 Medical Incident Response Report |
| :---: | :---: |
| ![Medic Notifications](screenshots/17_medic_notifications.png) | ![Send Medic Report](screenshots/18_send_medic_report.png) |
| *Emergency dispatch alerts received by medics* | *Submit medical feedback, CPR status & triage notes* |

### 🏢 Facility & Organization Administration
| 🏢 Facility Management Hub | 🔑 Organization Invitation Code |
| :---: | :---: |
| ![Org Settings](screenshots/13_org_settings_menu.png) | ![Organization Code](screenshots/15_organization_code.png) |
| *Organization manager controls & member administration* | *Secure, masked facility access key for staff onboarding* |

| 👥 Staff Directory & Lifeguards | ➕ Provision Staff Member |
| :---: | :---: |
| ![Lifeguard Accounts](screenshots/14_all_lifeguards_accounts.png) | ![Create Member](screenshots/16_create_member.png) |
| *Active organization lifeguard roster* | *Create accounts for lifeguards & medical staff* |

### 🏡 Home Pool Monitoring & Emergency First Aid
| 🔔 Home Pool Alerts & History | ⚙️ Home User Settings Hub |
| :---: | :---: |
| ![Home Notifications](screenshots/19_home_notifications.png) | ![Home Settings Menu](screenshots/20_home_settings_menu.png) |
| *Real-time notifications for private pool owners* | *Quick access to settings, alerts & first-aid guide* |

| 🩹 Drowning First Aid Directory | 🎥 Interactive Video & Step Guidance |
| :---: | :---: |
| ![First Aid Guide](screenshots/21_first_aid_guide.png) | ![First Aid Video](screenshots/22_first_aid_detail_video.png) |
| *Emergency CPR, chest compression & rescue breathing index* | *Step-by-step instructions with integrated emergency video* |

### 💬 Diagnostics & Feedback
| 💬 In-App Diagnostics & Feedback |
| :---: |
| ![Wiredash Feedback](screenshots/10_feedback_wiredash.png) |
| *Integrated Wiredash support & field issue reporting* |

---

## 🏗️ System Architecture & Workflow

```mermaid
graph TD
    A[📹 Poolside CCTV / RTSP Cameras] -->|Real-time Video Feed| B[⚡ NVIDIA Jetson Edge AI]
    B -->|Object Detection & Tracking| C[🎯 YOLOv8 Human Detector]
    B -->|Distress Classification| D[🧠 Custom PyTorch CNN]
    C & D -->|Drowning Distress Detected| E[🚨 On-site Siren / Alarm]
    C & D -->|Incident Data & Coords| F[(🔥 Firebase Firestore)]
    F -->|Instant Push Notification| G[☁️ Firebase Cloud Messaging - FCM]
    G -->|High-Priority Alert & Audio| H[📱 HydroSaveX Mobile App]
    H -->|Dispatch Alert| I[🏊 Lifeguard Team]
    H -->|Medical Triage Alert| J[🩺 Medical Response Unit]
    H -->|Daily Facility Reports| K[🏢 Organization Manager]
```

---

## ⚡ Key Features

### 1. 🤖 Edge AI & Computer Vision Pipeline (`projectjetson/`)
- **NVIDIA Jetson Hardware Acceleration:** Operates on edge devices (Jetson Nano / Orin) with GPU-accelerated TensorRT/CUDA pipelines.
- **YOLOv8 Real-time Inference (`best.pt`):** Detects swimmers and differentiates between normal swimming, submersion, and violent distress motions.
- **Custom PyTorch CNN (`model.pth`):** Multi-layer convolutional neural network with adaptive pooling for high-confidence classification.
- **Temporal Persistence Filter:** Multi-frame threshold verification (`threshold`) prevents false alarms caused by casual diving or splashing.
- **Automated Incident Capture:** Captures and uploads photographic evidence and timestamped incident logs directly to Firebase.

### 2. 📱 Flutter Mobile Application (`lib/`)
- **Role-Based Access Control (RBAC):**
  - **🏢 Organization Manager:** Creates facilities, generates unique organization passcodes, manages staff rosters, and reviews comprehensive daily incident logs.
  - **🏊 Lifeguard:** Receives instant emergency alerts with custom high-decibel audio sirens, starts response-time stopwatch, and files post-rescue triage reports.
  - **🩺 Medical Personnel (Medic):** Receives escalated alerts when CPR or ambulance transfer is required, documenting vitals and emergency treatment.
- **State Management:** Clean, scalable reactive state powered by **Provider** (`ChangeNotifierProvider`, `MultiProvider`).
- **Emergency Sound & Haptics:** Custom alarm audio integration via `audioplayers` and background heads-up notifications via `flutter_local_notifications`.
- **Localization (i18n):** Complete Arabic (`ar`) and English (`en`) bilingual support.
- **Dynamic Theming:** High-contrast Dark mode and modern Light mode with animated theme switches.

---

## 📂 Project Structure

```
hydrosavex/
├── projectjetson/                     # Edge AI & Computer Vision (Python / Jetson)
│   ├── final.py                       # Main production pipeline (YOLOv8 + Firebase)
│   ├── jetson.py                      # Custom PyTorch CNN inference & local alarm
│   ├── send_test_notification.py      # FCM test notification dispatcher
│   ├── best.pt                        # YOLOv8 fine-tuned drowning weights
│   ├── model.pth                      # Custom PyTorch CNN model weights
│   ├── lb.pkl                         # Label binarizer
│   └── firebase-adminsdk.example.json # Service account configuration template
│
├── lib/                               # Cross-Platform Flutter Application
│   ├── controller/                    # Provider state controllers
│   │   ├── lifeguardController.dart
│   │   ├── lifeguardReportController.dart
│   │   ├── medicController.dart
│   │   ├── organizationManagerController.dart
│   │   └── timer_provider.dart
│   ├── model/                         # Data models (Users, Reports, Alerts)
│   ├── services/                      # Authentication & Notification services
│   ├── database/                      # Firebase Firestore & Auth integration
│   ├── l10n/                          # Localization bundles (Arabic / English)
│   ├── utils/                         # Themes, constants & helpers
│   └── view/                          # Feature views & responsive UI components
│       ├── authentication/            # Login, Signup & Member Onboarding
│       ├── lifeguard/                 # Lifeguard alert feeds & incident details
│       ├── madical/                   # Medical response & triage dialogs
│       ├── organization/              # Facility daily logs & staff rosters
│       └── timer/                     # Rescue countdown & response timer
│
├── screenshots/                       # High-resolution showcase screenshots
└── pubspec.yaml                       # Flutter dependencies & assets
```

---

## 🚀 Getting Started

### Prerequisites
- **Mobile:** Flutter SDK (`>= 3.2.4`), Android Studio / Xcode
- **Edge AI:** NVIDIA Jetson (JetPack 4.6+ / 5.0+), Python 3.8+, CUDA, OpenCV, PyTorch

### 1. Mobile App Setup
```bash
# Clone the repository
git clone https://github.com/AlsayedAbdelmohiemen/Hydrosavex.git
cd Hydrosavex

# Install dependencies
flutter pub get

# Run on connected device or emulator
flutter run
```

### 2. Edge AI Setup (NVIDIA Jetson)
```bash
cd projectjetson

# Install Python requirements
pip install ultralytics opencv-python firebase-admin torch torchvision

# Configure Firebase Service Account
cp firebase-adminsdk.example.json drowning-detection-main-firebase-adminsdk.json
# Fill in your Firebase Admin SDK credentials in the json file

# Launch the real-time detection pipeline (use 0 for live camera or video file path)
python final.py --video 0 --conf 0.5 --threshold 14
```

---

## 🔒 Security & Privacy Notice

- Private credentials (Firebase Admin SDK private keys) are excluded from version control via `.gitignore`.
- Always generate your own service account private keys from the **Firebase Console -> Project Settings -> Service Accounts**.

---

## 👨‍💻 Author & Repository

- **Repository:** [https://github.com/AlsayedAbdelmohiemen/Hydrosavex](https://github.com/AlsayedAbdelmohiemen/Hydrosavex)
- **Developed by:** Sayed Abdelmohiemen & Team

---

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.
