//
//  GameController.swift
//  Brain Teaser
//
//  Created by Muhammad Moaz on 1/25/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import UIKit

class GameController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel?
    @IBOutlet weak var questionNumberLabel: UILabel?
    @IBOutlet weak var questionLabel: UILabel?
    @IBOutlet weak var choiceButtonOne: UIButton?
    @IBOutlet weak var choiceButtonTwo: UIButton?
    @IBOutlet weak var choiceButtonThree: UIButton?
    @IBOutlet weak var choiceButtonFour: UIButton?
    @IBOutlet weak var resultFeedbackLabel: UILabel?
    @IBOutlet weak var answerFeedbackLabel: UILabel?
    
    private var game = Game()
    private var sound = Sound()
    private var currentQuestionNumber: Int = 0 {
        didSet {
            configureView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentQuestionNumber = 0
        sound.playStartSound()
    }
    
    func configureView() {
        hideFeedbackLabels()
        toggleChoiceButtons(value: true)
        questionNumberLabel?.text = "Question \(currentQuestionNumber + 1) of \(game.questions.count)"
        
        let question = game.questions[currentQuestionNumber]
        self.questionLabel?.text = question.question!
        configureChoicesButton(for: question.choices.count)
    }
    
    func configureChoicesButton(for value: Int) {
        let question = game.questions[currentQuestionNumber]
        
        if question.choices.indices.contains(0), let firstChoice = question.choices[question.choices.startIndex] {
            self.choiceButtonOne?.setTitle(firstChoice.choice, for: .normal)
        } else {
            self.choiceButtonOne?.isEnabled = false
        }
        
        if question.choices.indices.contains(1), let secondChoice = question.choices[question.choices.startIndex + 1] {
            self.choiceButtonTwo?.setTitle(secondChoice.choice, for: .normal)
        } else {
            self.choiceButtonTwo?.isEnabled = false
        }
        
        if question.choices.indices.contains(2), let thirdChoice = question.choices[question.choices.startIndex + 2] {
            self.choiceButtonThree?.setTitle(thirdChoice.choice, for: .normal)
        } else {
            self.choiceButtonThree?.isEnabled = false
        }
        
        if question.choices.indices.contains(3), let forthChoice = question.choices[question.choices.startIndex + 3] {
            self.choiceButtonFour?.setTitle(forthChoice.choice, for: .normal)
        } else {
            self.choiceButtonFour?.isEnabled = false
        }
    }
    
    func hideFeedbackLabels() {
        self.resultFeedbackLabel?.isHidden = true
        self.answerFeedbackLabel?.isHidden = true
    }
    
    func presentFeedbackLabels(to value: Bool, result: String, answer: String) {
        self.resultFeedbackLabel?.isHidden = false
        self.answerFeedbackLabel?.isHidden = false
        
        self.resultFeedbackLabel?.text = result
        self.answerFeedbackLabel?.text = answer
        
        if value {
            self.resultFeedbackLabel?.textColor = Theme.correctAnswerColor
        } else {
            self.resultFeedbackLabel?.textColor = Theme.wrongAnswerColor
        }
    }
    
    func toggleChoiceButtons(value: Bool) {
        self.choiceButtonOne?.isEnabled = value
        self.choiceButtonTwo?.isEnabled = value
        self.choiceButtonThree?.isEnabled = value
        self.choiceButtonFour?.isEnabled = value
    }
    
    func hideChoiceButtons() {
        self.choiceButtonOne?.isHidden = true
        self.choiceButtonTwo?.isHidden = true
        self.choiceButtonThree?.isHidden = true
        self.choiceButtonFour?.isHidden = true
    }
    
    func hideLabels() {
        self.timerLabel?.isHidden = true
        self.questionNumberLabel?.isHidden = true
        self.questionLabel?.isHidden = true
    }
    
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.currentQuestionNumber += 1
        }
    }
    
    func configureViewToDisplayFinalResult() {
        hideLabels()
        hideChoiceButtons()
        
        let totalNumberOfQuestions = game.questions.count
        let numberOfCorrectlyAnsweredQuestions = game.correctlyAnweredQuestions.count
        let numberOfWronglyAnsweredQuestions = game.wronglyAnweredQuestions.count
        
        if numberOfCorrectlyAnsweredQuestions > numberOfWronglyAnsweredQuestions {
            presentFeedbackLabels(to: true, result: "Congratulations", answer: "You answered \(numberOfCorrectlyAnsweredQuestions) out of \(totalNumberOfQuestions) questions correctly")
        } else if numberOfCorrectlyAnsweredQuestions < numberOfWronglyAnsweredQuestions {
            presentFeedbackLabels(to: false, result: "Better Luck Next Time", answer: "You answered \(numberOfCorrectlyAnsweredQuestions) out of \(totalNumberOfQuestions) questions correctly")
        } else {
            presentFeedbackLabels(to: true, result: "There is a tie", answer: "You answered \(numberOfCorrectlyAnsweredQuestions) out of \(totalNumberOfQuestions) questions correctly")
        }
    }

    @IBAction func choiceButtonTapped(sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        toggleChoiceButtons(value: false)
        game.checkAnswer(for: title, at: currentQuestionNumber) { (success: Bool, correct:Choice) in
            if success {
                self.sound.playCorrectSound()
                self.presentFeedbackLabels(to: success, result: "Correct", answer: "Good Job")
            } else {
                self.sound.playIncorrectSound()
                self.presentFeedbackLabels(to: success, result: "Wrong", answer: "The Correct Answer is \(correct.choice!)")
            }
        }
        
        if currentQuestionNumber + 1 == game.questions.count {
            configureViewToDisplayFinalResult()
        } else if currentQuestionNumber + 1 < game.questions.count {
            loadNextRoundWithDelay(seconds: 2)
        }
    }

}
