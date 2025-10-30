# Flutter Pizza Ordering App 🚀
## CEP FILE
 Link to Download CEP
You can download the complete **Course End Project (CEP) Report** for this mobile application from the root of this repository:

[📘 MAD CEP.pdf](./MAD_CEP.pdf)

## 📖Overview
This is a mobile application built with Flutter that allows users to browse a pizza menu, customize their orders (size and quantity), add items to a cart, proceed to checkout, and view past order history.
The app uses sqflite for local database management to store menu items, cart details, and order history.

## ✨ Features

### Pizza Menu:
Displays a list of available pizzas with names, descriptions, and base prices.
(Implemented in home_screen.dart)

### Item Customization:
Allows users to select size (Small, Medium, Large) and quantity for each pizza, with dynamic price calculation.
(Implemented in pizza_details_screen.dart)

### Shopping Cart:
Users can add items to a persistent cart, view the total price, and remove individual items.
(Implemented in cart_screen.dart)

### Checkout Process:
Includes a form to enter customer details (name, address, phone) before placing the final order.
(Implemented in checkout_screen.dart)

### Order History:
Displays all past placed orders for user reference.
(Implemented in order_history_screen.dart)

### Local Database:
Uses sqflite to store pizzas, cart items, and orders locally.
(Implemented in database_helper.dart)

### 🛠️ Technology Stack
Component	Technology
Framework	Flutter
Language	Dart
Database	sqflite (Local persistence)
State Management	StatefulWidget (Basic local state management)

## ⚙️ Getting Started
🧩 Prerequisites
- Flutter SDK installed
- IDE (VS Code or Android Studio) with Flutter & Dart plugins

## 🔧 Installation
git clone 
cd flutter-pizza-corner-app
flutter pub get
flutter run
