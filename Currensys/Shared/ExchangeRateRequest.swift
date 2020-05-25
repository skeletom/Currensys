//
//  ExchangeRateRequest.swift
//  Currensys
//
//  Created by Tomas Jelinek on 24/05/2020.
//  Copyright © 2020 Tomas Jelinek. All rights reserved.
//

import Foundation

enum NetworkError: Error {
  case unexpected, badURL, requestError
}

class ExchangeRateRequest {
  
  var task: URLSessionDataTask?
  
  func requestExchangeRate(baseCurrencyCode: String, destinationCurrencyCode: String, completion: @escaping (Result<Double, NetworkError>) -> Void) {
    
    let url = URL(string: "https://prepaid.currconv.com/api/v7/convert?q=\(baseCurrencyCode)_\(destinationCurrencyCode)&compact=ultra&apiKey=pr_47285c49a43f4874bef7d404bf82f294")
    guard let requestUrl = url else {
      completion(.failure(.badURL))
      return
    }
    
    print("Sending request url: \(requestUrl.absoluteString)")
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      
      guard error == nil, let data = data else {
        print("Request error \(String(describing: error?.localizedDescription))")
        completion(.failure(.requestError))
        return
      }
      
      
      do {
        if let results = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary, let rate: Double = results["\(baseCurrencyCode)_\(destinationCurrencyCode)"] as? Double {
          completion(.success(rate))
        } else {
          completion(.failure(.requestError))
        }
      } catch let error {
        print(error.localizedDescription)
        completion(.failure(.requestError))
      }
    }
    
    self.task = task
    task.resume()
  }
}
