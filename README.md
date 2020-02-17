# Nearby Photos

Nearby Photos is a simple app that displays 20 photos that were uploaded to Flickr in your area.

## Installation
1. `git clone git@github.com:fragginAJ/CodeSample.git`
2. `pod install`
3. Request a Flickr API key from the code owner or supply your own. 

    Make a copy of `Config.sample.xcconfig` and name it `Config.xcconfig`. Add it to the project, update `FLICKR_API_KEY` with your key, and set the new file as the project's configuration file. We do this because `Config.xcconfig` has been added to the `gitignore`, which prevents API keys from ever being committed!
    
    (Alternatively, you can just set `FLICKR_API_KEY` in the `Config.sample.xcconfig` file to get going.)
    
    ![Config](https://github.com/fragginAJ/CodeSample/blob/master/DocumentationAssets/configMenu.png?raw=true "Config")
4. Set build device to be a simulator so we don't have to deal with code signing.

    Set the simulator location (or not!).

5. Run
---

## Functionality

![Demo](https://github.com/fragginAJ/CodeSample/blob/master/DocumentationAssets/sampleDemo.gif?raw=true "Demo")

The app attempts to get the device location before searching Flickr for photos uploaded in the vicinity. It will default to trending photos in the absence of a location.

While searching for a location and/or photos, activity is indicated via a pulsing animation. After obtaining coordinates, the locator button's title updates to the reverse geocoded name of the location. 

Photos appear in an endless carousel that always snaps to center on one image. Each image is scaled up in size as it nears the center point of the screen, drawing additional attention to it.

If an image is tapped, it will center in the carousel and a modal will be presented that displays a high resolution version of the image. Users may zoom or pan across the image with pinch and swipe gestures.

--- 

## Architecture and Philosophies

The data layer is written with simplicity and testing in mind. With AlamoFire as a base, a Provider pattern has been implemented, affording us the ability to supply mock clients for unit testing or even a live client for integration testing. See `FlickrPhotoTests.swift`

`JSONDecoder` and the `Decodable` protocol are used to map the JSON received from the FLickr API into `FlickrPhoto` instances.

MVVM is employed in the main experience of the app, tying the `LocatorViewController` to the data layer through its `LocatorViewModel` partner. The view model reports back to the view controller when it has completed its asynchronous responsibilites.

Protocols are used to enforce consistent behavior across view controllers with the `ViewBuilder` and `InteractionResponder`, and API endpoint structure with `Endpoint`.
