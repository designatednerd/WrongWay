//
//  GooglePlacesStatus.swift
//  WrongWay
//
//  Created by Ellen Shapiro on 5/26/18.
//  Copyright © 2018 Designated Nerd Software. All rights reserved.
//

import Foundation

enum GooglePlacesStatus: String, Codable {
  case OK
  case ZERO_RESULTS
  case OVER_QUERY_LIMIT
  case REQUEST_DENIED
  case INVALID_REQUEST
  case UNKNOWN_ERROR
}
