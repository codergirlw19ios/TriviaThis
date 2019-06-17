//
//  BasicJsonURLNetwork.swift
//  TriviaThis
//
//  Created by johnekey on 6/11/19.
//  Copyright © 2019 johnekey. All rights reserved.
//

import Foundation
import UIKit



class BasicJsonURLNetork<T>: URLNetworkProtocol where T: Decodable{
    var baseURL: String = ""
    var mimeType: String = "application/json"
    typealias ResultType = T
    
    init(baseURL: String, _ mimeType: String = "application/json")
    {
        self.baseURL = baseURL
        self.mimeType = mimeType
    }
    
    // result is the completion handler for BasicJsonURLNetwork
    func result(from data: Data) -> T? {
        guard let result = try? JSONDecoder().decode(T.self, from: data) else
        {
            return nil
        }
        
        return result
    }
}
