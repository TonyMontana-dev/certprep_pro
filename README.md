An app for personal use to practice and prepare for the exams I am pursuing.
Pretty simple right? Too many options that are either to be paid or incomplete.

Therefore I make my own.

Ah, naturally don't take this project seriously. I made it by experimenting this new wave of vibe-coding. At the same time I practiced and learned some new things. 
So yes, everything you see its not just you thinking, it actually is. All made with AI. I specifically used ChatGPT-4o, thats it. Therefore this app if you like it, you can run it locally or export it by yourself for any device.

# CertPrep Pro

CertPrep Pro is a fully offline, free, and open-source mobile app for practicing certification exams like **ISC2 Certified in Cybersecurity (CC)** and **CompTIA Security+**. It provides unlimited access to quiz questions and flashcards to help you prepare for these exams at your own pace, without any internet connection required.

## Purpose

The primary motivation behind CertPrep Pro is to offer students and aspiring professionals a **free and infinite practice** platform for certification exams. Unlike many paid apps or websites, CertPrep Pro has **no ads, no paywalls, and no usage restrictions**. It was developed as a personal coding experiment by *TonyMontana-dev* to create an open alternative for exam preparation. **This app is intended for educational and personal use only** &mdash; it is not meant for commercial distribution, and no professional support or warranty is provided.

## Features

- **Interactive Quiz System:** Flexible quiz engine with a retry logic that allows up to **two attempts** per question. If you answer incorrectly on the first try, you get one more chance to choose the right answer before the solution is revealed. This helps reinforce learning by giving you a second chance on missed questions.
- **Question Bookmarking:** Mark any question for later review. Additionally, any question you answer incorrectly is **automatically bookmarked** so you can easily revisit and practice it again. This ensures you focus on areas where you need improvement.
- **Flashcards Mode:** Study using a built-in flashcards tool. Flip through flashcards for key terms and concepts related to the exams. This mode is great for quick review and memorization of important facts, independent of the quiz system.
- **Analytics Dashboard:** Track your performance with detailed stats and charts. The app shows **total questions answered**, **correct answers**, **overall accuracy** (in %), **total time spent**, and a breakdown of your accuracy by domain/topic. Use these insights to identify your strong and weak areas and monitor improvement over time.
- **Topic & Exam Selection:** Focus your studies by selecting specific topics or domains, or take on a full-length exam simulation. You can choose which certification (e.g. CC or Security+) and which domains to practice, allowing for targeted studying or broad reviews.
- **“Quick Quiz” Mode:** Short on time? Jump into a **Quick Quiz** which generates a random set of 10 questions. This mode is perfect for a quick practice session when you have a few minutes, giving you a rapid-fire review.
- **Offline Database:** All content is available fully offline. CertPrep Pro uses a local **SQLite database** (via the SQFLite Flutter plugin) that comes pre-loaded with the question bank. The data is initially imported from JSON files bundled with the app, so **no internet connection** is needed after installation. You have full access to all questions and flashcards anytime, anywhere.
- **Smooth UI & Animations:** Enjoy a polished user experience with smooth page transitions and subtle UI animations. The app feels responsive and fluid, making navigation between quizzes, flashcards, and analytics enjoyable without being distracting.

## Design & UX Philosophy

CertPrep Pro embraces a **clean, dark-only UI** that is easy on the eyes during extended study sessions. The design takes inspiration from Apple's sleek interface guidelines and the minimalist aesthetics of modern AI chat apps (like ChatGPT and Claude). The color scheme is dark with subtle accent colors (for example, a teal green for progress bars and correct answers) to provide visual interest without straining the eyes. Key information is presented in a clear, uncluttered manner using easy-to-read typography.

Interactions throughout the app are smooth and intuitive, with subtle animations enhancing the user experience. Navigation between questions, flashcards, and analytics is seamless, giving the app a polished feel. The interface avoids unnecessary clutter, focusing on content and essential controls so that you can concentrate on learning with minimal distractions. It’s a UI built for comfort and focus during long study periods.

 ([image]()) *Analytics Dashboard screen of CertPrep Pro.* This screenshot showcases the app's dark theme and modern design. The **Analytics** page (as shown) provides a clear overview of the user's progress with simple typography and vibrant chart visuals on a dark background. The overall design balances visual appeal with readability, ensuring users can study for extended periods without eye strain. The influence of contemporary design aesthetics is evident in the clean layout and gentle color highlights throughout the app.

## Tech Stack

- **Flutter (Dart):** The app is built with Flutter, Google's cross-platform UI toolkit, allowing a single codebase to run natively on both Android and iOS. Dart is used as the programming language for Flutter components.
- **SQLite (SQFLite plugin):** CertPrep Pro uses a local SQLite database (via the SQFLite Flutter plugin) to store all questions, answers, and user progress. This ensures data is persisted on the device and readily accessible offline.
- **JSON Data Import:** The question and flashcard content are defined in JSON files bundled with the app. On first run (or when resetting the app), the app reads these JSON files and populates the SQLite database. This makes it easy to update or add new questions by editing the JSON and rebuilding the app, without needing any server or cloud services.
- **No Backend/No Internet Required:** There are **no external APIs or backend servers**. All data and logic run on-device. Once you have the app installed, it can be used entirely offline with full functionality.

## Getting Started

Follow the steps below to set up the project and run CertPrep Pro on your local machine (for development or testing purposes).

### Prerequisites

