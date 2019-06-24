//
//  TriviaData.swift
//  TriviaThis
//
//  Created by johnekey on 6/11/19.
//  Copyright © 2019 johnekey. All rights reserved.
//

import Foundation
import UIKit


struct Category {
    let id: Int
    let category: String
    
    init(_ id: Int, _ category: String) {
        self.id = id
        self.category = category
     }
}
// This structure holds 1 answer, and whether or not it is the correct answer ( t/f)
// If the user selects this answer as the "correct" answer - we set checked to true
// We keep a randomized array of all of the answers for each question
struct TriviaAnswer {
    let answer: String   // either correct or incorrect Answer
    var checked: Bool    // should it be checked
    var isCorrect: Bool  // Is this the correct answer for the question
    
    init(answer: String, checked: Bool, isCorrect: Bool) {
        self.answer = answer
        self.checked = checked
        self.isCorrect = isCorrect
    }
}

class TriviaData {
    
    let category: String
    let type: String
    let level: String  // one long comma separated string
    let question: String
    let correct: String
    let incorrect: [String]
    var randomizedAnswers = [TriviaAnswer]()
    
    init(result: TriviaResult)
    {
        self.category = result.category
        self.type = result.type
        self.level = result.level
        self.question = result.question.removingPercentEncoding ?? ""
        self.correct = result.correct.removingPercentEncoding ?? ""
        self.incorrect = result.incorrect
        self.randomizedAnswers = doRandomization()
    }
    
    func doRandomization() -> [TriviaAnswer] {
        var triviaAnswer = [TriviaAnswer]()
        
        triviaAnswer.append(TriviaAnswer(answer: correct, checked: false, isCorrect: true))
        
        for wrongAnswer in incorrect {
             triviaAnswer.append(TriviaAnswer(answer: wrongAnswer.removingPercentEncoding ?? "", checked: false, isCorrect: false))
        }
       
        return triviaAnswer.shuffled()
        
    }
}
