# Entain Coding Test

## Overview
This project demonstrates a Swift 6 app built using SwiftUI and following VIPER and Clean Architecture principles. It showcases modern Swift concurrency patterns and comprehensive testing.

## Technical Stack
- XCode 16.2
- iOS 18.0+ target
- Swift 6
- SwiftUI
- Swift Testing
- SwiftLint

## Installation
```bash
# Ensure you have SwiftLint installed
brew install swiftlint

# Open the project in XCode 16.2+
```

## Architecture
The codebase follows a three-layer architecture:

1. **Data Layer**
   - Network layer with async/await Swift concurrency
   - Designed for future expansion to include persistence

2. **Domain Layer**
   - Model objects
   - Service layer connecting presentation and data layers
   - Background thread processing with actors

3. **Presentation Layer**
   - MVVM pattern
   - Reusable UI components (custom toolbar, list items)
   - Race filtering functionality

## Key Features
- **Dependency Injection** throughout the app using protocols
- **Comprehensive Testing** for all components including views
- **Reusable Network Manager** leveraging Swift Concurrency
- **Custom UI Components** for better maintainability
- **Automated Race Updates** keeping 5 races visible at all times

## Implementation Details

### Network Layer
The network manager uses Swift Concurrency with async/await for API calls. Developers only need to create API request objects to utilize this layer.

### Domain Layer
Acts as a service layer connecting presentation and data layers, implemented with secondary actors to ensure background thread processing.

### Presentation Layer
Implements MVVM with custom views and thorough unit tests. The race filtering system allows users to filter races by category with automatic data refresh.

## Development Notes
This project was a great opportunity to explore Swift 6's concurrency features and XCode's assistance with solving concurrency issues, highlighting the powerful potential of modern Swift development.