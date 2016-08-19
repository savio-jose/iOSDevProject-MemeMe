//
//  MemeDetailViewController.swift
//  Meme1
//
//  Created by savio jose on 18/08/16.
//  Copyright © 2016 savio jose. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    
    @IBOutlet weak var memedImage: UIImageView!
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //hide tabBarController
        self.tabBarController?.tabBar.hidden = true
        
        memedImage.image = meme.memedImage
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Unhide tabBarController
        self.tabBarController?.tabBar.hidden = false
    }
    
}
