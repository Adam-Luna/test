# test
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
