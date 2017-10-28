# LastFMKit
Objective-C wrapper for Last.fm API

## Installation with CocoaPods

Install cocoapods with the following command:

```bash
$ gem install cocoapods
```

#### Podfile

To integrate LastFMKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '7.0'

target 'TargetName' do
pod 'LastFMKit'
end
```

Then, run the following command:

```bash
$ pod install
```

### Installation with Carthage

Install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate LastFMKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "LastFMKit/LastFMKit"
```

Run `carthage` to build the framework and drag the built `LastFMKit.framework` into your Xcode project.

## Usage

### Setting Your API Information

The API information must be set every time the application starts. If you do not do this, an exception will be raised on any attempt to make calls to the wrapper. The best place to do this is  inside the `application:didFinishLaunchingWithOptions:` function in your **AppDelegate.m** file:

#### Objective-C:
```objective-c
[[LFMAuth sharedInstance] setApiKey:@"YOUR_API_KEY"];
[[LFMAuth sharedInstance] setApiSecret:@"YOUR_API_SECRET"];
```

#### Swift:
```swift
Auth.shared().apiKey = "YOUR_API_KEY"
Auth.shared().apiSecret = "YOUR_API_SECRET"
```


### Authenticating with Last.fm

Authentication need only be done once, but is required to make any authenticated calls to the API. The `LFMSession` object will be stored in the user's keychain and loaded on subsequent app launches.

#### Objective-C:
```objective-c
LFMAuth *sharedInstance = [LFMAuth sharedInstance];

if (!sharedInstance.userHasAuthenticated) {
  [sharedInstance getSessionWithUsername:@"USERNAME" password:@"PASSWORD" callback:^(NSError * _Nullable error, LFMSession * _Nullable session) {
      if (error != nil) {
        // Handle error
      } else {
        // Success
      }
  }];
}
```

#### Swift:
```swift
let shared = Auth.shared()

if !shared.userHasAuthenticated {
  shared.session(username: "USERNAME", password: "PASSWORD") { (error, session) in
    if let session = session {
      // Success
    } else if let error = error {
      // Handle error
    }
  }
}
```

## License

LastFMKit is released under the MIT license. See LICENSE for details.
