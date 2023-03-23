//
//  ViewController.swift
//  WZH
//
//  Created by Jeen de Jong on 14/02/2022.
//

// See example at: https://programmingwithswift.com/parse-json-from-file-and-url-with-swift/

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - IB Outlets
    
    @IBOutlet weak var showQuestionLabel: UILabel!
    @IBOutlet weak var showAnswerLabel: UILabel!
    @IBOutlet weak var nextQuestionButton: UIButton!
    @IBOutlet weak var showAnswerButton: UIButton!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    
    // MARK: - Properties
    
    var currentIndex = 0
    var categories = ["Taal", "Natuur", "Liedjes", "Allerlei", "Spreekwoorden"]
    // the array with all questions
    var quizQuestions: [QuizQuestion] = []
    
    // MARK: - Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
//        categoryPicker.backgroundColor = .blue
        
        // First, get the data from the local file (localQuizData)
        getLocalQuizData()
    }
    
    // MARK: - IB Actions
    
    @IBAction func showQuestionButton(_ sender: Any) {
        showAnswerLabel.text = quizQuestions[currentIndex].answer
        
        showAnswerButton.isEnabled = false
        nextQuestionButton.isEnabled = true
    }
    
    @IBAction func showNextQuestionButton(_ sender: Any) {
        updateQuestion()
        showAnswerLabel.text = ""

        showAnswerButton.isEnabled = true
        nextQuestionButton.isEnabled = false
    }

    
    // MARK: - Functions
    func updateQuestion() {
        currentIndex += 1
        
        if currentIndex == quizQuestions.count {
            currentIndex = 0
        }
        
        showQuestionLabel.text = quizQuestions[currentIndex].question
        
        updateUI()
    }
    
    func updateAnswer() {
        showAnswerLabel.text = quizQuestions[currentIndex].answer
    }

    func setupQuiz() {
        currentIndex = 0
        
        let currentQuestion = quizQuestions[currentIndex]
        
        showQuestionLabel.text = currentQuestion.question
        showAnswerLabel.text = ""
        
        showAnswerButton.isEnabled = true
        nextQuestionButton.isEnabled = false
        
        updateUI()
    }
    
    func updateUI() {
        let currentQuestion = quizQuestions[currentIndex]
        
        switch currentQuestion.category {
        case .red:
            showQuestionLabel.backgroundColor = .red
        case.green:
            showQuestionLabel.backgroundColor = .green
        case .blue:
            showQuestionLabel.backgroundColor = .blue
        case.yellow:
            showQuestionLabel.backgroundColor = .yellow
        case.orange:
            showQuestionLabel.backgroundColor = .orange
        }
    }
    
    // UIPickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1// 5 categorien
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
    inComponent component: Int) {
        let value = categories[row]
        print("Selected  category is: \(value)")
    }
   
    
    func getLocalQuizData() {
        // Call readLocalFile function with the name of the local file (localQuizData)
        if let localData = self.readLocalFile(forName: "localQuizData") {
            // File exists, now parse 'localData' with the parse function
            self.parse(jsonData: localData)
            
            setupQuiz()
        }
    }
    
    
    
    // Read local file
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            // Check if file exists in application bundle, then try to convert it to a string, if that works return that
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error) // Something went wrong, show an alert
        }
        
        return nil
    }
    
    private func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode([QuizQuestion].self,
                                                       from: jsonData)
            /*
            print("Question: ", decodedData[0].question)
            print("Answer: ", decodedData[0].answer)
            print("===================================")
            */
            
            self.quizQuestions = decodedData
        } catch {
            print("decode error")
        }
    }
}

