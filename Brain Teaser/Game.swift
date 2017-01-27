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
                self.questions.shuffle()
            }
        }
    }
    
    mutating func checkAnswer(for title: String, at index: Int, completion: @escaping (Bool, Choice) -> Void) {
        let question = self.questions[index]
        let choices = question.choices
        
        let correctChoice = choices.first { choice in
            return choice!.isCorrect!
        }
        
        let usersChoice = choices.first { choice in
            return choice!.choice == title
        }
        
        if usersChoice! == correctChoice! {
            self.correctlyAnweredQuestions.append(question)
            completion(true, correctChoice!!)
        } else {
            self.wronglyAnweredQuestions.append(question)
            completion(false, correctChoice!!)
        }
    }
}
