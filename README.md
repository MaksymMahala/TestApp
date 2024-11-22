# TESTTASK

## 1. Configuration Options:

To customize the application, here are the configuration options available:

Network Monitoring: The app uses the Network framework to check the user’s internet connection status. You can modify the network monitoring behavior or update the thresholds for connectivity checks.
Camera Settings: For camera functionality, the app uses AVFoundation for capturing images. You can change the resolution or customize the image capture process in the CameraManager class.
2. Dependencies and External Libraries:

The app uses the following external libraries and frameworks:

URLSession: Used to make API requests to the backend.
This library is a simple and built-in iOS framework that provides networking functionalities.
AVFoundation: Provides a camera interface to capture images and videos.
Chosen because it’s powerful and supports both basic and advanced camera functionalities on iOS.
Combine: This is used for reactive programming, allowing you to efficiently manage the state of the app and optimize performance, especially for network requests and other async operations.
Chosen for its ability to handle asynchronous operations in a more declarative way, simplifying state management and improving performance.
Network Framework: Utilized to monitor the network connection status, ensuring that the user is connected to the internet.
Chosen because it provides a modern, reliable way to check for network changes and connectivity in Swift.
3. Troubleshooting Tips and Common Issues:

Network Issues: If the app isn't connecting to the internet, check the network status. The app uses the Network framework to monitor network connectivity, and if the network is down, a “No Connection” view will be displayed.
Camera Permissions: Make sure the app has permission to use the camera. If the camera doesn't load, check the Info.plist for missing camera usage permissions. Add:
xml
Копіювати код
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to take pictures.</string>
API Errors: If the app fails to load data from the API, ensure the endpoint is accessible and check the URLSession response for errors.
4. How to Build the Application:

Clone the repository from GitHub:
bash
Копіювати код
git clone https://github.com/yourusername/yourrepo.git
Open the project in Xcode (make sure you have the latest version).
Ensure all required permissions are added to the Info.plist for camera access and network monitoring.
Build and run the project in Xcode to see the app in action.
