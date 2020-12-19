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

    var flashcards: PriorityQueue<Flashcard> = newFlashcardQueue(flashcards: [])
    
    override func viewWillAppear(_ animated: Bool) {
        flashcards = decodeFlashcards()
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        encodeFlashcards(flashcards: flashcards)
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
            print(u.absoluteURL)
            let fcs = parseCSVintoFlashcardsArray(u.path)
            _ = flashcards.add(fcs)
            encodeFlashcards(flashcards: flashcards)
        }
    }
}

