//
//  CSV.swift
//  MyCustomFlashcards
//
//  Created by Hilla on 12/18/20.
//

import Foundation
import CSV

func parseCSVintoFlashcardsArray(from filename: String) throws -> [Flashcard] {
    return try buildFlashcards(from: parse(from: filename))
}

func parse(from filename: String) throws -> CSVReader {
    let stream = InputStream(fileAtPath: "/path/to/file.csv")!
    let csv = try CSVReader(stream: stream)
    return csv
}

func buildFlashcards(from csvReader: CSVReader) throws -> [Flashcard] {
    let NumberOfColumsInCSV = 2 // expecting a CSV containing 2 columns: first side of card, second side of card
    var items: [Flashcard] = []
    while let row = csvReader.next() {
        if row.count != NumberOfColumsInCSV {
            throw NSError(
                domain: "insufficient number of columns in CSV",
                code: NumberOfColumsInCSV,
                userInfo:
                    [
                        "expectedNumberOfColumns": NumberOfColumsInCSV,
                        "actualNumberOfColumns": row.count,
                        "message": "CSV file should have 2 columns in this order (wihtout heading): first side of card, second side of card"
                    ]
            )
        }
        // create Flashcard from row and put into the array
        let item = Flashcard(row[0], meanings: [row[1]])
        items.append(item)
    }
    return items
}
