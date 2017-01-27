//
//  Question.swift
//  Brain Teaser
//
//  Created by Muhammad Moaz on 1/25/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

struct Question {
    private (set) var id: Int?
    private (set) var question: String?
    private (set) var choices: [Choice?] = []
    
    init(dictionary: [String: AnyObject]) {
        if let id = dictionary["id"] as? Int {
            self.id = id
        }
        
        if let question = dictionary["question"] as? String {
            self.question = question
        }
        
        if let choices = dictionary["choices"] as? [Any] {
            for object in choices {
                let choice = Choice(dictionary: object as! [String: AnyObject])
                self.choices.append(choice)
            }
            self.choices.shuffle()
        }
    }
}
