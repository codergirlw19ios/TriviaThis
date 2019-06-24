//
//  TriviaDataManager.swift
//  TriviaThis
//
//  Created by johnekey on 6/17/19.
//  Copyright © 2019 johnekey. All rights reserved.
//

import Foundation
import UIKit

protocol TriviaDataManagerDelegate: class {
    func dataUpdated()
}

class TriviaDataManager {
    
    // Delegates
    // Notify view controller when data is updated
    weak var delegate: TriviaDataManagerDelegate?

    // Persistence
    var persistence = AnswerCountPersistence(filename: "TriviaAnswerCount")
    // Counters
    var answerCount =  AnswerCount()
    
    // API fetcher
    let triviaNetwork = TriviaNetwork()
    var triviaQuery = TriviaQuery(query: "", amount: 10, categoryID: 0, difficulty: "", type: "", encode: "url3986")

    
    // The fetch returns 10 Trivia Questions
    var questionIndex = 0 {
        didSet {
            // notify whoever is listening that we added data to this object
            self.delegate?.dataUpdated()
        }
    }
    var forceFetch = false
    var triviaDataList = [TriviaData]() {
        didSet {
            // notify whoever is listening that we added data to this object
            self.delegate?.dataUpdated()
        }
    }
    // first guess for this question
    var firstGuess = true
    
    init()
    {
        // When the manager is instantiated, read any saved data
        guard let ac = persistence.readAnswerCount() else {
            self.answerCount = AnswerCount()
            return
        }
        
        self.answerCount = ac
    }
    
    func fetchQuestions() {
        
        // Do we need to fetch new data or just iterate the list??
        if (triviaDataList.count == 0) || (questionIndex >= triviaDataList.count) || forceFetch == true {
            // call with triviaQuery so the correct verions of fetch is called
            triviaNetwork.fetch(with: (triviaQuery)){
                optionalTriviaArray in
                self.triviaDataList = optionalTriviaArray ?? [TriviaData]()
            }
            // reset the questionIndex
            questionIndex = 0
            // reset the forceFetch
            forceFetch = false
        } else {  // data is there -- go to next index
            questionIndex += 1
        }
        // This is the first guess for this question , so count the answer
        firstGuess = true
    }
    
    // get the question at the specified index
    func getQuestion() -> TriviaData? {
        
        if questionIndex >= 0 && questionIndex < triviaDataList.count {
            return triviaDataList[questionIndex]
        } else {
            return nil
        }
    }
    
    // returns the answer ( either correct or incorrect ) at specified index
    func getRandomizedAnswer( index: Int) -> TriviaAnswer? {
        guard let triviaData = getQuestion() else {
            return nil
        }
        return triviaData.randomizedAnswers[index]
    }
    
    // set the checkmark of the at the specified index
    func setCheckmark( index: Int) {
        
        guard let triviaData = getQuestion() else {
            return
        }
        
        // cycle thru all answers
        for i in 0..<triviaData.randomizedAnswers.count {
            // set the one they asked for to true, all else to false
            if (i == index) {
                triviaData.randomizedAnswers[i].checked = true
            } else {
                triviaData.randomizedAnswers[i].checked = false
            }
        }
    }
    

    
    // Is the answer the user selected the correct answer?
    func isAnswerCorrect()  -> Bool {
        
        guard let triviaData = getQuestion() else {
            return false
        }
        
        for triviaAnswer in triviaData.randomizedAnswers {
            // Is this the answer that the user selected as the "correct" answer?
            if triviaAnswer.checked == true {
                // is this actually the correct answer?  T/F
                return triviaAnswer.isCorrect
            }
        }
        
        return false
    }
    
    // Counter related functions
    func adjustCounter(correctAnswer: Int, incorrectAnswer: Int) {
        // update the data
        answerCount.adjustCounter(correctAnswer: correctAnswer, incorrectAnswer: incorrectAnswer)
        // write the data to the file
        persistence.writeAnswerCount(answerCount)
    }
    
    func getCorrectCount() -> String {
        let count = answerCount.totalCorrect
        return "\(count)"
    }
    func getIncorrectCount() -> String {
        let count = answerCount.totalIncorrect
        return "\(count)"
    }
    
    func resetGame() {
        answerCount.reset()
        questionIndex = 0
        triviaDataList.removeAll()
        // first guess for this question
        firstGuess = true
        forceFetch = false
        // write the data to the file
        persistence.writeAnswerCount(answerCount)
        // notify whoever is listening that we modified data to this object
        self.delegate?.dataUpdated()
    }
    
    func resetCounters() {
        answerCount.reset()
        // write the data to the file
        persistence.writeAnswerCount(answerCount)
        // notify whoever is listening that we added data to this object
        self.delegate?.dataUpdated()
    }
    
    // get the number of incorrect + correct answers
    func getAnswerCount() -> Int {
        
        guard let triviaData = getQuestion() else {
            return 0
        }
        // There are 1 or more incorrect answers and only 1 correct answer
        return triviaData.incorrect.count + 1
    }
    
    // set the query difficulty leve
    func setSelectedDifficulty(difficulty: String) {
        triviaQuery.difficulty = difficulty
        // indicate that a new fetch is needed
    }
    
    func setSelectedCategory(category: Category) {
        triviaQuery.categoryID = category.id
        // indicate that a new fetch is needed
    }
}
