# findmyfriend

A new Flutter project.
this project is used to find the location of another user

## Getting Started
build gradle configurations
in Android>app>settings.gradle
plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "8.2.1" apply false
    id "com.google.gms.google-services" version "4.3.15" apply false
    id "org.jetbrains.kotlin.android" version "1.8.22" apply false
} 
change the current versions to the above mentioned versions 

Firebase configuration
run flutterfire configuration and cli commands
the project name is findmyfriend
the project id is findmyfriend-71226

This project is used to find the users current location and the active location of another user.

the recieved location is stored in firebase real time database such it can be accessed when needed.

simple login in logout feature has been added without backend integration therefore the only criteria checked during login is that the username contain a '@' symbol and the password is atleast 8 characters. if these criteria is not met appropriate error messages will be loaded.

simple state management is being used for authentication

for logout a single tap on the icon present at the top right side of the screen will be sufficient.

Has we are not authenticating the users , the location is hard coded.

in debug console it can be seen that the location data is been succefully loaded into the firebase and is fetched from the firebase.
 

"# FIndMyFriend" 
