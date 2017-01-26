//
//  Choice.swift
//  Brain Teaser
//
//  Created by Muhammad Moaz on 1/25/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

struct Choice {
    private (set) var id: Int?
    private (set) var choice: String?
    private (set) var isCorrect: Bool?
    
    init(dictionary: [String: AnyObject]) {
        if let id = dictionary["id"] as? Int {
            self.id = id
        }
        
        if let choice = dictionary["choice"] as? String {
            self.choice = choice
        }
        
        if let isCorrect = dictionary["isCorrect"] as? Bool {
            self.isCorrect = isCorrect
        }
    }
}

extension Choice: Equatable {
    static func == (lhs: Choice, rhs: Choice) -> Bool {
        return lhs.id == rhs.id && lhs.choice == rhs.choice
            && lhs.isCorrect == rhs.isCorrect
    }
}
