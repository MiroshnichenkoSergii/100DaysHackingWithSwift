//
//  PlayData.swift
//  Project39
//
//  Created by Sergii Miroshnichenko on 08.09.2022.
//

import Foundation

class PlayData {
    var allWords = [String]()
    private(set) var filteredWords = [String]()
    
//    var wordCounts = [String: Int]()
    var wordCounts: NSCountedSet!
    
    init() {
        if let path = Bundle.main.path(forResource: "plays", ofType: "txt") {
            if let plays = try? String(contentsOfFile: path) {
                allWords = plays.components(separatedBy: CharacterSet.alphanumerics.inverted)
                allWords = allWords.filter { $0 != "" }
                
//                for word in allWords {
//                    wordCounts[word, default: 0] += 1
//                }
//                allWords = Array(wordCounts.keys)
                
                wordCounts = NSCountedSet(array: allWords)
                
//                allWords = wordCounts.allObjects as! [String]
                let sorted = wordCounts.allObjects.sorted { wordCounts.count(for: $0) > wordCounts.count(for: $1) }
                allWords = sorted as! [String]
            }
        }
        applyUserFilter("swift")
//        filteredWords = allWords
    }
    
    func applyUserFilter(_ input: String) {
        if let userNumber = Int(input) {
            applyFilter { self.wordCounts.count(for: $0) >= userNumber }
        } else {
            guard input != "" else { return }
            applyFilter { $0.range(of: input, options: .caseInsensitive) != nil }
        }
    }
    
    func applyFilter(_ filter: (String) -> Bool) {
        filteredWords = allWords.filter(filter)
    }
}
