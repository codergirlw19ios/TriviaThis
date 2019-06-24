//
//  SettingsViewController.swift
//  TriviaThis
//
//  Created by johnekey on 6/17/19.
//  Copyright © 2019 johnekey. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

 
    
    @IBOutlet weak var difficultyPickerView: UIPickerView!
    @IBOutlet weak var categoryPickerView: UIPickerView!

    var triviaModel:  TriviaDataManager?
    
    let difficulty = ["any", "easy", "medium", "hard"]
    let categories = [Category(0, "Any"),
                      Category(9, "General Knowledge"), Category(10, "Entertainment: Books"),
                      Category(11, "Entertainment: Film"), Category(12, "Entertainment: Music"),
                      Category(13, "Entertainment: Musicals & Theatres"), Category(14, "Entertainment: Television"),
                      Category(15, "Entertainment: Video Games"), Category(16, "Entertainment: Board Games"),
                      Category(17, "Science & Nature"), Category(18, "Science: Computers"),
                      Category(19, "Science: Mathematics"), Category(20, "Mythology"),
                      Category(21, "Sports"), Category(22, "Geography"),
                      Category(23, "History"), Category(24, "Politics"),
                      Category(25, "Art"), Category(26, "Celebrities"),
                      Category(27, "Animals"), Category(28, "Vehicles"),
                      Category(29, "Entertainment: Comics"), Category(30, "Science: Gadgets"),
                      Category(31, "Entertainment: Japanese Anime & Manga"), Category(32, "Entertainment: Cartoon & Animations")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Trivia This!"
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        difficultyPickerView.delegate = self
        difficultyPickerView.dataSource = self
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == difficultyPickerView {
            triviaModel?.setSelectedDifficulty(difficulty: difficulty[row])
        } else {
            triviaModel?.setSelectedCategory(category: categories[row])
        }
        triviaModel?.resetGame()
    }
}

extension SettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // For each Picker, return the count of the items in the spinner
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == difficultyPickerView {
            return difficulty.count
        } else {
            return categories.count
        }
        
    }
    
    // For each Picker, for each row, return the name to put in the spinner
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == difficultyPickerView {
            return difficulty[row]
        } else {
            return categories[row].category
        }
        
    }
}
