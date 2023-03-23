//
//  ViewController.swift
//  WZH
//
//  Created by SD on 13/03/2023.
//

import UIKit



class ViewController: UIViewController {

    // MARK: - IB Outlets
    
    @IBOutlet weak var showQuestionLabel: UILabel!
    @IBOutlet weak var showAnswerLabel: UILabel!
    @IBOutlet weak var nextQuestionButton: UIButton!
    @IBOutlet weak var showAnswerButton: UIButton!
    
    @IBOutlet weak var categoriesSwitch: UISegmentedControl!

    
    // MARK: - Properties
    
    var currentIndex = 0
    var quizCategory: QuizCategory = .red
    
    // the array with all questions
    var quizQuestions: [QuizQuestion] = []
    var filteredQuestions: [QuizQuestion] = []
        
    // MARK: - Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // First, get the data from the local file (localQuizData)
        getLocalQuizData()
    }
    
//     MARK: - IB Actions
    
    @IBAction func showQuestionButton(_ sender: UIButton) {
        showAnswerLabel.text = quizQuestions[currentIndex].answer

        showAnswerButton.isEnabled = false
        nextQuestionButton.isEnabled = true
    }
    
    @IBAction func showNextQuestionButton(_ sender: UIButton) {
        updateQuestion()
        showAnswerLabel.text = ""

        showAnswerButton.isEnabled = true
        nextQuestionButton.isEnabled = true
        
        print("Show next question")
    }

    @IBAction func didTapShowAnswerButton(_ sender: UIButton) {
        updateAnswer()
    }
    
    
    @IBAction func changeCategory(_ sender: UISegmentedControl) {
        print("Category changed to: \(sender.selectedSegmentIndex)")

        switch sender.selectedSegmentIndex {
        case 0:
            quizCategory = .red
            currentIndex = 0
        case 1:
            quizCategory = .yellow
            currentIndex = 24
        case 2:
            quizCategory = .green
            currentIndex = 25
        case 3:
            quizCategory = .blue
            currentIndex = 0
        case 4:
            quizCategory = .orange
            currentIndex = 0
        default:
            quizCategory = .red
        }
        
        setQuizQuestions()
    }
    
    
    
    // MARK: - Functions
    
    func updateQuestion() {
        
        
        if currentIndex == filteredQuestions.count {
            currentIndex = 0
        }
//
        showQuestionLabel.text = filteredQuestions[currentIndex].question
        currentIndex += 1
        
        updateUI()
    }
    
    func updateAnswer() {
        showAnswerLabel.text = filteredQuestions[currentIndex].answer
    }

    func setupQuiz() {
        currentIndex = 0
        filteredQuestions = quizQuestions
        
        let currentQuestion = filteredQuestions[currentIndex]
        
        showQuestionLabel.text = currentQuestion.question
        showAnswerLabel.text = ""
        
        showAnswerButton.isEnabled = true
        nextQuestionButton.isEnabled = true
        
        updateUI()
    }
    
    func updateUI() {
        let currentQuestion = filteredQuestions[currentIndex]
        
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
        
        //JdJ
//        currentIndex = 0
        filteredQuestions = quizQuestions
        
        //let currentQuestion = filteredQuestions[currentIndex]
        
        showQuestionLabel.text = currentQuestion.question
        showAnswerLabel.text = ""
        print("Question number: \(currentIndex)")
        
        showAnswerButton.isEnabled = true
        nextQuestionButton.isEnabled = true
        //
        
        
        
        
        
    }
    
    func setQuizQuestions() {
        filteredQuestions = quizQuestions.filter({ question in
            question.category == quizCategory
        })
        
        updateUI()
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
