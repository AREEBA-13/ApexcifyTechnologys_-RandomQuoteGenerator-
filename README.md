# Quotes Generator

A beautifully designed, minimalist Random Quote Generator app built with Flutter. The application presents an elegant "Paper on a Desk" aesthetic, delivering daily inspiration through a clean and distraction-free user interface.

## Features

*   **Random Quote Generation:** Fetches and displays random inspirational quotes.
*   **Unique UI/UX:** Styled as a physical piece of paper sitting on a desk surface, complete with subtle drop shadows, realistic textures, and dynamic bookmark accents.
*   **Intuitive Gestures:** Simply swipe left or right on the quote card to intuitively pull a new quote.
*   **Haptic Feedback:** Premium tactile responses (light impact vibrations) upon interaction to enhance the physical desk metaphor.
*   **Smooth Animations:** Micro-animations for loading states, including fading text and scaling effects to create a seamless experience.
*   **Robust Error Handling:** Inline friendly error messages with retry capabilities built directly into the UI if network connectivity drops.

## Tech Stack

*   **Framework:** [Flutter](https://flutter.dev/) (Dart)
*   **State Management:** [Provider](https://pub.dev/packages/provider)
*   **Typography:** [Google Fonts](https://pub.dev/packages/google_fonts) (Merriweather for quotes, Roboto for author details)
*   **HTTP Client:** [http](https://pub.dev/packages/http) package for RESTful API communication

## Architecture & API

*   **API:** This project uses the [DummyJSON Quotes API](https://dummyjson.com/docs/quotes) to fetch random quotes efficiently and reliably.
*   **State Management:** The application state is strictly managed using the `Provider` pattern (`ChangeNotifier`). The `QuoteProvider` seamlessly handles the data flow, loading states, and error handling, keeping the business logic completely decoupled from the UI.

## Getting Started

To run this project locally, ensure you have the Flutter SDK installed on your system.

1.  Clone this repository:
    ```bash
    git clone https://github.com/AREEBA-13/ApexcifyTechnologys_-RandomQuoteGenerator-.git
    ```
2.  Navigate to the project directory:
    ```bash
    cd ApexcifyTechnologys_-RandomQuoteGenerator-
    ```
3.  Install the necessary dependencies:
    ```bash
    flutter pub get
    ```
4.  Run the application on your connected device or emulator:
    ```bash
    flutter run
    ```

## Building for Release

To generate a production-ready APK for Android devices:

```bash
flutter build apk --release
```

The resulting APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.
