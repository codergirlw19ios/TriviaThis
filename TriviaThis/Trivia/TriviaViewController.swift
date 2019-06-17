//
//  TriviaViewController.swift
//  TriviaThis
//
//  Created by johnekey on 6/11/19.
//  Copyright © 2019 johnekey. All rights reserved.
//

import UIKit

class TriviaViewController: UIViewController {

    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var triviaTableView: UITableView!
    
    private let triviaNetwork = TriviaNetwork()
    let triviaQuery = TriviaQuery(query: "", amount: 10, category: "", difficulty: "", type: "")
    var triviaDataList = [TriviaData]() {
        didSet {
            // notify whoever is listening that we added data to this object
     //       self.delegate?.dataUpdated()
            questionLabel.text = getQuestion(index: 0)?.question
            triviaTableView.reloadData()
        }
    }
    
    @IBAction func getTriviaQuestion(_ sender: Any) {
    
        // call with triviaQuery so the correct verions of fetch is called
        triviaNetwork.fetch(with: triviaQuery){
            optionalTriviaArray in
            self.triviaDataList = optionalTriviaArray ?? [TriviaData]()
        }
    }
    
    @IBAction func submitAnswerTapped(_ sender: Any) {
        
        isAnswerCorrect(triviaData: triviaDataList[0])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Trivia This!"
        triviaTableView.dataSource = self
        triviaTableView.delegate = self
    }
    
    func getQuestion(index: Int) -> TriviaData? {
        
        if index >= 0 && index < triviaDataList.count {
            return triviaDataList[index]
        } else {
            return nil
        }
    }
    
    func getCorrectAnswer(triviaData: TriviaData) -> String {
            return triviaData.correct
    }
    
    func getInCorrectAnswers(triviaData: TriviaData) -> [String] {
        return triviaData.incorrect
    }
    
    func getRandomizedAnswer(triviaData: TriviaData, index: Int) -> TriviaAnswer {
        return triviaData.randomizedAnswers[index]
    }

    func setCheckmark(triviaData: TriviaData, index: Int) {
        
        for i in 0..<triviaData.randomizedAnswers.count {
            if (i == index) {
                triviaData.randomizedAnswers[i].checked = true
            } else {
                triviaData.randomizedAnswers[i].checked = false
            }
        }
    }

    func isAnswerCorrect(triviaData: TriviaData) {
        
        for triviaAnswer in triviaData.randomizedAnswers {
            if triviaAnswer.checked == true {
                if (triviaAnswer.isCorrect == true) {
                    let alert = UIAlertController(title: "Correct!", message: "You are sooo SMART!", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true)
                }
                else {
                    let alert = UIAlertController(title: "Wrong Answer :(", message: "Try again, or get a new question.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true)

                }
            }
        }
    }
    
    func getAnswerCount(triviaData: TriviaData) -> Int {
        // There are 1 or more incorrect answers and only 1 correct answer
        return triviaData.incorrect.count + 1
    }
}

extension TriviaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // handle selecting a row for editing
    // Update the model with the selected row and checkmark
    // call to reloadTable -- read the model and set cell appropriately
    
    // returns the table cell at the specified row
    guard let cell = triviaTableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as? TriviaTableViewCell else {
            return
        }

    setCheckmark(triviaData: triviaDataList[0], index: indexPath.row)
    triviaTableView.reloadData()
    }
}

extension TriviaViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // all items in our shopping list
        if section == 0 {
            guard let triviaData = getQuestion(index: 0) else {
                return 0
            }
            return getAnswerCount(triviaData: triviaData)
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
            
            let triviaAnswer = getRandomizedAnswer(triviaData: triviaDataList[0], index: indexPath.row)
            cell.textLabel?.text = triviaAnswer.answer
            cell.accessoryType =  triviaAnswer.checked ? .checkmark : .none
            
//            // title = trivia correct and incorrect names
//            if indexPath.row == 0 {
//                cell.textLabel?.text = getCorrectAnswer(triviaData: triviaDataList[0])
//            }
//            else
//            {
//                let incorrectAnswers = getInCorrectAnswers(triviaData: triviaDataList[0])
//                cell.textLabel?.text = incorrectAnswers[indexPath.row-1]
//           }
            
            
            // retrieve the grocery item for this index path
//            let groceryItem: GroceryItem? = model?.cartItemFor(row: indexPath.row)
//
//            cell.decorateCell(with: groceryItem)
//
            
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


