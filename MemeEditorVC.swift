//
//  MemeEditorVC.swift
//  Memer
//
//  Created by Jaxson Mann on 1/23/17.
//  Copyright © 2017 Jaxson Mann. All rights reserved.
//

import Foundation
import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    @IBOutlet weak var pickImageFromAlbum: UIBarButtonItem!
    @IBOutlet weak var pickImageFromCamera: UIBarButtonItem!
    @IBOutlet weak var shareMemedImage: UIBarButtonItem!
    @IBOutlet weak var toolbarTop: UIToolbar!
    
    @IBAction func pickAnImageFromAlbum(_ sender: UIBarButtonItem) {
        initPickAnImageButton(.photoLibrary)
    }
    @IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
        initPickAnImageButton(.camera)
    }
    @IBAction func shareMemedImage(_ sender: UIBarButtonItem) {
        let image = generateMemedImage() ;
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) -> () in
            if (completed) {
                self.saveMemedImage(image)
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelEdit(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Cancel editing?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) {
            (action: UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(UIAlertAction(title: "Continue editing", style: .default) {
            (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    let keyboardMoveListener = KeyboardMoveListener()
    let textTopDelegate = MemeTextFieldDelegate()
    let textBottomDelegate = MemeTextFieldDelegate()
    
    var meme = Meme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initToolbars()
        initTextField(textTop, text: meme.textTop, delegate: textTopDelegate)
        initTextField(textBottom, text: meme.textBottom, delegate: textBottomDelegate)
    
        // Disable Share button before meme created
        shareMemedImage.isEnabled = false
    
        // If Meme has imageOriginal then we edit previous Meme
        if let image = meme.imageOriginal {
            loadPreviewImage(image)
            (textTop.delegate as! MemeTextFieldDelegate).isDefaultText = false
            (textBottom.delegate as! MemeTextFieldDelegate).isDefaultText = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keyboardMoveListener.subscribe(view, elements: [textBottom])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        keyboardMoveListener.unsubscribe()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // Initialize toolbars button states
    func initToolbars() {
        pickImageFromCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        pickImageFromAlbum.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }
    
    // Initialize top and bottom text fields
    func initTextField(_ element: UITextField, text: String, delegate: UITextFieldDelegate) {
        let attributes = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0,
        ] as [String: Any]
        
        element.text = text
        element.delegate = delegate
        element.defaultTextAttributes = attributes
        element.textAlignment = NSTextAlignment.center
        element.isHidden = true
    }
    
    // Initialize pick button according to source type
    func initPickAnImageButton(_ sourceType: UIImagePickerControllerSourceType) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = sourceType
        present(controller, animated: true, completion: nil)
    }
    
    // Pick image from camera or album
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            loadPreviewImage(image)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // Set image to preview box and display text edit interface
    func loadPreviewImage(_ image: UIImage) {
        imagePreview.image = image
        textBottom.isHidden = false
        textTop.isHidden = false
        shareMemedImage.isEnabled = true
    }
    
    // If user cancels picking image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        shareMemedImage.isEnabled = (imagePreview.image != nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    // Generate meme image from Meme View
    func generateMemedImage() -> UIImage {
        var image = UIImage() ;
        
        for view in self.view.subviews {
            if view.restorationIdentifier == "meme" {
                // Create context with MemeView size
                UIGraphicsBeginImageContext(view.frame.size)
                
                // Move to MemeView position
                let statusBarHeight = (view.window?.convert(UIApplication.shared.statusBarFrame, from: view))!.height
                let toolbarHeight = toolbarTop.frame.height
                let context = UIGraphicsGetCurrentContext() ;
                context?.translateBy(x: 0, y: -(statusBarHeight + toolbarHeight)) ;
                    
                // Take screenshot of MemeView
                view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
                image = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
            }
        }
        
        return image
    }
        
    // Save Meme model to persistent storage
    func saveMemedImage(_ image: UIImage) {
        meme.textTop = textTop.text!
        meme.textBottom = textBottom.text!
        meme.imageOriginal = imagePreview.image!
        meme.imageMemed = image
            
        // Save Meme to persistent storage in AppDelegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
        
    
}








