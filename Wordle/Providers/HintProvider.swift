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
    var hintsGiven = 0
    let maxHints = 3
    var hasHinted = false
    var tooClose = false
    
    mutating func setIndiceOfHintWithChar(idx: Int, char: Character) {
        hint[idx] = char
    }
    
    mutating func removeIndiceFromHintableIndices(_ removingIndex: Int) {
        hintedIndices.removeAll(where: { hintableIndex in hintableIndex == removingIndex })
    }
    
    init(solution: String = "") {
        self.solution = solution
    }
    
    mutating func provideHint() -> String {
        if (tooClose) {
            return "Too close for a hint!"
        }
        
        if (hintsGiven >= maxHints) {
            return "Out of hints!"
        }
        
        guard let idx = hintedIndices.randomElement() else {
           return "No hint availible!" //array must be empty
        }
        
        hintedIndices.removeAll(where: {hintIndice in hintIndice == idx}) //remove the indice we are about to hint
        if (hintedIndices.count > 1) { //more than 1 availible after we remove the current one
            //will only give hints until you're missing 2 characters
            hint[idx] = solution.charAt(at: idx)
            hintsGiven += 1
            hasHinted = true
            return String(hint).uppercased().separate(every: 1, with: " ")
        } else { //only have 1 or chars left to guess correctly
            tooClose = true
            hintsGiven = maxHints
            return "Too close for a hint!"
        }
    }
    
    
}
