//
//  MemeCollectionVC.swift
//  Memer
//
//  Created by Jaxson Mann on 1/23/17.
//  Copyright © 2017 Jaxson Mann. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFlowLayout()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
        setFlowLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    // Return collection cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let meme = memes[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
        cell.image.image = meme.imageMemed
        
        return cell
    }
    
    // Click cell to display preview controller
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        controller.meme = memes[indexPath.row]
        navigationController!.pushViewController(controller, animated: true)
    }
    
    // Setting cell size and spacing
    func setFlowLayout() {
        let items:CGFloat = view.frame.size.width > view.frame.size.height ? 5.0 : 3.0
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - ((items + 1) * space)) / items
        
        flowLayout.minimumLineSpacing = 8.0 - items
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    // Setting layout when rotated
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        setFlowLayout()
    }
}












