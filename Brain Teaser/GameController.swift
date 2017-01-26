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
    
    private var timer: Timer?
    private var timerCount: Int = 15
    
    private var game = Game()
    private var sound = Sound()
    private var currentQuestionNumber: Int = 0 {
        didSet {
            startTimer()
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
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
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
        
        guard timer != nil else {
            presentFeedbackLabels(to: false, result: "Oops..Times Up!", answer: "You answered \(numberOfCorrectlyAnsweredQuestions) out of \(totalNumberOfQuestions) questions correctly")
            dismissController()
            return
        }
        
        if numberOfCorrectlyAnsweredQuestions > numberOfWronglyAnsweredQuestions {
            presentFeedbackLabels(to: true, result: "Congratulations", answer: "You answered \(numberOfCorrectlyAnsweredQuestions) out of \(totalNumberOfQuestions) questions correctly")
        } else if numberOfCorrectlyAnsweredQuestions < numberOfWronglyAnsweredQuestions {
            presentFeedbackLabels(to: false, result: "Better Luck Next Time", answer: "You answered \(numberOfCorrectlyAnsweredQuestions) out of \(totalNumberOfQuestions) questions correctly")
        } else {
            presentFeedbackLabels(to: true, result: "There is a tie", answer: "You answered \(numberOfCorrectlyAnsweredQuestions) out of \(totalNumberOfQuestions) questions correctly")
        }
        
        dismissController()
    }
    
    func startTimer() {
        timerCount = 15
        timerLabel?.text = "\(timerCount)"
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        guard timer != nil else { return }
        timer?.invalidate()
        timer = nil
    }
    
    @objc func updateTimerLabel() {
        if timerCount > 0 {
            timerCount -= 1
            self.timerLabel?.text = "\(timerCount)"
        } else if timerCount == 0 {
            stopTimer()
            configureViewToDisplayFinalResult()
            sound.playIncorrectSound()
        }
        
        if timerCount > 5 {
            timerLabel?.textColor = Theme.correctAnswerColor
        } else {
            timerLabel?.textColor = Theme.wrongAnswerColor
        }
    }
    
    func dismissController() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    

    @IBAction func choiceButtonTapped(sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        toggleChoiceButtons(value: false)
        stopTimer()
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
