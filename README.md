FLUTTER AI APP
=============

A modern Flutter application integrating AI capabilities with Firebase authentication and Imgur image processing.

FEATURES
--------

[Authentication]
* Email & Password Sign In/Registration
* Profile Management
  - Edit Profile Information
  - Change Password
  - Profile Picture Upload
  - Account Deletion

[AI Feature]
* Facebook BlenderBot for Conversation
* Image Analysis Vision Transformer

ARCHITECTURE
-----------

![Screenshot 2025-03-09 at 04 38 02](https://github.com/user-attachments/assets/857e44d7-3834-4f6a-9ae6-99716db1d301)

TECHNOLOGIES
-----------

[Backend & Authentication]
* Firebase Authentication
* Firebase Core

[State Management]
* Riverpod
* Provider Pattern

[Navigation]
* Go Router

[Image Processing]
* Imgur API Integration
* Image Picker

[UI Components]
* Custom Buttons
* Custom Text Fields
* Custom Bottom Sheets

ARCHITECTURE AND DESIGN DECISION
-----------
* Simple Feature-First Architecture help me to create MVP product and not implemented clean architecture (which is scalable) made development faster (since working by myself)
* Riverpod for simple state management
* I realy reccommending using simple architecture with scalable and separation concern to keep project clean and maintanable to achieve MVP

HOW THE APP WORKS
-----------
1. Authentication Flow:
   * User starts at Login/Register screen
   * After successful authentication, user data is stored in UserProvider
   * Protected routes become accessible
   * Profile management allows users to update their information

2. AI Integration Flow:
   * User can initiate chat conversations using Facebook's/Meta's BlenderBot
   * Image analysis
   * You need API key from hugging face to use this feature (I using free tier)

3. State Management:
   * Riverpod manages global application state
   * Providers handle specific feature states
   * AsyncValue for loading and error states

4. Data Flow:
   * User actions trigger provider state changes
   * Providers communicate with external services (Firebase, Imgur, AI models)
   * UI updates automatically through provider state changes

DEPENDENCIES
-----------
* flutter_riverpod
* go_router
* firebase_auth
* firebase_core
* image_picker

GETTING STARTED
--------------

1. Prerequisites
   - Flutter SDK
   - Android Studio or VS Code
   - Git

2. Environment Setup
   $ git clone <repository-url>
   $ flutter pub get

3. Configuration
   - Set up Firebase project
   - Configure Imgur API credentials
   - Update environment variables

4. Run the app
   $ flutter run

SCREENSHOTS
----------
| Image  | Desc |
| ------------- | ------------- |
| ![Screenshot_2025-03-09-04-38-27-426_com example flutter_ai](https://github.com/user-attachments/assets/52ef10d2-3990-4e4d-ad2c-16c0b03d7e80) | Home |
| ![Screenshot_2025-03-09-04-43-42-562_com example flutter_ai](https://github.com/user-attachments/assets/8f5ac2ae-5c46-485c-beb7-ec1d91fad72a) | Chat |
| ![Screenshot_2025-03-09-04-44-06-655_com example flutter_ai](https://github.com/user-attachments/assets/1cc07b64-a44f-4611-9d8d-03bb76e031dc) | Image Analysis |
| ![Screenshot_2025-03-09-04-39-55-048_com example flutter_ai](https://github.com/user-attachments/assets/e54a7453-26c1-4329-bd9b-0e27f31cc50d) | Register |
| ![Screenshot_2025-03-09-04-39-52-702_com example flutter_ai](https://github.com/user-attachments/assets/cedc692b-ea65-4566-a88b-f58faed2bf78) | Login |
| ![Screenshot_2025-03-09-04-39-21-926_com example flutter_ai](https://github.com/user-attachments/assets/d383258c-28ef-445a-a873-b2e399941d3b) | Profile Tab |
| ![Screenshot_2025-03-09-04-39-40-601_com example flutter_ai](https://github.com/user-attachments/assets/ed71cf58-d21c-44ee-b407-bbb89ff01736) | Edit Profile |
| ![Screenshot_2025-03-09-04-39-47-273_com example flutter_ai](https://github.com/user-attachments/assets/9cf8e5e2-6c0b-41f7-87ce-00c6ae364739) | Delete Account |


CONTRIBUTING
-----------
Contributions, issues, and feature requests are welcome!

LICENSE
-------
This project is licensed under the MIT License - see the LICENSE file for details.
