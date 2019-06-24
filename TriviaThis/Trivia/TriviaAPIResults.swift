//
//  TriviaAPIData.swift
//  TriviaThis
//
//  Created by johnekey on 6/10/19.
//  Copyright © 2019 johnekey. All rights reserved.
//

import Foundation
import UIKit

protocol Query {
    func urlString() -> String
}

//  https://opentdb.com/api.php?amount=10
struct TriviaApiResults: Decodable {
    let response_code: Int
    let results: [TriviaResult]
}

struct TriviaResult: Decodable {
    let category: String
    let type: String
    let level: String  // one long comma separated string
    let question: String
    let correct: String
    let incorrect: [String]

    enum CodingKeys: String, CodingKey {
        case category = "category"
        case type = "type"
        case level = "difficulty"
        case question = "question"
        case correct = "correct_answer"
        case incorrect = "incorrect_answers"  // this is an array
    }
}
//{
//    "response_code": 0,
//    "results": [
//    {
//    "category": "Politics",
//    "type": "multiple",
//    "difficulty": "medium",
//    "question": "Who was the only president to not be in office in Washington D.C?",
//    "correct_answer": "George Washington",
//    "incorrect_answers": [
//    "Abraham Lincoln",
//    "Richard Nixon",
//    "Thomas Jefferson"
//    ]
//    },
//    {
//    "category": "Entertainment: Video Games",
//    "type": "multiple",
//    "difficulty": "medium",
//    "question": "In what engine was Titanfall made in?",
//    "correct_answer": "Source Engine",
//    "incorrect_answers": [
//    "Frostbite 3",
//    "Unreal Engine",
//    "Cryengine"
//    ]
//    },


//{
//    "response_code": 0,
//    "results": [
//    {
//        "category": "Entertainment: Video Games",
//        "type": "boolean",
//        "difficulty": "hard",
//        "question": "In &quot;The Sims&quot; series, the most members in a household you can have is 8.",
//        "correct_answer": "True",
//        "incorrect_answers": [
//        "False"
//        ]
//},
//{
//    "category": "Entertainment: Film",
//    "type": "boolean",
//    "difficulty": "medium",
//    "question": "There aren&#039;t any live-action clones in &quot;Star Wars: Episode III - Revenge of the Sith&quot;.",
//    "correct_answer": "True",
//    "incorrect_answers": [
//    "False"
//    ]
//},

struct TriviaQuery : Codable, Hashable, Query {
    
    let query: String
    // an comma separated list of ingredients
    var amount: Int
    var categoryID: Int
    var difficulty: String
    var type: String
    var encode: String
    
    init()
    {
        self.query = ""
        self.amount = 10
        self.categoryID = 0
        self.difficulty = ""
        self.type = ""
        self.encode = "url3986"
    }
    
    // Long string comma separated
    init(query: String, amount: Int, categoryID: Int, difficulty: String, type: String, encode: String)
    {
        self.query = query
        self.amount = amount
        self.categoryID = categoryID
        self.difficulty = difficulty
        self.type = type
        self.encode = encode
    }
    
    // query = http://recipepuppy.com/api/?i=onions,garic&q=omlet&p=3
    
    // ? begins query
    // amount begins number of returned questions
    // category begins one of  many categories
    // difficulty begins easy, medium or hard
    // type begins multiple or boolean
    // & sparages teh query parameters
    // query = https://opentdb.com/api.php?amount=10
    // query = https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple
    func urlString() -> String {
        var myString = String()
        
        myString = "?"
        myString += "amount="
        myString += "\(amount)"
        
        //If category is not ANY
        if categoryID != 0  {
            myString += "&"
            myString += "category=\(categoryID)"
        }
        if !difficulty.isEmpty {
            myString += "&"
            myString += "difficulty="
            myString += difficulty
        }
        if !type.isEmpty {
            myString += "&"
            myString += "type="
            myString += type
        }
        if !encode.isEmpty {
            myString += "&"
            myString += "encode="
            myString += encode
        }
        return myString
    }
}
