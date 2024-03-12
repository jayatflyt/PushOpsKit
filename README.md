# PushOpsKit
### A Swift package for communicating with the [Push Operations](https://www.pushoperations.com) application API. 

> **Warning**
> This is absolutely against the Push TOS. You will most likely get in trouble for using this from either Push or the App Store. You've been warned.

---
This package **does not** stay true to the existing Push Operations API. It is a Swift wrapper for the API that is much easier to use. Things are organized differently and some things are missing. There are going to be some points in the code that are a bit hacky, but it works. 

## To Do: 
- [x] Authentication
- [x] Get and organize shifts
- [x] Get and organize positions
- [ ] Add support for all API endpoints
- [ ] Add support for offering shifts
- [ ] More support for helper functions

### Things that can be improved:
- [ ] Better error handling
- [ ] Better documentation
- [ ] Better organization
- [ ] Better naming conventions
- [ ] Better organization and processing of data

## Usage:

### Getting Started
```swift
import PushOpsKit

// First get your auth token from Push
public func login(username: String, password: String) async throws {
    pushUserSettings = try await PushOps.auth(username: username, password: password)
    
    // Store the token somewhere. I use the `KeychainSwift` package here.
    keychain.set(pushUserSettings!.token, forKey: "token")

    push = try await PushOps(authKey: pushUserSettings!.token)
    authenticated = true
}

// -- or if you already have your token --

let push = try await PushOps(authKey: token!)
```
`auth` is a static function, use it to get the auth token and *then* initialize the PushOpsKit class with it.

### Getting Shifts
The current week's shifts as well as the available position data is retrieved as soon as the push object is initialized. The data is accessed via the public `companies` variable. My app accesses the data and organizes it using the built in `Utilities.sortShiftsByDate` method. 

```swift
// Keep a SwiftUI friendly copy of the data
self.pushCompanies = push!.companies

// Sort the shifts by date and store them in an array. Also to be used by SwiftUI
var allPositions: [Int: Position] = [:]
var allShifts: [Shift] = []
for company in pushCompanies!.values {
    allPositions = allPositions.merging(company.positions, uniquingKeysWith: { $1 })
    allShifts.append(contentsOf: company.schedules.values)
}
self.pushSchedules = Utilities.sortShiftsByDate(shiftsToSort: allShifts)
self.pushPositions = allPositions
```

---
## Things To Note:
- The `PushOps` class is a singleton. There should only be one instance of it at a time.
- The `PushOps` class is initialized with the auth token.
- Every Push user has Company ID data sent when they are logged in. 
    - This is handled by having a `Company` class for each company. They have internal refresh methods and should be considered self-contained beings.
    - There will eventually be a method to refresh all companies at once, but for now it's encouraged to do so individually to avoid slow server load times. 
- Most models are 1:1 representations of data sent over by the API, they are just moved around in the Company classes for better management and organization.

---
## Contributing:
If you want to contribute, feel free to open a PR. I'm not the best Swift developer, so I'm sure there are things that can be improved. The goal is for this package to be 100% Swift and have minimal dependencies.

---
