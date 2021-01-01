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
//    do {
//        return try buildFlashcards(from: parse(from: filename))
//    } catch let error as NSError {
//        print("Caught Error: \(error.localizedDescription), \(error.domain), \(error.code)")
//          let uis = error.userInfo
//          print("\tUser info:")
//          for (key,value) in uis {
//            print("\t\tkey=\(key), value=\(value)")
//          }
//    }
//    return []
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

func openCSVFoo(fileName:String, fileType: String)-> String!{
    do {
        let contents = try String(contentsOfFile: fileName, encoding: .utf8)
        
        return contents
    } catch {
        print("File Read Error for file \(fileName): \(error)")
        return nil
    }
}

func buildFlashcardsFoo(from dataString: String) -> [Flashcard] {
    var items: [Flashcard] = []
    let lines: [String] = dataString.components(separatedBy: NSCharacterSet.newlines) as [String]
    
    for line in lines {
        var values: [String] = []
        if line != "" {
            if line.range(of: "\"") != nil {
                var textToScan:String = line
                var value:String?
                var textScanner:Scanner = Scanner(string: textToScan)
                while !textScanner.isAtEnd {
                    if (textScanner.string as NSString).substring(to: 1) == "\"" {
                        
                        
                        textScanner.currentIndex = textScanner.string.index(after: textScanner.currentIndex)
                        
                        value = textScanner.scanUpToString("\"")
                        textScanner.currentIndex = textScanner.string.index(after: textScanner.currentIndex)
                    } else {
                        value = textScanner.scanUpToString(",")
                    }
                    
                    values.append(value! as String)
                    
                    if !textScanner.isAtEnd{
                        let indexPlusOne = textScanner.string.index(after: textScanner.currentIndex)
                        
                        textToScan = String(textScanner.string[indexPlusOne...])
                    } else {
                        textToScan = ""
                    }
                    textScanner = Scanner(string: textToScan)
                }
                
                // For a line without double quotes, we can simply separate the string
                // by using the delimiter (e.g. comma)
            } else  {
                values = line.components(separatedBy: ",")
            }
            
            // Put the values into the tuple and add it to the items array
            let item = Flashcard(values[0], meanings: [values[1]])
            items.append(item)
        }
    }
    
    return items
}

func parseCSVintoFlashcardsArrayFoo(_ filename: String) -> [Flashcard] {
    guard let dataString = openCSVFoo(fileName: filename, fileType: "csv") else {
        print("failed to get text from file " + filename)
        return []
    }
    return buildFlashcardsFoo(from: dataString)
}
