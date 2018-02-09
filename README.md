# NSNotificationCenter-Demo
NSNotificationCenter in Swift 4: Intra-app communication, sending, receiving, listening, stop listening for messages.

This is pretty basic folks -- but still very important. In terms of communication and coordination between objects in your app, and age-old debate is whether to use delegation or messaging/notifications. I'll let you think about it.

Here’s the app we'll build:

![alt text][logo1]

[logo1]: http://iosbrain.com/wp-content/uploads/2018/02/SwiftDelegation.gif "App demonstrating notifications"

## Xcode 9 project settings
**To get this project running on the Simulator or a physical device (iPhone, iPad)**, go to the following locations in Xcode and make the suggested changes:

1. Project Navigator -> [Project Name] -> Targets List -> TARGETS -> [Target Name] -> General -> Signing
- [ ] Tick the "Automatically manage signing" box
- [ ] Select a valid name from the "Team" dropdown
  
2. Project Navigator -> [Project Name] -> Targets List -> TARGETS -> [Target Name] -> General -> Identity
- [ ] Change the "com.yourDomainNameHere" portion of the value in the "Bundle Identifier" text field to your real reverse domain name (i.e., "com.yourRealDomainName.Project-Name").

