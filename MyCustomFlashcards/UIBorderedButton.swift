//
//  UIBorderedButton.swift
//  MyCustomFlashcards
//
//  Created by Hilla on 12/19/20.
//

import UIKit

class BorderedButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderWidth = 1.0
        layer.borderColor = tintColor.cgColor
        
        layer.cornerRadius = layer.frame.height / 2
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        clipsToBounds = true
        
    }
}
