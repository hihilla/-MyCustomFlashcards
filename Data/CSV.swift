//
//  CSV.swift
//  MyCustomFlashcards
//
//  Created by Hilla on 12/18/20.
//

import Foundation

func openCSV(fileName:String, fileType: String)-> String!{
//    guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
//    else {
//        return nil
//    }
//    print(filepath)
    do {
        let contents = try String(contentsOfFile: fileName, encoding: .utf8)
        
        return contents
    } catch {
        print("File Read Error for file \(fileName): \(error)")
        return nil
    }
}

func buildFlashcards(from dataString: String) -> [Flashcard] {
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
            let item = Flashcard(values[0], meaning: values[1])
            items.append(item)
        }
    }
    
    return items
}

func parseCSVintoFlashcardsArray(_ filename: String) -> [Flashcard] {
    guard let dataString = openCSV(fileName: filename, fileType: "csv") else {
        print("failed to get text from file " + filename)
        return []
    }
    return buildFlashcards(from: dataString)
}
