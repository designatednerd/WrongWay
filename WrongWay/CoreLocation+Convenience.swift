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
