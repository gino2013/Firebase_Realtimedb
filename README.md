```markdown
# MedicalDeviceApp

MedicalDeviceApp is an application built with SwiftUI and Firebase Realtime Database for managing medical device data. The app allows users to view, edit, and update detailed information about medical devices.

## Features

- View a list of medical devices
- Edit detailed information of medical devices
- Synchronize with Firebase Realtime Database

## File Structure

```plaintext
MedicalDeviceApp/
├── MedicalDeviceApp.swift        # Entry point of the application
├── AppDelegate.swift             # Initializes Firebase
├── MedicalDevice.swift           # Data model for medical devices
├── MedicalDeviceViewModel.swift  # ViewModel for managing medical device data
├── MedicalDeviceRow.swift        # View for displaying and editing each medical device
├── ContentView.swift             # Main content view displaying the list of medical devices
├── Podfile                       # CocoaPods dependencies
├── .gitignore                    # Git ignore file
└── README.md                     # Project README file
```

## Installation

1. **Clone the repository**

    ```bash
    git clone git@github.com:gino2013/Firebase_Realtimedb.git
    cd Firebase_Realtimedb
    ```

2. **Install CocoaPods dependencies**

    ```bash
    pod install
    ```

3. **Open the Xcode workspace**

    Open the `MedicalDeviceApp.xcworkspace` file in Xcode.

4. **Set up Firebase**

    - Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
    - Download the `GoogleService-Info.plist` file from your Firebase project settings and add it to your Xcode project.
    - Ensure Firebase Realtime Database is enabled.

## Usage

- Run the project in Xcode.
- In the app, you can view the list of medical devices, click on a device to edit and update its details.

## .gitignore

The following is the `.gitignore` file for the project, which ignores files and directories that should not be committed to version control:

```plaintext
# Xcode
.DS_Store
build/
*.xcworkspace
xcuserdata/
DerivedData/
.idea/

# Swift Package Manager
/.build/
swiftpm/xcode/package.xcworkspace/

# CocoaPods
/Pods/
/Podfile.lock

# Carthage
/Carthage/Build/

# fastlane
fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots
fastlane/test_output
fastlane/report.html

# Xcode Scheme
*.xcscheme

# Playgrounds
timeline.xctimeline
playground.xcworkspace

# AppCode
.idea/
*.iml

# Generated files
*.hmap
*.ipa
*.dSYM.zip
*.dSYM
*.app.dSYM
*.framework.dSYM
*.swiftmodule
*.swiftdoc
*.xcfilelist
*.xctestresult
*.xcresult

# Other
*.env
*.DS_Store
```

## Contributing

Contributions are welcome! Please read the CONTRIBUTING.md for guidelines.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
```
MIT License

Copyright (c) [2024] [lucian_lu]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
![screen_shot](/app_screenshot_001.png)
![screen_shot](/app_screenshot_002.png)
![screen_shot](/app_screenshot_003.png)