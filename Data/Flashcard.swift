//
//  flashcard.swift
//  MyCustomFlashcards
//
//  Created by Hilla on 12/18/20.
//

import Foundation

class Flashcard: Codable {
    let key: String
    let meaning: String
    var successes = 0
    var seen = 0
    
    enum CodingKeys: String, CodingKey {
        case key
        case meaning
        case successes
        case seen
    }
    
    init(_ key: String, meaning: String, successes: Int = 0, seen: Int = 0) {
        self.key = key
        self.meaning = meaning
        self.successes = successes
        self.seen = seen
    }
    
    func see() {
        self.seen += 1
    }
    
    func succeed() {
        self.successes += 1
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encode(meaning, forKey: .meaning)
        try container.encode(successes, forKey: .successes)
        try container.encode(seen, forKey: .seen)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
        meaning = try container.decode(String.self, forKey: .meaning)
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

func encodeFlashcards(flashcards: PriorityQueue<Flashcard>) {
    do {
        // Create JSON Encoder
        let encoder = JSONEncoder()
        
        // Encode Flashcards
        let fcs = flashcards.array()
        let data = try encoder.encode(fcs)
        // Write/Set Data
        UserDefaults.standard.set(data, forKey: "flashcards")
        
    } catch  {
        print("Unable to Encode Flashcards (\(error))")
    }
}

func decodeFlashcards() -> PriorityQueue<Flashcard> {
    // Read/Get Data
    if let data = UserDefaults.standard.data(forKey: "flashcards") {
        do {
            // Create JSON Decoder
            let decoder = JSONDecoder()
            
            // Decode Flashcards
            let fcs = try decoder.decode([Flashcard].self, from: data)
            return newFlashcardQueue(flashcards: fcs)
            
        } catch {
            print("Unable to Decode Flashcards (\(error))")
        }
    }
    return newFlashcardQueue(flashcards: [])
}
