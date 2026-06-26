# 📱 Information Retrieval System (Mobile App)

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![GetX](https://img.shields.io/badge/State_Management-GetX-FF5722)
![UI](https://img.shields.io/badge/UI-Material_Design_3-9C27B0)

A beautiful, high-performance Flutter mobile application that acts as the frontend interface for our Information Retrieval System backend. Built with Dart, Flutter, and GetX for reactive state management.

This app allows users to seamlessly switch between Datasets (Quora, MS MARCO), tune BM25 parameters, view assigned LDA topics, and benchmark Search Models using an intuitive touch interface.

---

## ✨ Features

*   **🔍 Advanced Search Interface:** Modern search bar with live querying and results formatting.
*   **⚙️ Real-time Parameter Tuning:** Interactive sliders to modify BM25 parameters (`k1` and `b`) on the fly.
*   **🛠️ Refinement Toggle:** One-tap switch to enable or disable Query Refinement (Spelling & Synonyms).
*   **🏷️ Topic Chips:** Visually displays the LDA topic tags for each returned document.
*   **📊 Evaluation Dashboard:** A dedicated tab that runs batch evaluations (100+ queries) and visualizes MAP, Recall, Precision@10, and nDCG, comparing Base Search against Refined Search.

---

## 🏗️ Project Architecture

We utilize **GetX** for navigation, dependency injection, and reactive state management.

```text
lib/
├── app/
│   ├── modules/
│   │   ├── search/          # Search UI, Models, and Controllers
│   │   └── evaluation/      # Evaluation UI and Controllers
├── config/                  # Network configs, APIs, Theme Tokens
└── main.dart                # App Entry Point
```

---

## 🚀 Quick Start

### 1. Prerequisites
*   Flutter SDK installed
*   Android Studio / VS Code
*   The **IR System Backend** must be running locally.

### 2. Network Configuration
Because the backend runs on your computer and the app runs on an emulator or physical device, you **must update the IP Address** in the config file.

Open `lib/config/network_service_config/network_service_config.dart` and change `kApiBaseUrl` to your computer's Wi-Fi IP address (e.g., `192.168.1.102`):
```dart
const String kApiBaseUrl = 'http://192.168.1.102:8000';
```

### 3. Run the App
Connect your Android/iOS device or start an Emulator, then run:
```bash
flutter clean
flutter pub get
flutter run
```
