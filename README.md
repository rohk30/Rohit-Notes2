# 📝 Rohit Notes

> A modern, cloud-synchronized note-taking application built with Flutter and Firebase. Create, manage, and share your notes seamlessly across devices with real-time synchronization.

🌐 **Live Web App:** [rohit-notes.web.app](https://rohit-notes.web.app)


## 📋 Table of Contents

- [🌐 Live Demo](#-live-demo)
- [✨ Features](#-features)
- [🚀 Getting Started](#-getting-started)
- [📱 Usage Guide](#-usage-guide)
- [🏗️ Architecture](#-architecture)
- [📂 Project Structure](#-project-structure)
- [🛠️ Development](#-development)
- [🔮 Future Features](#-future-features)

---

## 🌐 Live Demo

| Platform | URL |
|----------|-----|
| 🌐 **Web App** | [https://rohit-notes.web.app](https://rohit-notes.web.app) |
| 🌐 **Alternate URL** | [https://rohit-notes.firebaseapp.com](https://rohit-notes.firebaseapp.com) |

> Works on any browser — desktop, tablet, or mobile. No installation required.

---

## ✨ Features

### 💻 **Web App**
- 🌐 **Instant Access** — Use directly at [rohit-notes.web.app](https://rohit-notes.web.app), no install needed
- 🖥️ **Two-Pane Layout** — Note list on the left, editor on the right on wide screens
- 📋 **Clipboard Copy** — Share button copies note to clipboard on web

### 🔐 **Authentication & Security**
- 📧 **Email/Password Registration** — Create a new account with email verification
- 🔑 **Secure Login** — Firebase-backed authentication with persistent sessions
- ✔️ **Email Verification** — Confirm your email address before accessing notes
- 🔄 **Password Recovery** — Reset forgotten passwords via email link
- 💾 **Email History** — Auto-save recent login emails for quick re-entry (up to 5 emails)
- 🚪 **Session Management** — Secure logout with confirmation dialog

### 📝 **Note Management**
- ✏️ **Create Notes** — Instantly create new notes with a clean, distraction-free interface
- 📖 **View Notes** — Browse all your notes in an organized list
- 🔄 **Real-Time Auto-Save** — Changes sync to the cloud automatically on every keystroke
- 🎯 **Edit Notes** — Seamlessly update note content with live cloud synchronization
- 🗑️ **Delete Notes** — Remove notes with a single tap (empty notes auto-delete on exit)
- 🔍 **Search Notes** — Quickly find notes by searching through titles/headings

### ☁️ **Cloud Synchronization**
- 🔁 **Real-Time Sync** — Notes instantly sync across all your devices
- ⚡ **Offline Ready** — View cached notes even without internet (Firestore listeners)
- 🌐 **Multi-Device Support** — Access your notes from any device, anytime

### 📤 **Sharing & Export**
- 📱 **Platform Share** — Share notes via WhatsApp, Email, SMS, and more
- 📋 **Markdown Formatting** — Notes shared with formatted headings for better readability
- 🎨 **Rich Share Format** — Title in bold, followed by note content


---

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.x or higher) — [Download](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (3.4.4 or higher) — Included with Flutter
- **Git** — For cloning the repository
- **Android Studio** or **Xcode** — For running on emulator/device

### Installation

#### 1. **Clone the Repository**
```bash
git clone https://github.com/rohk30/Rohit-Notes2.git
cd Rohit-Notes2
```

#### 2. **Install Dependencies**
```bash
flutter pub get
```

#### 3. **Firebase Configuration**
The Firebase configuration is already set up in the project. Ensure you have:
- ✅ `google-services.json` (Android) — Located in `android/app/`
- ✅ `GoogleService-Info.plist` (iOS) — Located in `ios/Runner/`
- ✅ `lib/firebase_options.dart` — Auto-generated configuration file

> 💡 **Note**: Firebase configuration files are pre-configured. If you're setting up a new Firebase project, follow the [Firebase Setup Guide](#firebase-setup-for-developers) in the Development section.

#### 4. **Run the App**

**On Android Emulator/Device:**
```bash
flutter run
```

**On iOS Simulator/Device:**
```bash
flutter run -d macos
```

**On Web:**
```bash
flutter run -d chrome
```

**On Windows:**
```bash
flutter run -d windows
```

---

## 📱 Usage Guide

### 🔐 **First Time Setup**

#### Sign Up
1. Launch the app
2. Tap **"Don't have an account? Register here"** on the login screen
3. Enter your **email address** and **password**
4. Tap **"Register"**
5. 📧 An email verification link will be sent to your inbox
6. Open the email and click the verification link (or tap **"Resend Email"** if needed)
7. Return to the app and proceed to your notes dashboard ✅

#### Login
1. Enter your **email address** (use auto-complete if you've logged in before)
2. Enter your **password**
3. Tap **"Login"**
4. If you haven't verified your email, the app will prompt you to verify it first

#### Forgot Password?
1. Tap **"Can't remember password?"** on the login screen
2. Enter your **email address**
3. Tap **"Send Reset Link"**
4. 📧 Check your email for a password reset link
5. Click the link to set a new password
6. Log in with your new password

---

### 📝 **Managing Your Notes**

#### Create a New Note
1. Go to the **Notes** screen (main dashboard)
2. Tap the **"+"** button or **"New Note"** option
3. Start typing — the first line becomes your **heading**, the rest becomes the **body**
4. 💾 Your note auto-saves in real-time
5. Tap back to return to the notes list

**Example:**
```
My First Note          ← This line is the heading
This is the note body. ← Everything else is the body
You can write as much as you want!
```

#### View & Edit Notes
1. Open the **Notes** screen
2. Tap any note from the list to **edit**
3. Make changes — they auto-save to the cloud instantly
4. Tap back to return to the list

#### Search Notes
1. On the **Notes** screen, use the **search bar**
2. Type the heading or title of the note you're looking for
3. Results filter in real-time
4. Tap a result to open it

#### Share a Note
1. Open the note you want to share
2. Tap the **"Share"** button
3. Select your preferred platform:
   - 📱 **WhatsApp** — Share with a contact
   - 📧 **Email** — Send to email address
   - 💬 **SMS** — Text message
   - 🎯 **Other apps** — Copy, Notes, etc.
4. The note will be formatted with the heading in bold

#### Delete a Note
1. Open the note you want to delete
2. Clear all the text and exit the note
3. Empty notes automatically delete from the cloud ✅

Alternatively:
1. On the Notes screen, long-press a note
2. Tap **"Delete"** (if this feature is enabled)

#### Logout
1. Go to the **Notes** screen
2. Tap the **"Logout"** button
3. Confirm the logout action
4. You'll be returned to the login screen

---

## 🏗️ Architecture

### **Design Patterns**

#### 🎯 **BLoC (Business Logic Component) Pattern**
The app uses the BLoC pattern for clean separation of concerns:
- **AuthBloc** — Manages authentication state lifecycle
- **UI Layer** — Views that react to state changes
- **Service Layer** — Pure business logic and Firebase integration

#### 🔧 **Service Layer Architecture**
- **AuthService** — Facade for Firebase Authentication
- **FirebaseCloudStorage** — Singleton managing Firestore operations

---

### **Technology Stack**

| Component | Technology | Version |
|-----------|-----------|---------|
| **Framework** | Flutter | 3.x |
| **Language** | Dart | 3.4.4+ |
| **State Management** | flutter_bloc | 9.1.0+ |
| **Backend** | Firebase | Latest |
| **Authentication** | Firebase Auth | 5.1.2+ |
| **Database** | Cloud Firestore | 5.1.0+ |
| **Local Storage** | SharedPreferences | 2.3.3+ |
| **Sharing** | share_plus | 10.1.4+ |
| **Analytics** | Firebase Analytics | 11.2.0+ |
| **Hosting** | Firebase Hosting | — |

---

### **Firebase Integration**

#### **Firestore Database Structure**
```
Firestore Root
└── notes/ (Collection)
    └── {docId} (Document)
        ├── ownerUserId: String      // Links note to user
        ├── text: String             // Full note content
        └── {auto-generated fields}  // Firestore metadata
```

#### **Auth Flow**
1. **Registration** → Firebase Auth creates user → Email verification sent
2. **Email Verification** → User clicks link → Email verified in Firebase
3. **Login** → Credentials verified → Session token stored
4. **Notes Access** → Firestore queries filtered by `ownerUserId`
5. **Real-Time Updates** → Firestore listeners stream changes
6. **Logout** → Session cleared → Return to login screen

---

### **Data Models**

#### **AuthUser**
```dart
class AuthUser {
  final String id;              // Firebase UID
  final String email;           // User email
  final bool isEmailVerified;   // Email verification status
}
```

#### **CloudNote**
```dart
class CloudNote {
  final String documentId;      // Firestore document ID
  final String ownerUserId;     // User reference
  final String text;            // Note content (heading\nbody)
}
```

---

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry point & main widget
├── firebase_options.dart              # Firebase configuration (auto-generated)
├── constants/
│   └── routes.dart                    # Route names and constants
├── enums/
│   └── menu_actions.dart              # Menu action types
├── extensions/
│   └── list/                          # List extension utilities
├── helpers/
│   ├── local_email_storage.dart       # Email storage utilities
│   ├── saved_emails_storage.dart      # SharedPreferences helper
│   └── loading/                       # Loading screen overlay
├── services/
│   ├── auth/
│   │   ├── auth_bloc.dart             # Authentication BLoC
│   │   ├── auth_event.dart            # Auth events (Login, Register, etc.)
│   │   ├── auth_state.dart            # Auth states
│   │   ├── auth_service.dart          # Auth service facade
│   │   ├── firebase_auth_provider.dart# Firebase Auth implementation
│   │   └── auth_user.dart             # AuthUser model
│   ├── cloud/
│   │   ├── firebase_cloud_storage.dart# Firestore operations
│   │   ├── cloud_note.dart            # CloudNote model
│   │   ├── cloud_storage_constants.dart# Field mappings
│   │   └── cloud_storage_exceptions.dart# Custom exceptions
│   └── crud/
│       └── ...                        # CRUD operation handlers
├── utilities/
│   ├── dialogs/                       # Dialog helpers
│   └── generics/                      # Generic utility functions
└── views/
    ├── login_view.dart                # Login screen
    ├── register_view.dart             # Registration screen
    ├── verify_email_view.dart         # Email verification screen
    ├── forgot_password_view.dart      # Password recovery screen
    └── notes/
        ├── notes_view.dart            # Main notes dashboard
        └── notes_create_update_view.dart # Note editor
```

---

## 🛠️ Development

### **Development Environment Setup**

#### Prerequisites for Developers
- **Flutter SDK** (latest version)
- **VS Code** or **Android Studio**
- **Firebase CLI** (optional, for advanced setup)
- **Git** for version control

#### Running in Debug Mode
```bash
flutter run
```

#### Running with Verbose Logging
```bash
flutter run -v
```

#### Building Release APK
```bash
flutter build apk --release
```

#### Building Release iOS App
```bash
flutter build ios --release
```

---

### **Firebase Setup for Developers**

If you're setting up a new Firebase project:

1. **Create a Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com)
   - Click **"Add Project"**
   - Enter project name: `Rohit-Notes2`
   - Enable Google Analytics (optional)

2. **Setup Authentication**
   - In Firebase Console → **Authentication**
   - Click **"Get Started"**
   - Enable **"Email/Password"** as a sign-in method

3. **Create Firestore Database**
   - In Firebase Console → **Firestore Database**
   - Click **"Create Database"**
   - Start in **"Production Mode"**
   - Choose your region (closest to users)

4. **Firestore Security Rules**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /notes/{note} {
      allow read, write: if request.auth.uid == resource.data.ownerUserId;
      allow create: if request.auth.uid != null;
    }
  }
}
```

5. **Add Apps to Firebase Project**
   - For Android: Download `google-services.json` → Place in `android/app/`
   - For iOS: Download `GoogleService-Info.plist` → Place in `ios/Runner/`

6. **Generate Firebase Options**
   ```bash
   flutterfire configure
   ```
   This generates `lib/firebase_options.dart` automatically.

8. **Web-specific Firebase notes**
    - The project includes a basic web Firebase setup but some fields are placeholders
       (notably the web `appId` and `measurementId`) in `lib/firebase_options.dart` and
       `web/index.html`.
    - For a proper web deployment run `flutterfire configure` and select the web app
       to regenerate accurate values, or edit the following files with values from
       the Firebase console:
       - `lib/firebase_options.dart`
       - `web/index.html`
    - To run locally in Chrome:
       ```bash
       flutter run -d chrome
       ```
    - To build a production web bundle:
       ```bash
       flutter build web --release
       ```

7. **Enable Analytics** (Optional)
   - Firebase Console → **Analytics**
   - Enable Google Analytics for your project

---

### **Key Development Concepts**

#### **BLoC Pattern Workflow**
1. **Event** → User action (Login, Register, LogOut)
2. **BLoC** → Processes event & calls services
3. **State** → UI reflects new state
4. **Widget Rebuild** → UI updates automatically

#### **Service Layer**
- **AuthService** — Wraps Firebase Auth
- **FirebaseCloudStorage** — Wraps Firestore operations
- Clean separation between UI and business logic

#### **Real-Time Streaming**
- `allNotes(userId)` returns a `Stream<Iterable<CloudNote>>`
- Use `StreamBuilder` in widgets to listen to changes
- Firestore listeners handle live updates

#### **Error Handling**
All services throw custom exceptions:
- `CouldNotCreateNoteException`
- `CouldNotUpdateNoteException`
- `CouldNotDeleteNoteException`
- `CouldNotGetAllNotesException`

Handle these in the BLoC or UI layer appropriately.

---

### **Testing**

#### **Run Tests**
```bash
flutter test
```

#### **Test Files**
- `test/auth_test.dart` — Authentication tests
- `test/notes_crud_test.dart` — Note CRUD operation tests

---

### **Building & Deployment**

#### **Web — Deploy to Firebase Hosting**
```bash
# One-command deploy (Windows)
deploy.bat

# Or manually
flutter build web --release
firebase deploy --only hosting:rohit-notes
```
Live at: [https://rohit-notes.web.app](https://rohit-notes.web.app)

#### **Android Build**
```bash
flutter build apk --release
```

#### **iOS Build**
```bash
flutter build ios --release
```

#### **Web Build**
```bash
flutter build web --release
```

#### **Windows Build**
```bash
flutter build windows --release
```

---


## 🔮 Future Features

🚀 Exciting features coming soon:

- 🏷️ **Note Categories & Tags** — Organize notes with customizable tags and categories
- 📌 **Pin Important Notes** — Keep frequently accessed notes at the top
- 🌙 **Dark Mode** — Eye-friendly dark theme for nighttime use
- 📅 **Note History & Versions** — View and restore previous versions of notes
- 🔐 **Encrypted Notes** — Password-protect sensitive notes
- 👥 **Collaborative Notes** — Share and edit notes with other users in real-time
- 🎨 **Rich Text Editing** — Bold, italic, lists, and formatting options
- 📎 **File Attachments** — Attach images, PDFs, and other files to notes
- 🔊 **Voice Notes** — Record audio notes with transcription
- ⭐ **Favorites** — Mark notes as favorites for quick access
- 🌐 **Multi-Language Support** — Support for multiple languages
- 🔍 **Advanced Search** — Filter by date, tag, color, and content
- 📊 **Note Statistics** — View creation/edit dates, word count, and usage insights
- 🔔 **Reminders & Notifications** — Get reminded about important notes
- 📤 **Export to PDF/Markdown** — Export notes in various formats
- 🤖 **AI Assistant** — Smart suggestions and note enhancement features

---

<div align="center">

### Made with ❤️ by Rohit

🌐 **Try it live:** [rohit-notes.web.app](https://rohit-notes.web.app)

⭐ If you find this project helpful, please give it a star!

</div>