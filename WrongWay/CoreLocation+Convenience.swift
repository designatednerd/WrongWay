//
//  CoreLocation+Convenience.swift
//  WrongWay
//
//  Created by Ellen Shapiro on 5/26/18.
//  Copyright © 2018 Designated Nerd Software. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

extension CLLocation {
  
  var placemark: MKPlacemark {
    return MKPlacemark(coordinate: self.coordinate)
  }
}

extension MKPlacemark {
  
  var mapItem: MKMapItem {
    return MKMapItem(placemark: self)
  }
}

extension MKPolyline {
  
  var coordinates: [CLLocationCoordinate2D] {
    var pointArray = [CLLocationCoordinate2D]()
    
    for i in 0..<pointCount {
      let range = NSRange(location: i, length: 1)
      var coordinate = kCLLocationCoordinate2DInvalid
      self.getCoordinates(&coordinate, range: range)
      
      pointArray.append(coordinate)
    }
    
    return pointArray
  }
  
 
  func closeEnough(to coordinate: CLLocationCoordinate2D) -> Bool {
    
    // OK this doesn't erally work with the earth but let's ignore that for now
    
    // 111 km per latitude degree
    let degreesPerKM: Double = 1.0/111.0
    let latitudeDeltaMustBeLessThan = degreesPerKM / 10.0
    
    
    for lineCoordinate in coordinates {
      let longitudeDifference = HaversineDistance.from(coordinate, to: lineCoordinate)
      let latitudeDelta = abs(coordinate.latitude - lineCoordinate.latitude)
      
      if longitudeDifference <= 100 // meters
        && latitudeDelta <= latitudeDeltaMustBeLessThan {
        return true
      } // else, keep going
    }
    
    // If you got here: Hot nope.
    return false
  }
  
}

extension CLLocationCoordinate2D: Equatable {
  
  public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude
      && lhs.longitude == rhs.longitude
  }
  
}
