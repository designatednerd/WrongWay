# WrongWay
A project for https://stupidhackath.no/

This project started here: 

![](post_it_small.jpg)

And ended here (heads up: NSFW language, you might want put your headphones on): 

[![Stupid Hackathon Video](https://img.youtube.com/vi/VR4cF1ixGMo/0.jpg)](https://www.youtube.com/watch?v=VR4cF1ixGMo "Stupid Hackathon Video")



## If you actually want to run this

You'll notice that the `APIKeys.swift` file is missing, because apparently now Google is going to start billing people for maps and places API use. 

To fix this, make your own `APIKeys.swift` and replace the contents with: 

```swift
import Foundation

enum APIKey: String {
  case GoogleMaps = "YOUR_GOOGLE_MAPS_API_KEY"
}
```

replacing `YOUR_GOOGLE_MAPS_API_KEY` with...your Google Maps API key. 
