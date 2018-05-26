//
//  Internets.swift
//  WrongWay
//
//  Created by Ellen Shapiro on 5/26/18.
//  Copyright © 2018 Designated Nerd Software. All rights reserved.
//

import Foundation

enum InternetsError: Error {
  case noResponseAndNoError(statusCode: Int?)
  case jsonDecodingFailed
  case couldntEncodeURL(string: String)
}

struct Internets {
  
  static func getData(from urlString: String,
                      success: @escaping (Data) -> Void,
                      failure: @escaping (Error) -> Void) -> URLSessionTask? {
    guard let url = URL(string: urlString) else {
      failure(InternetsError.couldntEncodeURL(string: urlString))
      return nil
    }
    
    let task = URLSession.shared.dataTask(with: url) {
      data, urlResponse, error in
      
      if let error = error {
        if let urlError = error as? URLError,
          urlError.errorCode == NSURLErrorCancelled {
            // The request was cancelled, don't call any  completion.
            return
        }
        
        DispatchQueue.main.async {
          failure(error)
        }
        return
      }
      
      if let data = data {
        DispatchQueue.main.async {
          success(data)
        }
        return
      }
      
      
      // We had no data and no error
      let internetsError = InternetsError.noResponseAndNoError(statusCode: (urlResponse as? HTTPURLResponse)?.statusCode)
      DispatchQueue.main.async {
        failure(internetsError)
      }
    }
      
    task.resume()
    
    return task
  }
}
