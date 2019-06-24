//
//  TriviaAnswers.swift
//  TriviaThis
//
//  Created by johnekey on 6/19/19.
//  Copyright © 2019 johnekey. All rights reserved.
//

import Foundation
import UIKit


// struct that holds info to be displayed to the user

struct AnswerCount : Codable, Hashable {
    var totalTrys = 0
    var totalCorrect = 0
    var totalIncorrect = 0
    
    mutating func adjustCounter(correctAnswer: Int, incorrectAnswer: Int) {
        self.totalTrys += 1
        self.totalCorrect += correctAnswer
        self.totalIncorrect += incorrectAnswer
    }
    
    mutating func reset() {
        totalTrys = 0
        totalCorrect = 0
        totalIncorrect = 0
    }
}

