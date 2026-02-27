# InterView App - E-Commerce Flutter Application

A modern, cross-platform e-commerce application built with Flutter, featuring product browsing, search functionality, user authentication, and a polished UI with dark mode support.

## 📱 Features

### Core Features
- **Product Browsing** - Browse products across categories (All, Men's, Women's)
- **Real-time Search** - Filter products instantly as you type
- **Dark/Light Theme** - System-aware theme switching
- **User Authentication** - Login/Logout with token persistence
- **Product Details** - View detailed product information
- **Responsive UI** - Smooth animations and adaptive layouts
- **iOS-Optimized Design** - SF Pro typography, haptic feedback, Cupertino interactions

---

## 🏠 Home Screen Details

### Layout Structure
```
┌─────────────────────────────────┐
│     Collapsible Header          │
│  ┌─────────────────────────┐    │
│  │     Banner Section      │    │  ← Fades on scroll
│  │  "Today's Best Deals"   │    │
│  │   🔥 Hot Deals  👤      │    │
│  └─────────────────────────┘    │
│  ┌─────────────────────────┐    │
│  │  🔍 Search Bar    🎛️   │    │  ← Always visible
│  └─────────────────────────┘    │
├─────────────────────────────────┤
│  [All] [Men's] [Women's]        │  ← Sticky TabBar
├─────────────────────────────────┤
│  ┌──────────────────────────┐   │
│  │  Product Card            │   │
│  │  [img] Title  ❤️         │   │
│  │         $##.##  [Add]    │   │
│  └──────────────────────────┘   │
└─────────────────────────────────┘
```

### Components

| Component | Description |
|-----------|-------------|
| **Collapsible Header** | Expands to 220px, collapses to 72px with smooth animation |
| **Banner** | Gradient background with greeting, hot deals pill, user avatar |
| **Search Bar** | Real-time filtering, filter icon, avatar when collapsed |
| **Tab Bar** | Sticky category tabs (All, Men's, Women's) with orange indicator |
| **Product Card** | Image, category pill, title, rating, wishlist, price, add button |
| **Profile Sheet** | Bottom sheet with user info and sign out option |

### User Interactions

| Action | Result |
|--------|--------|
| Scroll down | Header collapses, banner fades out |
| Type in search | Products filter instantly across all tabs |
| Tap category tab | Switches product list |
| Tap product card | Navigate to product details with Hero animation |
| Tap wishlist ❤️ | Toggle favorite with scale animation + haptic feedback |
| Tap avatar | Open profile bottom sheet |
| Tap Sign Out | Clear token and navigate to login |
| Pull down | Refresh product list |

### Design Constants

```dart
kHeaderMax  = 220.0   // Expanded header height
kHeaderMin  = 72.0    // Collapsed header height
kSearchH    = 52.0    // Search bar height
kSearchPadV = 10.0    // Search bar vertical padding
kTabBarH    = 46.0    // Tab bar height
```

### Technical Highlights
- **State Management** - GetX for reactive state management
- **Clean Architecture** - Separation of concerns (Models, Views, Controllers, Services)
- **API Integration** - RESTful API consumption with HTTP package
- **Token Management** - Secure token storage with SharedPreferences
- **Network Aware** - Connectivity monitoring
- **Image Caching** - Efficient image loading with cached_network_image

## 🏗️ Project Structure

```
lib/
├── Controller/           # Business logic & state management
│   ├── Auth/            # Authentication controllers
│   ├── ProductController/  # Product management
│   ├── BottomMenuController/
│   └── NetworkService/
├── Models/              # Data models
│   ├── product_model/
│   └── user_model/
├── Views/               # UI screens & widgets
│   ├── Feature/
│   │   ├── Auth/        # Login, Register screens
│   │   ├── Home/        # Home screen with search & tabs
│   │   ├── ProductsDetails/
│   │   ├── Cards/
│   │   └── Splash_Screen/
│   └── Base/            # Reusable components
├── Services/            # External services
├── Utils/               # Utilities & constants
│   ├── AppColor/        # Color definitions
│   ├── AppIcons/        # Icon assets
│   ├── AppImage/        # Image assets
│   ├── AppConstant/     # API endpoints, constants
│   ├── Logger/          # Logging utilities
│   └── Token_Services/  # Token management
├── Helpers/             # Helper classes
│   └── route.dart       # Navigation routing
└── main.dart            # App entry point
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.10.8)
- Dart SDK
- Android Studio / VS Code
- Xcode (for iOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Rosdeb/InterView_APP.git
   cd InterView_App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   - Create a `.env` file in the project root
   - Add required environment variables (e.g., `BASE_URL`)

4. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `get` | State management & navigation |
| `flutter_dotenv` | Environment configuration |
| `http` | API requests |
| `shared_preferences` | Local storage |
| `cached_network_image` | Image caching |
| `flutter_svg` | SVG asset support |
| `shimmer` | Loading animations |
| `connectivity_plus` | Network monitoring |


## 🎨 Design System

### Colors
- **Primary**: `#FFFF6B00` (Orange accent)
- **Light Background**: `#FFF2F2F7`
- **Dark Background**: `#FF1C1C1E`
- **Light Card**: `#FFFFFFFF`
- **Dark Card**: `#FF2C2C2E`

### Typography
- **Font Family**: Inter
- **Weights**: Regular, SemiBold, Bold

## 🔧 Configuration

### Environment Variables (.env)
```env
BASE_URL=https://fakestoreapi.com
```

### API Endpoints
- Products: `/products`
- Products by Category: `/products/category/{category}`
- Product Details: `/products/{id}`
- Users: `/users/{id}`

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run with coverage
flutter test --coverage

# Integration tests
flutter test integration_test/
```

## 🏃 Build Commands

```bash
# Debug build
flutter build apk --debug

# Release build (Android)
flutter build apk --release

# Release build (iOS)
flutter build ios --release

# Web build
flutter build web
```

## 📄 License

This project is for demonstration/interview purposes.

## 👥 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

For issues and questions, please create an issue in the repository.

---

**Built with ❤️ using Flutter**
