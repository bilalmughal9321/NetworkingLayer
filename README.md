# NetworkingLayer

A reusable Swift Package for API communication in iOS projects.
Supports both Alamofire+ObjectMapper and native URLSession — 
use whichever fits your project.

## Features

- Alamofire-based requests with ObjectMapper support
- Alamofire-based requests with Decodable support  
- Native URLSession with Decodable support
- Single object and array response handling
- Clean completion handler pattern
- Easy SPM integration

## Requirements

- iOS 14+
- Swift 5.5+
- Xcode 13+

## Dependencies

- [Alamofire](https://github.com/Alamofire/Alamofire)
- [ObjectMapper](https://github.com/tristanhimmelman/ObjectMapper)

## Installation

### Swift Package Manager


In Xcode:
1. File → Add Packages
2. Enter repository URL: https://github.com/bilalmughal9321/NetworkingLayer
3. Select version and add to your target

## Usage

### Alamofire + Decodable (Single Object)

```swift
NetworkManager.shared.requestDecodable(
    "https://api.example.com/user",
    method: .get,
    responseType: User.self
) { result in
    switch result {
    case .success(let user): print(user)
    case .failure(let error): print(error)
    }
}
```

### Alamofire + ObjectMapper (Array)

```swift
NetworkManager.shared.requestArray(
    "https://api.example.com/users",
    method: .get
) { (result: Result<[User], Error>) in
    switch result {
    case .success(let users): print(users)
    case .failure(let error): print(error)
    }
}
```

### URLSession (Decodable)

```swift
NetworkManager.shared.requestUrlSession(url) { 
    (result: Result<User, Error>) in
    switch result {
    case .success(let user): print(user)
    case .failure(let error): print(error)
    }
}
```

## Author

M. Bilal Mughal  
[linkedin.com/in/bilal-mughal-dev](https://www.linkedin.com/in/bilal-mughal-dev)
