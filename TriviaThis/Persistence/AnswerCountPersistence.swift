//
//  TriviaAnswerPersistence.swift
//  TriviaThis
//
//  Created by johnekey on 6/19/19.
//  Copyright © 2019 johnekey. All rights reserved.
//

import Foundation

class AnswerCountPersistence: Persistence {
    
    // read JSON from file
    func readAnswerCount() -> AnswerCount? {
        return super.read()
    }
    
    // write JSON to file
    func writeAnswerCount(_ item: AnswerCount) {
        super.write(item)
    }
    
}
