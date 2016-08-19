//
//  SentMemesCollectionViewController.swift
//  Meme1
//
//  Created by savio jose on 17/08/16.
//  Copyright © 2016 savio jose. All rights reserved.
//

import Foundation

import UIKit

class SentMemesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFlowLayout(self.view.frame.size)
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        collectionView?.reloadData()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        // Reconfigure the flow layout when the size of the frame changes.
        setupFlowLayout(size)
    }
    
    //configures flow layout based on current frame size
    func setupFlowLayout(size: CGSize){
        
        let space: CGFloat = 3.0
        
        //number of columns are set to 3 in portrait & 4 in landscape
        let dimension:CGFloat = size.width >= size.height ? (size.width - (5 * space)) / 4.0 :  (size.width - (2 * space)) / 3.0
        
        flowLayout?.minimumInteritemSpacing = space
        flowLayout?.minimumLineSpacing = space
        flowLayout?.itemSize = CGSizeMake(dimension, dimension)
        
    }
    
   // MARK: CollectionView
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        // Set the image
        cell.memedImage?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        let memeDetailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.meme = memes[indexPath.row]
        navigationController?.pushViewController(memeDetailViewController, animated: true)
        
        
    }

    
}