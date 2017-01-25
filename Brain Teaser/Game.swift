//
//  Game.swift
//  Brain Teaser
//
//  Created by Muhammad Moaz on 1/25/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

struct Game {
    
    private (set) var questions: [Question] = []
    private (set) var correctlyAnweredQuestions: [Question] = []
    private (set) var wronglyAnweredQuestions: [Question] = []
    
    init() {
        self.questions.removeAll()
        self.correctlyAnweredQuestions.removeAll()
        self.wronglyAnweredQuestions.removeAll()
        DataService.instance.fetch { (objects) in
            if let objects = objects {
                for question in objects.questions {
                    self.questions.append(question)
                }
            }
        }
    }
    
    mutating func checkAnswer(for title: String, at index: Int, completion: @escaping (Bool) -> Void) {
        let question = self.questions[index]
        let choices = question.choices
        for choice in choices {
            if title == choice?.choice, choice?.isCorrect == true {
                self.correctlyAnweredQuestions.append(question)
                completion(true)
            } else if title == choice?.choice, choice?.isCorrect == false {
                self.wronglyAnweredQuestions.append(question)
                completion(false)
            }
        }
    }
    
}
