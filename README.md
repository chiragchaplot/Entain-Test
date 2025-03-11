
# Entain Coding Test

Firstly, I think I loved working on this. Mainly helped me get a test of an app purely built in Swift 6, where XCode pretty much helped me solve concurrency issues. It helped me realise the potential of Swift concurrency and helped me realise that there is so much to learn even now. 

# Technical Details

I have built this with the following :- 

* XCode 16.2
* Minimum iOS Target as 18.0
* Swift Language Version - Swift 6
* SwiftUI
* Swift Testing

Please run it on latest XCode

Ensure you have SwiftLint Installed on your machine - use brew install swiftlint.


## Installation

Please run it on latest XCode

Ensure you have SwiftLint Installed on your machine - use 

```bash
brew install swiftlint
```

### Structure

I have used VIPER and Clean Architecture. The code is split into 3 layers

1. Data Layer - For now this is only network layer, but I would later prefer to put persistent data in this layer as well
2. Domain Layer - Model Objects and Consumer of Data Layer
3. Presentation Layer - I have used MVVM here.

# What I am super proud of

**As a blanket statement - I have heavily used dependency injections using protocols in my app. Each and every file including the views are testable and there are test cases for everything.**

### Network Layer

1. I was meaning to create a reusable `networkmanager` which would be consumed by all API objects. I created this using async/await and leveraged Swift Concurrency. I have created unit tests for this.
2. Creating API Requests is all a dev will need to do to consume this

#### Where I would improve it
1. I would add timeouts to it to API calls
2. I would add status handling
3. I would extend it to have retry the call upon 500 errors

### Domain Layer
This is more of a service layer. Connecting the presentation layer and data layer. I have created unit tests for this as well.
#### Where I would improve it
I would really want to add more properties here. I would want to ensure I am using secondary actors here, not main actors. These calls need to be on background thread only.

### Presentation Layer

**I have used MVVM**

I further created certain reusable elements - like **custom tool bar** which is used in navigation bar. 
1. Overall there isn't much to the presentation layer as it has a simple Splash Screen which leads to a List View. 
2. The presentation item for list view is another custom view. 
3. There are unit tests for all viewModels here. 
4. The viewModel makes the API call and handles the filtering of races

#### Where would I improve it?

1. The Race Filter View - I couldn't make the overlay work as in it was not interactable. Hence, I dropped the idea. Used a sheet instead. Looks ugly but the filtering works. I ended up spending 45 minutes on this and lost all the time I was meant to work on this project. 
2. The last requirement i.e. *As a user, I should always see 5 races and data should automatically refresh*. I ran out of time and wanted to submit this project. 
3. I want to play more with actors and interactors for continuous update.
4. I would add a veiwModel for the splashscreen where I would check for internet and jailbreak
