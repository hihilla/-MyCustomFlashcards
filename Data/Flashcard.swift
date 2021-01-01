//
//  flashcard.swift
//  MyCustomFlashcards
//
//  Created by Hilla on 12/18/20.
//

import Foundation

class Flashcard: Codable {
    let key: String
    var meanings: Set<String>
    var successes = 0
    var seen = 0
    
    enum CodingKeys: String, CodingKey {
        case key
        case meanings
        case successes
        case seen
    }
    
    init(_ key: String, meanings: [String], successes: Int = 0, seen: Int = 0) {
        self.key = key
        self.meanings = Set(meanings)
        self.successes = successes
        self.seen = seen
    }
    
    func see() {
        self.seen += 1
    }
    
    func succeed() {
        self.successes += 1
    }
    
    func meaning() -> String {
        meanings.joined(separator: " / ")
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encode(meanings, forKey: .meanings)
        try container.encode(successes, forKey: .successes)
        try container.encode(seen, forKey: .seen)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
        meanings = try container.decode(Set<String>.self, forKey: .meanings)
        successes = try container.decode(Int.self, forKey: .successes)
        seen = try container.decode(Int.self, forKey: .seen)
    }
    
}

extension Flashcard: Comparable {
    static func < (lhs: Flashcard, rhs: Flashcard) -> Bool {
        if lhs.successes == lhs.successes {
            return lhs.seen < rhs.seen
        }
        return lhs.successes < rhs.successes
    }
    
    static func == (lhs: Flashcard, rhs: Flashcard) -> Bool {
        if lhs.successes == lhs.successes {
            return lhs.seen == rhs.seen
        }
        
        return lhs.successes == rhs.successes
    }
}


// MARK: Utils
func newFlashcardQueue(flashcards: [Flashcard]) -> PriorityQueue<Flashcard> {
    var fcs = flashcards
    fcs.shuffle()
    let q = PriorityQueue<Flashcard>()
    _ = q.add(fcs)
    return q
}

func encodeFlashcards(flashcards: [Flashcard]) {
    do {
        // Create JSON Encoder
        let encoder = JSONEncoder()
        
        // Encode Flashcards
        let data = try encoder.encode(flashcards)
        // Write/Set Data
        UserDefaults.standard.set(data, forKey: "flashcards")
        
    } catch  {
        print("Unable to Encode Flashcards (\(error))")
    }
}

func decodeFlashcards() -> [Flashcard] {
    // Read/Get Data
    if let data = UserDefaults.standard.data(forKey: "flashcards") {
        do {
            // Create JSON Decoder
            let decoder = JSONDecoder()

            // Decode Flashcards
            let fcs = try decoder.decode([Flashcard].self, from: data)
            return fcs
            
        } catch {
            print("Unable to Decode Flashcards (\(error))")
        }
    }
    return []
}

func clearData() {
    UserDefaults.standard.removeObject(forKey: "flashcards")
}
