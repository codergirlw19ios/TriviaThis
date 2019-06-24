//
//  TriviaViewController.swift
//  TriviaThis
//
//  Created by johnekey on 6/11/19.
//  Copyright © 2019 johnekey. All rights reserved.
//

import UIKit

class TriviaViewController: UIViewController {

    
    var triviaModel:  TriviaDataManager?
    
    @IBOutlet weak var incorrectCountLabel: UILabel!
    @IBOutlet weak var correctCountLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var triviaTableView: UITableView!
    
 
    // There are 10 questions fetched each time.  Do we get new data or do we iterate to next question?
    @IBAction func getNextQuestion(_ sender: Any) {
    
        guard triviaModel != nil else {
            return
        }
        
        triviaModel?.fetchQuestions()
        
    }
    @IBAction func newGameTapped(_ sender: Any) {
         triviaModel?.resetGame()
    }
    override func viewDidAppear(_ animated: Bool) {
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Trivia This!"
        triviaTableView.dataSource = self
        triviaTableView.delegate = self
        // MARK TriviaDataManagers delegate listener is the TriviaViewController
        triviaModel?.delegate = self
        correctCountLabel.text = triviaModel?.getCorrectCount()
        incorrectCountLabel.text = triviaModel?.getIncorrectCount()
    }
    
    // If this is the first guess for this question, then update the counters
    // else, let the user guess and be told which is correct/incorrect without counting
    func updateCounters() {
        
        if triviaModel!.firstGuess {
            
            if triviaModel?.isAnswerCorrect() ?? false {
                
                triviaModel?.adjustCounter(correctAnswer: 1, incorrectAnswer: 0 )
                correctCountLabel.text = triviaModel?.getCorrectCount()
                
                //            let alert = UIAlertController(title: "Correct!", message: "You are sooo SMART!", preferredStyle: .alert)
                //
                //            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                //            self.present(alert, animated: true)
            }
            else {
                triviaModel?.adjustCounter(correctAnswer: 0, incorrectAnswer: 1 )
                incorrectCountLabel.text = triviaModel?.getIncorrectCount()
                //            let alert = UIAlertController(title: "Wrong Answer :(", message: "Try again, or get a new question.", preferredStyle: .alert)
                //
                //            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                //            self.present(alert, animated: true)
            }
        }
        
    }
    
}

extension TriviaViewController: TriviaDataManagerDelegate {
    func dataUpdated() {
        // triggered when we:
        //  1 get a new question - either from fetch or iterating list
        //  2 reset game - so counters go back to zero
        questionLabel.text = triviaModel?.getQuestion()?.question
        correctCountLabel.text = triviaModel?.getCorrectCount()
        incorrectCountLabel.text = triviaModel?.getIncorrectCount()
        
        triviaTableView.reloadData()
    }
    
    
}

////////////////////////   Table Functions /////////////////////////////////////////
extension TriviaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // handle selecting a row for editing
    
    // returns the table cell at the specified row
    guard let cell = triviaTableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as? TriviaTableViewCell else {
            return
        }
    // Update the model with the selected row and checkmark
    triviaModel?.setCheckmark(index: indexPath.row)
    // update the counters
    updateCounters()
    // set the firstGuess to false
    triviaModel?.firstGuess = false
    // call to reloadTable -- read the model and set cell appropriately
    triviaTableView.reloadData()
    }
}

extension TriviaViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // all incorrect/correct answers
        if section == 0 {
            guard let answerCount = triviaModel?.getAnswerCount() else {
                return 0
            }
            return answerCount
        } else if section == 1 {
            return 1
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = triviaTableView.dequeueReusableCell(withIdentifier: "TriviaCellID", for: indexPath) as? TriviaTableViewCell else {
                return UITableViewCell()
            }
            
            guard let triviaAnswer = triviaModel?.getRandomizedAnswer(index: indexPath.row) else {
                return UITableViewCell()
            }
            cell.textLabel?.text = triviaAnswer.answer
            cell.accessoryType =  triviaAnswer.checked ? .checkmark : .none
            
            if triviaAnswer.checked {
                if triviaModel!.isAnswerCorrect() {
                    cell.backgroundColor = UIColor.green
                } else {
                    cell.backgroundColor = UIColor.red
                }
            } else {
                cell.backgroundColor = UIColor.white
            }
            
            return cell
        }
        else if indexPath.section == 1 {
            let cell = triviaTableView.dequeueReusableCell(withIdentifier: "demoSection", for: indexPath)
            cell.textLabel?.text = "hello"
            cell.detailTextLabel?.text = "laurie"
            
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "grocery items"
//        } else if section == 1 {
//            return "section title example"
//        }
        
        return nil
    }
    
}


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


