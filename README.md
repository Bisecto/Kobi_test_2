# 💸 Kobi Transaction

## 🚀 Setup Instructions

Follow the steps below to get started with the project on your local machine.

### Prerequisites

- Flutter SDK (>=3.0.0)
- Android Studio, VS Code, or your preferred IDE
- A connected device or emulator

### Installation Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/Bisecto/Kobi_test_2.git
   cd Kobi_test_2
   ```

2. **Get Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

---

## 📦 Libraries Used

| Package                    | Purpose                                                     |
|----------------------------|-------------------------------------------------------------|
| `flutter_bloc`             | State management using the BLoC pattern                     |
| `equatable`                | Simplifies equality comparisons for Dart objects            |
| `intl`                     | Date, number, and message formatting (internationalization) |
| `shared_preferences`       | Stores simple key-value pairs locally                       |
| `google_fonts`             | Enables the use of custom Google Fonts                      |
| `http`                     | Handles HTTP requests for APIs                              |
| `modal_bottom_sheet`       | Custom modal bottom sheet implementation                    |
| `loading_animation_widget` | Offers customizable loading animations                      |
| `fl_chart`                 | Draws interactive and animated charts                       |
| `animated_snack_bar`       | Shows animated snackbar notifications                       |

---

## 🧱 Reason for choosing BLoC

I chose BLoC for state management because it helps keep the app organized by separating the user
interface from the business logic. This makes the code easier to understand, test, and scale as the
app grows. BLoC also allows better control over how data flows in the app and makes it easier to
manage loading, error, and success states. It’s widely used in the Flutter community and has strong
support, which makes it a reliable choice for building apps that are clean, maintainable, and ready
for future updates.

Would you like me to update the README with this version?

## 🧱 Project Structure

The app follows a **clean architecture** structure to separate responsibilities:

```plaintext
lib/
├── bloc/
│   └── merchant/
│       ├── merchant_bloc.dart
│       ├── merchant_event.dart
│       └── merchant_state.dart
│   └── transactions/
│       ├── transaction_bloc.dart
│       ├── transaction_event.dart
│       └── transaction_state.dart
│
├── model/
│   └── merchant_model.dart
│   └── transaction_model.dart
├── repository/
│   └── repository.dart
│
├── res/
│   ├── apis.dart
│   ├── app_colors.dart
│   ├── app_enums.dart
│   ├── app_icons.dart
│   └── app_strings.dart
│
├── utils/
│   ├── app_navigator.dart
│   ├── app_utils.dart
│   └── custom_route.dart
│
├── views/
│   ├── app_screens/
│   │   ├── history_page_widgets/
│   │   │   ├── merchant_info_details.dart
│   │   │   ├── transaction_details.dart
│   │   │   └── transaction_history.dart
│   │   └── history_page.dart
│   │   └── merchant_page.dart
│   │
│   └── widget.dart/
│       ├── app_custom_text.dart
│       ├── app_loading_widget.dart
│       ├── app_spacer.dart
│       ├── dialog_box.dart
│       ├── form_button.dart
│       └── form_input.dart
│
└── main.dart
```

![Trabsaction Demo](assets/transactions.gif)