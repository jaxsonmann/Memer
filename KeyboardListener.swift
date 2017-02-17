//
//  KeyboardListener.swift
//  Memer
//
//  Created by Jaxson Mann on 1/23/17.
//  Copyright © 2017 Jaxson Mann. All rights reserved.
//

import Foundation
import UIKit

class KeyboardMoveListener: NSObject {
    
    var view: UIView?
    var elements: [UIResponder] = []
    let notificationCenter = NotificationCenter.default
    
    // Subscribe to keyboard moving
    func subscribe(_ view: UIView, elements: [UIResponder]) {
        self.view = view
        self.elements = elements
        
        notificationCenter.addObserver(self, selector: #selector(KeyboardMoveListener.keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(KeyboardMoveListener.keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Unsubscribe from keyboard moving
    func unsubscribe() {
        notificationCenter.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Move view above keyboard
    func keyboardWillShow(_ notification: Notification) {
        for element in elements {
            if element.isFirstResponder {
                view!.frame.origin.y = -(notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
                return
            }
        }
    }
    
    // Move view back to bottom of screen
    func keyboardWillHide(_ notification: Notification) {
        view!.frame.origin.y = 0
    }
}





















