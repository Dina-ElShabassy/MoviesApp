# Movies App

## Overview

This iOS app is designed to provide users with information about now playing movies. The app consists of two screens: 

1. **Movies List Screen:**
   - Displays a list of now-playing movie posters.
   - Provides sorting options by most popular, top-rated, or clears the sorting.
   - Implements pagination for infinite scrolling to load more movies.
   
2. **Movie Details Screen:**
   - Displays detailed information about the selected movie.

The app follows the MVVM architecture, utilizing the Alamofire, SDWebImage, Dropdown, and Lottie-iOS pods to enhance functionality and user experience.

## MVVM Architecture

The app follows the Model-View-ViewModel (MVVM) architecture to separate concerns and make the codebase more modular and testable.

- **Model:** Represents the data and business logic of the app.
- **View:** Represents the UI components displayed to the user.
- **ViewModel:** Acts as a mediator between the Model and View, handling the logic and data flow.

## Dependencies

The project uses CocoaPods as a dependency manager to handle third-party libraries. The following dependencies are used:

- **Alamofire:** Used for handling network requests.
- **SDWebImage:** Provides asynchronous image loading and caching.
- **Dropdown:** A lightweight dropdown menu for user-friendly sorting options.
- **Lottie-iOS:** Allows for easy integration of Lottie animations.

## Unit Testing

Unit tests are implemented to ensure the functionality of the network service. The tests utilize mocking to simulate network responses and verify the correct behavior of the app under different scenarios.

## Installation

Follow these steps to set up the project:

1. Clone the repository to your local machine.

   ```bash
   git clone https://github.com/Dina-ElShabassy/MoviesApp.git
   ```
2. Navigate to the project directory.

    ```bash
    cd MoviesApp
    ```
3. Install dependencies using CocoaPods.

    ```bash
    pod install
    ```
4. Open the project workspace.

    ```bash
    open MoviesApp.xcworkspace
    ```
Build and run the project on your iOS device or simulator.

## Demo

To demonstrate the functionality of the project, I have prepared a video showcasing the key features. Please note that the size of the video is large, so I have provided a link to it instead. You can watch the video by clicking [here](https://drive.google.com/file/d/1CusFZWEbuBe5NOYD6CkHztk1O96X2PDZ/view?usp=drive_link).
