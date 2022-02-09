//
//  HintProvider.swift
//  Wordle
//
//  Created by Gavin Ryder on 2/8/22.
//

import Foundation

extension String {
    // charAt(at:) returns a character at an integer (zero-based) position.
    // example:
    // let str = "hello"
    // var second = str.charAt(at: 1)
    //  -> "e"
    func charAt(at: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: at)
        return self[charIndex]
    }
}


struct HintProvider {
    var hint: [Character] = Array.init(repeating: "_", count: 5)
    private var solution = ""
    private var hintedIndices: [Int] = [0,1,2,3,4]
    private var hintsGiven = 0
    private let maxHints = 3
    
    init(solution: String) {
        self.solution = solution
    }
    
    mutating func provideHint() -> String {
        if (hintsGiven >= maxHints) {
            return String(hint)
        }
        let idx = hintedIndices.randomElement()
        hintedIndices.removeAll(where: {$0 == idx})
        hint[idx!] = solution.charAt(at: idx!)
        hintsGiven += 1
        return String(hint)
    }
    
    
}
