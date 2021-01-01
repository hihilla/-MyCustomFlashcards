//
//  ViewController.swift
//  MyCustomFlashcards
//
//  Created by Hilla on 12/18/20.
//

import UIKit
import CoreServices
import UniformTypeIdentifiers

class ViewController: UIViewController {
    @IBOutlet var addFromCsvButton: UIButton!
    @IBOutlet var practiceButton: UIButton!
    @IBOutlet var AlertLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
}

extension ViewController: UIDocumentPickerDelegate {
    @IBAction func onTouchUpInsideAddCards(_ sender: UIButton) {
        AlertLabel.text = ""
        // Create a document picker for directories.
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.folder, UTType.text], asCopy: true)
        
        
        documentPicker.delegate = self
        
        // Present the document picker.
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        for u in urls {
            let storedFlashcards = decodeFlashcards()
            var cardsDic: [String: Flashcard] = [:]
            for card in storedFlashcards {
                cardsDic[card.key] = card
            }
            do {
                let parsedFCs = try parseCSVintoFlashcardsArray(from: u.path)
                for newCard in parsedFCs {
                    let existingCard = cardsDic[newCard.key]
                    if existingCard != nil {
                        existingCard?.meanings.formUnion(newCard.meanings)
                    } else {
                        cardsDic[newCard.key] = newCard
                    }
                }
            } catch let error as NSError {
                var errStr = "Caught Error: \(error.localizedDescription)\n"
                print("Caught Error: \(error.localizedDescription), \(error.domain), \(error.code)")
                let uis = error.userInfo
                if uis.count > 0 {
                    errStr += "\tUser info:\n"
                    print("\tUser info:")
                    for (key,value) in uis {
                        errStr += "\t\tkey=\(key), value=\(value)\n"
                        print("\t\tkey=\(key), value=\(value)")
                    }
                }
                AlertLabel.text = errStr
            }
            
            var flashcards: [Flashcard] = []
            for kaka in cardsDic.values {
                flashcards.append(kaka)
            }
            encodeFlashcards(flashcards: flashcards)
        }
    }
}

