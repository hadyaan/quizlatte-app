# QuizLatte - Flutter Quiz App with Admin Dashboard

**QuizLatte** is a modern quiz application built with **Flutter** and **Firebase**. This app is designed for both **users** and **admins**, supporting dynamic quiz generation, role-based access, and an algorithmic question shuffle system.

---

## 🚀 Features

### 👤 User
- 🔐 Login & Sign Up with Firebase Authentication
- 🧠 Play quizzes with a clean, responsive UI
- 📝 Get instant feedback after submitting answers
- 🔄 Questions are shuffled using **Fisher-Yates Shuffle Algorithm**

### 👨‍💼 Admin
- ➕ Add new quizzes and questions
- ✏️ Edit or delete existing content
- 🎛️ Toggle Fisher-Yates shuffle option during quiz creation

### 🖼 UI/UX
- 🌙 Dark and Light mode theme
- 💥 Custom splash screen
- 📱 Rounded app icon with adaptive Android support

---

## 🧠 Fisher-Yates Shuffle in QuizLatte

QuizLatte uses the **Fisher-Yates Shuffle Algorithm** to randomize the order of questions each time a quiz starts. This prevents predictability and ensures a fair experience.

### How it works:
The algorithm swaps each element in the array with a randomly selected one that comes after (or itself). It has **O(n)** time complexity and produces an **unbiased shuffle**, making it ideal for randomized quizzes.

The toggle feature allows admins to decide whether a quiz should present questions in a fixed or randomized order.

---

## 🛠️ Built With

- **Flutter 3.8**
- **Firebase Auth & Firestore**
- `flutter_login`, `google_fonts`, `shared_preferences`
- `flutter_launcher_icons`, `flutter_native_splash`
- `flutter_animate`, `percent_indicator`

---

## 🔐 Disclaimer
- This project is publicly available for educational and portfolio purposes only.
- Please do not redistribute or repackage the APK without permission.
- Sensitive keys and credentials are excluded from this repository.
