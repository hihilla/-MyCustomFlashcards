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
//        let csvText = "alle,all\n" +
//        "alleen,on my own\n" +
//        "beneden,downstairs\n" +
//        "betalen,to pay\n" +
//        "blauw,blue\n" +
//        "buiten,outdoors\n" +
//        "daar,there\n" +
//        "de badkamer,bathroom\n" +
//        "de broer,brother\n" +
//        "de buren,neighbours\n" +
//        "de ervaring,experience\n" +
//        "de feestdag,public holiday\n" +
//        "de fiets,bicycle\n" +
//        "de flat,block of flats\n" +
//        "de folder,leaflet\n" +
//        "de helft,half\n" +
//        "de hulp,help\n" +
//        "de huur,rent\n" +
//        "de informatie,information\n" +
//        "de ingang,entrance\n" +
//        "de kamer,room\n" +
//        "de kast,cupboard\n" +
//        "de klant,customer\n" +
//        "de korting,discount\n" +
//        "de lamp,lamp\n" +
//        "de laptop,laptop\n" +
//        "de meubels,furniture\n" +
//        "de opruiming,clearance sale\n" +
//        "de plek,place\n" +
//        "de poes,pussycat\n" +
//        "de prijs,price\n" +
//        "de sleutel,key\n" +
//        "de soort,type of\n" +
//        "de stoel,chair\n" +
//        "de stoep,sidewalk\n" +
//        "de tafel,table\n" +
//        "de tuin,garden\n" +
//        "de verdieping,floor\n" +
//        "de website,website\n" +
//        "de winter,winter\n" +
//        "de woonkamer,living room\n" +
//        "de zolder,attic\n" +
//        "de zomer,summer\n" +
//        "de zon,sun\n" +
//        "delen,to share\n" +
//        "deze,this\n" +
//        "dit,this\n" +
//        "donker,dark\n" +
//        "druk,busy\n" +
//        "gek op,fond of\n" +
//        "hangen,to hang\n" +
//        "helpen,to help\n" +
//        "het appartement,apartment\n" +
//        "het briefje,note\n" +
//        "het centrum,centre\n" +
//        "het idee,idea\n" +
//        "het licht,light\n" +
//        "het liefst,preferably\n" +
//        "het nummer,number\n" +
//        "het procent,percent\n" +
//        "het raam,window\n" +
//        "hij,he\n" +
//        "hoeveel,how much\n" +
//        "hoog,high\n" +
//        "jou,you\n" +
//        "kiezen,to choose\n" +
//        "klussen,to do odd jobs\n" +
//        "kosten,to cost\n" +
//        "laag,low\n" +
//        "leeg,empty\n" +
//        "maken,to make\n" +
//        "mezelf,myself\n" +
//        "mij,me\n" +
//        "net,just\n" +
//        "onze,our\n" +
//        "ophalen,to pick up\n" +
//        "oppassen,to watch\n" +
//        "opruimen,to clean up\n" +
//        "per,per\n" +
//        "rood,red\n" +
//        "ruilen,to exchange\n" +
//        "rustig,quiet\n" +
//        "samen,together\n" +
//        "trouwens,by the way\n" +
//        "twijfelen,to doubt\n" +
//        "uw,your [formal]\n" +
//        "verhuizen,to move\n" +
//        "verkopen,to sell\n" +
//        "vlakbij,nearby\n" +
//        "waarom,why\n" +
//        "want,because\n" +
//        "wat voor,what kind of\n" +
//        "welk,which\n" +
//        "wij,we\n" +
//        "wit,white\n" +
//        "zij,she\n" +
//        "zijn,his\n" +
//        "zoeken,to search\n" +
//        "zorgen voor,to create\n" +
//        "zwart,black\n" 
//
//        let fcs = buildFlashcards(from: csvText)
//        
////        let fcs : [Flashcard] = [Flashcard("a", meaning: "A"), Flashcard("b", meaning: "B", successes: 2), Flashcard("c", meaning: "C", successes: 3)]
//        let cards = newFlashcardQueue(flashcards: fcs)
//        while cards.size > 0 {
//            print(cards.dequeue()?.key)
//        }
    }


}

extension ViewController: UIDocumentPickerDelegate {
    @IBAction func onTouchUpInsideAddCards(_ sender: UIButton) {
        // Create a document picker for directories.
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.folder, UTType.text], asCopy: true)
        

        documentPicker.delegate = self

        // Set the initial directory.
//        documentPicker.directoryURL = startingDirectory

        // Present the document picker.
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        for u in urls {
            print(u.absoluteURL)
            let fcs = parseCSVintoFlashcardsArray(u.path)
            _ = flashcards.add(fcs)
//            while cards.size > 0 {
////                print(cards.dequeue()?.key)
//            }
        }
    }
}

