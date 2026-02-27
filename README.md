# ChangaBot Fundraiser App

A fully API-integrated Flutter application for creating fundraisers and managing payment methods using the ChangaBot backend.

#  Features 

- Create Fundraisers
- Add Payment Methods
  - Bank
  - Paybill
  - Buy Goods (Till Number)
- Enum-based PaymentType handling
- REST API Integration
- Clean model architecture
- Type-safe Dart implementation

#  Tech Stack 

- Flutter
- Dart
- REST API
- JSON Serialization
- Enum Type Safety

#  API Endpoints Used 

- GET /banks
- POST /fundraisers
- POST /fundraisers/{id}/payment-methods

#  App Structure 

- Models
  - PaymentMethod
  - PaymentType (Enum)
- Screens
  - Create Fundraiser
  - Add Payment Method
- Services
  - API Integration

# Learning Highlights 

This project demonstrates:

- Handling Dart enums correctly
- Converting String → Enum safely
- Type-safe API integration
- Structured model-based architecture
- Clean separation of UI and logic

#  Future Improvements 

- Form validation improvements
- Error handling enhancement
- State management optimization
- UI polishing
- Deployment build

#  Author 

Lucy Mugure  
Flutter Developer | API Integration Enthusiast