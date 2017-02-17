//
//  PreviewVC.swift
//  Memer
//
//  Created by Jaxson Mann on 1/23/17.
//  Copyright © 2017 Jaxson Mann. All rights reserved.
//

import Foundation
import UIKit

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var imagePreview: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imagePreview.image = meme.imageMemed
    }
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        controller.meme = meme
        
        present(controller, animated: true, completion: nil)
    }
     
}
