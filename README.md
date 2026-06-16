# NetworkingLayer

A lightweight Swift Package for clean, reusable API communication in iOS projects.

## Features

- Simple and clean API calling interface
- Supports GET, POST, PUT, DELETE methods
- Codable-based response parsing
- Error handling built-in
- Easy to integrate via Swift Package Manager (SPM)

## Requirements

- iOS 14+
- Swift 5.5+
- Xcode 13+

## Installation

### Swift Package Manager

In Xcode:
1. File → Add Packages
2. Enter the repository URL: https://github.com/bilalmughal9321/NetworkingLayer
3. Select version and add to your target

## Usage

```swift
// Make a GET request
NetworkManager.shared.request(
    endpoint: "https://api.example.com/users",
    method: .get,
    responseType: [User].self
) { result in
    switch result {
    case .success(let users):
        print(users)
    case .failure(let error):
        print(error)
    }
}
```

## Author

M. Bilal Mughal — [linkedin.com/in/bilal-mughal-dev](https://www.linkedin.com/in/bilal-mughal-dev)
