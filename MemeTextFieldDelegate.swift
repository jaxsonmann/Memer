//
//  MemeTextFieldDelegate.swift
//  Memer
//
//  Created by Jaxson Mann on 1/23/17.
//  Copyright © 2017 Jaxson Mann. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    var isDefaultText: Bool = true
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isDefaultText {
            textField.text = ""
            isDefaultText = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
