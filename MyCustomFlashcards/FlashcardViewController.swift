//
//  FlashcardViewController.swift
//  MyCustomFlashcards
//
//  Created by Hilla on 12/19/20.
//

import UIKit

class FlashcardViewController: UIViewController {
    var flashcards: PriorityQueue<Flashcard> = newFlashcardQueue(flashcards: [])
    var currentFlashcard: Flashcard?
    var typeOfCard: TypeOfCard = .key
    
    @IBOutlet var label: UILabel!
    @IBOutlet var noButton: UIButton!
    @IBOutlet var yesButton: UIButton!
    
    enum TypeOfCard {
        case key
        case meaning
    }
    
    fileprivate func hideButtons() {
        noButton.isHidden = true
        yesButton.isHidden = true
        noButton.isEnabled = false
        yesButton.isEnabled = false
        viewWillLayoutSubviews()
    }
    
    fileprivate func unhideButtons() {
        noButton.isHidden = false
        yesButton.isHidden = false
        noButton.isEnabled = true
        yesButton.isEnabled = true
        viewWillLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        flashcards = newFlashcardQueue(flashcards: decodeFlashcards())
        if flashcards.size == 0 {
            label.numberOfLines = 3
            label.textColor = .red
            label.text = "No cards! Swipe down and import some cards"
        } else {
            currentFlashcard = flashcards.dequeue()
            currentFlashcard?.see()
            label.text = currentFlashcard?.key
        }
        
        hideButtons()
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let fc = currentFlashcard {
            flashcards.add(fc)
        }
        encodeFlashcards(flashcards: flashcards.array())
        super.viewWillDisappear(animated)
    }
    
    @IBAction func onTapGestureRecognized(_ sender: UITapGestureRecognizer) {
        flipCard()
    }
    
    @IBAction func onTouchUpInsideYesButton(_ sender: UIButton) {
        currentFlashcard?.succeed()
        changeCard()
    }
    @IBAction func onTouchUpInsideNoButton(_ sender: Any) {
        changeCard()
    }
    
    
    func changeCard() {
        if let fc = currentFlashcard {
            flashcards.add(fc)
        }
        if flashcards.size == 0 {
            label.text = "All done! Swipe down to exit"
        }
        currentFlashcard = flashcards.dequeue()
        currentFlashcard?.see()
        setKeyCard()
        viewWillLayoutSubviews()
    }
    
    fileprivate func setKeyCard() {
        typeOfCard = .key
        label.text = currentFlashcard?.key
        hideButtons()
    }
    
    fileprivate func setMeaningCard() {
        typeOfCard = .meaning
        label.text = currentFlashcard?.meaning()
        unhideButtons()
    }
    
    func flipCard() {
        if typeOfCard == .key {
            setMeaningCard()
        } else {
            setKeyCard()
        }
        viewWillLayoutSubviews()
    }
}
