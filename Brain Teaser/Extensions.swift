//
//  Extensions.swift
//  Brain Teaser
//
//  Created by Muhammad Moaz on 1/27/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffle() {
        for _ in 0..<(count - 1) {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
