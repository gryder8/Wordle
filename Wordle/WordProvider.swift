//
//  WordProvider.swift
//  Wordle
//
//  Created by Mischa Hildebrand on 17.01.22.
//

import Foundation



struct WordProvider {
    
    
    static var defaultWords: [String] = ["Table", "Chair", "Hello", "Happy", "Basic", "Llama"]
    static var hasLoadedFromJSON = false
    static var loadedWords = [String]()
    
    static func generateWord() -> String {
        self.loadLocalJSONWords().randomElement()!
    }
    
    
    static func loadLocalJSONWords() -> [String] {
        if (hasLoadedFromJSON) {
            return loadedWords
        }
        
        guard
          let url = Bundle.main.url(forResource: "wordle-words", withExtension: "json"),
          let data = try? Data(contentsOf: url)
        else {
            print("Error parsing local JSON!")
            return defaultWords
        }
        
        if let words = try? JSONDecoder().decode([String].self, from: data) {
            loadedWords = words
            hasLoadedFromJSON = true
            return loadedWords
        }
        return defaultWords
    }
    
}
