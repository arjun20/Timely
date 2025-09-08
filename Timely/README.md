# Timely 📅

A beautiful, ADHD-friendly iOS app that helps small groups of friends quickly find overlapping free times in their Apple Calendars and confirm events to meet up.

## ✨ Features

- **🎯 Event Card Selection**: Choose from curated activity cards (Coffee Chat, Workout, Study Group, etc.)
- **⏰ Smart Time Finding**: Automatically finds overlapping free times across everyone's calendars
- **📱 Beautiful UI**: Clean, minimal design with playful animations and ADHD-friendly UX
- **🎉 Easy Confirmation**: Simple event creation and calendar integration
- **🔔 Haptic Feedback**: Delightful tactile responses for better user experience

## 🏗️ Architecture

Built with clean, modular architecture using:

- **MVVM Pattern**: Separation of concerns with ViewModels managing business logic
- **SwiftUI**: Modern declarative UI framework
- **EventKit**: Apple Calendar integration
- **Modular Design**: Easy to expand and maintain

### Project Structure

```
Timely/
├── Models/           # Data models and structures
├── ViewModels/       # Business logic and state management
├── Views/            # SwiftUI views and components
│   ├── Components/   # Reusable UI components
│   └── ...
├── Services/         # External service integrations
├── Design/           # Design system (colors, typography, shadows)
└── Utils/            # Utilities and helpers
```

## 🎨 Design System

### Colors
- **Primary**: Timely Blue (#3399FF)
- **Secondary**: Timely Purple (#9966FF)
- **Success**: Timely Green (#33CC66)
- **Category Colors**: Unique colors for different event types

### Typography
- **Rounded Fonts**: Friendly, approachable typography
- **Clear Hierarchy**: Easy to scan and understand
- **Accessible**: High contrast and readable sizes

### Animations
- **Spring Animations**: Natural, bouncy feel
- **Gentle Transitions**: Smooth page changes
- **Micro-interactions**: Delightful button presses and selections

## 🚀 Getting Started

### Prerequisites
- Xcode 16.0+
- iOS 18.5+
- Apple Developer Account (for calendar permissions)

### Installation

1. Clone the repository
2. Open `Timely.xcodeproj` in Xcode
3. Build and run on simulator or device

### Calendar Permissions

The app requires calendar access to:
- Read existing events
- Find available time slots
- Create new events

## 🏪 App Store Ready Features

### ✅ Core Functionality
- **Smart Calendar Integration** - Reads and creates calendar events
- **Event Card Selection** - Curated activities with beautiful UI
- **Time Slot Detection** - Automatically finds available times
- **Event Creation** - One-tap calendar event creation
- **Attendee Management** - Add friends to events

### ✅ App Store Requirements
- **Info.plist** - Proper permissions and metadata
- **Error Handling** - Comprehensive error management
- **Accessibility** - Full VoiceOver and Dynamic Type support
- **Data Persistence** - User preferences and event history
- **Performance** - Optimized memory usage and loading
- **Localization** - Ready for multiple languages
- **Unit Tests** - Core functionality testing

### ✅ User Experience
- **ADHD-Friendly Design** - Clear, minimal interface
- **Haptic Feedback** - Delightful tactile responses
- **Smooth Animations** - Spring-based transitions
- **Settings Panel** - Customizable preferences
- **Empty States** - Helpful guidance when no times available
- **Progress Indicators** - Clear step-by-step flow

## 🔧 Configuration

### Airtable Integration

To connect with Airtable for event cards:

1. Create an Airtable base with event cards
2. Get your Base ID and API Key
3. Update `AirtableService.swift`:
   ```swift
   private let baseID = "YOUR_BASE_ID"
   private let apiKey = "YOUR_API_KEY"
   ```

### Event Card Structure

Your Airtable should have these fields:
- `title` (Single line text)
- `description` (Long text)
- `category` (Single select: Social, Fitness, Education, etc.)
- `estimatedDuration` (Number)
- `suggestedTimes` (Multiple select: morning, afternoon, evening)
- `location` (Single line text)
- `emoji` (Single line text)

## 🎯 ADHD-Friendly Features

- **Clear Visual Hierarchy**: Easy to scan and understand
- **Minimal Cognitive Load**: One task at a time
- **Visual Feedback**: Clear selection states and progress indicators
- **Gentle Animations**: Not overwhelming or distracting
- **Haptic Feedback**: Tactile confirmation of actions
- **Error Prevention**: Clear validation and helpful error messages

## 🔮 Future Enhancements

- **Multi-user Support**: Real-time collaboration
- **Custom Event Cards**: User-created activities
- **Smart Suggestions**: AI-powered time recommendations
- **Recurring Events**: Weekly/monthly meeting support
- **Location Integration**: Find nearby venues
- **Notification System**: Reminders and updates

## 🤝 Contributing

This is a Phase 1 MVP focused on core scheduling functionality. The architecture is designed to be easily expandable for future features.

## 📄 License

Private project - All rights reserved.

---

Built with ❤️ for better scheduling and more time with friends.
