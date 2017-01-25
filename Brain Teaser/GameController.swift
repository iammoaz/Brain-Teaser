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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func choiceButtonTapped(sender: UIButton) {
        
    }

}
