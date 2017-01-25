//
//  DataService.swift
//  Brain Teaser
//
//  Created by Muhammad Moaz on 1/25/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import Foundation

class DataService {
    static let instance = DataService()
    
    private let bundle: Bundle
    private let url: URL
    
    init() {
        self.bundle = Bundle(for: type(of: self))
        self.url = bundle.url(forResource: "data", withExtension: "json")!
    }
    
    func fetch(completion: @escaping (DataParser?) -> Void) {
        guard let data = try? Data(contentsOf: self.url) else { return }
        guard let json = try? JSONSerialization.jsonObject(with: data) as! [Any] else { return }
        let questions = DataParser(dictionary: json)
        completion(questions)
    }
}

struct DataParser {
    private (set) var questions: [Question] = []
    
    init(dictionary: [Any]?) {
        if let dictionary = dictionary {
            for object in dictionary {
                let question = Question(dictionary: object as! [String: AnyObject])
                self.questions.append(question)
            }
        }
    }
}
