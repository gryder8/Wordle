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
    
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
    
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
    var hasHinted = false
    
    init(solution: String = "") {
        self.solution = solution
    }
    
    mutating func provideHint() -> String {
        if (hintsGiven >= maxHints) {
            return String(hint).uppercased().separate(every: 1, with: " ")
        }
        let idx = hintedIndices.randomElement()
        hintedIndices.removeAll(where: {$0 == idx})
        hint[idx!] = solution.charAt(at: idx!)
        hintsGiven += 1
        hasHinted = true
        return String(hint).uppercased().separate(every: 1, with: " ")
    }
    
    
}
