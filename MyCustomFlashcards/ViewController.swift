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
            
            let parsedFCs = parseCSVintoFlashcardsArray(u.path)
            for newCard in parsedFCs {
                let existingCard = cardsDic[newCard.key]
                if existingCard != nil {
                    existingCard?.meanings.formUnion(newCard.meanings)
                } else {
                    cardsDic[newCard.key] = newCard
                }
            }

            var flashcards: [Flashcard] = []
            for kaka in cardsDic.values {
                flashcards.append(kaka)
            }
            encodeFlashcards(flashcards: flashcards)
        }
    }
}

