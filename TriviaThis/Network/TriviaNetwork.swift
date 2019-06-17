//
//  TriviaNetwork.swift
//  TriviaThis
//
//  Created by johnekey on 6/11/19.
//  Copyright © 2019 johnekey. All rights reserved.
//

import Foundation
import UIKit

class TriviaNetwork: URLNetworkProtocol {
    typealias ResultType = String
    var baseURL: String = "https://opentdb.com/api.php"
    var mimeType: String
    
    // base class for recipepuppy is a URLNetwork ( fetch )
    private let network: BasicJsonURLNetork <TriviaApiResults>
    
    init()
    {
        self.network = BasicJsonURLNetork <TriviaApiResults>(baseURL: baseURL)
        self.mimeType = "application/json"
    }
    
    // interface / protocol version
    func result(from data: Data) -> String? {
        return nil
    }
    
    // overwritten version
    func result(from searchResult: TriviaApiResults?) -> [TriviaData]? {
        // results is an array of [TriviaResult]
        guard let results = searchResult?.results else {
            return nil
        }
        // for each TriviaResult -- instantiate a TriviaData Object using result
        return results.map { TriviaData(result: $0)}
    }
    // ? begins query
    // i begins comma separated list of ingredients
    // q begins the query string
    // p begins the page integer
    // & sparages teh query parameters
    // query = http://recipepuppy.com/api/?i=onions,garic&q=omlet&p=3
    //  The baseURL is appended in the URLNetwork fetch function
    func fetch(with query: TriviaQuery, completion: @escaping ([TriviaData]?) -> ()) {
        network.fetch(with: query) { [weak self] optionalRecipeSearchResult in completion(self?.result(from: optionalRecipeSearchResult))
        }
    }
}
