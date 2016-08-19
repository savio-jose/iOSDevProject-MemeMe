//
//  SentMemesTableViewController.swift
//  Meme1
//
//  Created by savio jose on 17/08/16.
//  Copyright © 2016 savio jose. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add edit functionality for tableview
        navigationItem.leftBarButtonItem = editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //refresh tableView when new meme added
        tableView.reloadData()
    }
    
    // MARK: TableView
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 110
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! MemeTableViewCell
        let meme = memes[indexPath.row]
        
        // Set the image & text
        cell.memedImage?.image = meme.memedImage
        cell.memeLabel?.text = meme.topText+"..."+meme.bottomText
  
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let memeDetailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.meme = memes[indexPath.row]
        navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
    
    // MARK: Edit TableView
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // Delete meme from array
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            // Delete meme from tableView
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView.setEditing(editing, animated: animated)
    }
    
    
}
