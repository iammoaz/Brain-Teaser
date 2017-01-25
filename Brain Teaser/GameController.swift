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
    private var currentQuestionNumber: Int = 0 {
        didSet {
            configureView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentQuestionNumber = 0
    }
    
    func configureView() {
        hideFeedbackLabels()
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

    @IBAction func choiceButtonTapped(sender: UIButton) {
        
    }

}
