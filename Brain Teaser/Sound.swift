//
//  Sound.swift
//  Brain Teaser
//
//  Created by Muhammad Moaz on 1/26/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import AudioToolbox
struct Sound {
    private var files: [String: SystemSoundID] = ["Introduction": 0, "Correct": 1, "Incorrect": 2]
    
    init() {
        for (file, var id) in files {
            let filePath = Bundle.main.path(forResource: file, ofType: "wav")
            let url = URL(fileURLWithPath: filePath!) as CFURL
            
            AudioServicesCreateSystemSoundID(url, &id)
            files[file] = id
        }
    }
    
    func playStartSound() {
        AudioServicesPlaySystemSound(files["Introduction"]!)
    }
    
    func playCorrectSound() {
        AudioServicesPlaySystemSound(files["Correct"]!)
    }
    
    func playIncorrectSound() {
        AudioServicesPlaySystemSound(files["Incorrect"]!)
    }
}
