//
//  NetworkController.swift
//  SoFiCHallenge
//
//  Created by Work on 5/29/19.
//  Copyright © 2019 Giglioroninomicon. All rights reserved.
//

import Foundation
import UIKit

class NetworkController {
    
    // MARK: Properties
    static var limit: Int = 200
    
    enum HTTPMethod: String {
        case Get = "GET"
        case Put = "PUT"
        case Post = "POST"
        case Patch = "PATCH"
        case Delete = "DELETE"
    }
    
    static func performRequest(for url: URL,
                               httpMethod: HTTPMethod,
                               urlParameters: [String : String]? = nil,
                               body: Data? = nil,
                               completion: ((Data?, Error?) -> Void)? = nil) {
        
        // Build out entire URL
        
        let requestURL = self.url(byAdding: urlParameters, to: url)
        var request = URLRequest(url: requestURL)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        if String(describing: requestURL).range(of: "steampowered.com") != nil {
            NetworkController.decrementLimit()
        }
        
        // Create and "resume" (a.k.a. run) the task
        print(request)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //            print(response)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            completion?(data, error)
        }
        
        dataTask.resume()
    }
    
    static func url(byAdding parameters: [String : String]?,
                    to url: URL) -> URL {
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters?.compactMap({ URLQueryItem(name: $0.0, value: $0.1) })
        
        guard let url = components?.url else {
            fatalError("URL optional is nil")
        }
        return url
    }
    
    static func decrementLimit() {
        NetworkController.limit -= 1
        print(NetworkController.limit)
    }
}