- **Flutter SDK:** Install Flutter (SDK) on your system. You can follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install) for your operating system. Ensure that the `flutter` command is available in your PATH.
- **Development Tools:** You can use an IDE like **Visual Studio Code** (with the Flutter extension) or **Android Studio** (or IntelliJ) for a better development experience. For iOS development, you'll need a Mac with **Xcode** installed. Make sure you have an Android emulator or physical device ready for Android testing, and an iOS simulator or device for iOS.
- **Device Setup:** If using a physical Android device, enable Developer Options and USB debugging on your phone. For iOS devices, you need to have proper code signing set up via Xcode. (For development, using the iOS Simulator is often easiest.)

### Installation & Run

1. **Clone the repository:** Clone the CertPrep Pro repository from GitHub to your local machine.  
   ```bash
   git clone https://github.com/TonyMontana-dev/CertPrepPro.git
   ```  
   Then navigate into the project directory:  
   ```bash
   cd CertPrepPro
   ```
2. **Get dependencies:** Fetch the Flutter dependencies by running:  
   ```bash
   flutter pub get
   ```  
   This will download all the required packages listed in `pubspec.yaml` (such as SQFLite).
3. **Run on Android:** Connect your Android device via USB (or start an Android emulator), and ensure Flutter recognizes it by running `flutter devices`. Then launch the app with:  
   ```bash
   flutter run
   ```  
   Flutter will build the app and install it on the connected device/emulator. If you have multiple devices connected, you can specify one with the `-d` flag.
4. **Run on iOS (if on a Mac):** Make sure you have Xcode installed. You might need to run `pod install` in the `ios` folder if it's the first time building for iOS (to install CocoaPods dependencies). After that, you can start the iOS Simulator and run:  
   ```bash
   flutter run
   ```  
   This will build the iOS app and launch it in the simulator (or on a connected iPhone, if you specified one).
5. **Hot Reload (for development):** While the app is running in debug mode, you can save your changes and use Flutter's hot reload (`r` in the console or the lightning bolt button in VS Code/Android Studio) to quickly refresh the app's code without a full restart. This is useful when tweaking UI or adding new questions for testing.

### Updating the Question Bank

The questions and answers are stored in a JSON file located at **`assets/data/certprep_sample_questions.json`**. To modify or add new questions:

- **Edit the JSON:** Open the JSON file and add/modify the questions as needed, following the format of the existing entries (each question likely has fields like question text, options, correct answer, explanation, etc.).
- **Rebuild or Hot Reload:** After making changes to the JSON, rebuild the app (or use hot reload in debug mode) so that the updated data is loaded into the SQLite database. The app reads from the JSON file when initializing the database (usually on first launch or when the database is reset).
- **Adding a New Exam Dataset:** If you want to include an entirely new set of questions for a different exam, you can create a new JSON file (e.g., `my_new_exam_questions.json`) and place it in the `assets/data/` directory. Don't forget to list this file in the `pubspec.yaml` under the `assets` section. You will also need to update the app's code to load this new file and provide an option in the UI to select the corresponding exam.

> **Note:** The app does not automatically re-import the JSON on every launch (to preserve user progress and bookmarks). If you change the JSON content, you may need to reset the app’s database (see below) or increment a version in the code that triggers a re-import, depending on how the import is implemented.

### Resetting the Database

If you need to reset the app's data to start fresh (for example, to clear all progress/bookmarks or to force reloading updated question data):

- **Uninstall/Reinstall method:** The simplest way is to uninstall the app from your device or emulator, then run it again from Flutter (or reinstall the APK). This will wipe all app data, including the SQLite database, and on the next launch the app will re-import the questions from the JSON file as if it's a fresh installation.
- **Manual deletion (advanced):** You can manually delete the SQLite database file from the device. On Android, use Android Studio's Device File Explorer or ADB to navigate to your app's internal storage (under `/data/data/<app_package>/databases/`) and delete the database (e.g., `certprep.db`). On iOS, you can find the app's data in the Simulator's library path or use Xcode tools. Deleting the DB file will cause the app to recreate it and import data anew on next launch.
- **Programmatic reset (for developers):** You may implement a developer-only feature or script to clear the database. For example, in Flutter you could write code to delete the database file or drop all tables. This isn't provided out-of-the-box (to prevent accidental data loss in normal use), but you can add it if you need easier resetting during development.

## Assets and Customization

- **Custom App Icon:** You can replace the default CertPrep Pro icon with your own branding.  
  - *Android:* Replace the launcher icon files in the `android/app/src/main/res/mipmap-*` directories with your custom icon images (provide all the required sizes: mdpi, hdpi, xhdpi, etc.).  
  - *iOS:* Replace the app icon assets in `ios/Runner/Assets.xcassets/AppIcon.appiconset` with your custom icon images (you can use Xcode's Asset Catalog editor to do this).  
  - After updating the icon images for both platforms, rebuild the app to see the new icon reflected on your device/emulator.

- **Adding New Question Data:** The app's question bank is defined by JSON files in the `assets/data/` folder, which makes it easy to extend to new exams or customize content.  
  - Create or edit a JSON file with your new questions, following the same structure as the existing sample file. For a new exam, you might name it accordingly (e.g., `my_exam_questions.json`).  
  - Include the new JSON file in the app bundle by listing it under the `flutter:` assets section in `pubspec.yaml`. For example:  
    ```yaml
    flutter:
      assets:
        - assets/data/my_exam_questions.json
    ```  
  - Update the app code if necessary to load the new question set (for instance, add a new option in the UI for selecting that exam, and ensure the import logic reads the new file).  
  - Re-run the app. On first launch (with a fresh database or after a reset), the app will import the questions from the JSON into the local database, making them available for use.

## License

TO BE ADDED

## Credits

Built with ❤️ by **TonyMontana-dev**. This app was created as a personal project to help others learn. Feel free to explore, contribute, or use it for your own study needs!
