//
//  ViewController.swift
//  Meme1
//
//  Created by savio jose on 26/06/16.
//  Copyright © 2016 savio jose. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var cameraBarBtn: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareMemeNavBtn: UIBarButtonItem!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMemeTextField(topTextField)
        setUpMemeTextField(bottomTextField)
        
    }
    
    
    func setUpMemeTextField(textField: UITextField){
        
        //set the text attributes
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -1.0
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        cameraBarBtn.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
        updateUIState()
        
    }
    
    override func viewWillDisappear(animated: Bool) {

        unsubscribeFromKeyboardNotifications()
    }
    
     //MARK: Keyboard
    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if bottomTextField.editing{
            
           view.frame.origin.y -= getKeyboardHeight(notification)
        } 
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    
    //MARK: UIImagePickerControllerDelegate
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        presentImagePickerFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        
        presentImagePickerFromSource(UIImagePickerControllerSourceType.Camera)
    }
    
    
    func presentImagePickerFromSource(sourceType: UIImagePickerControllerSourceType){
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        presentViewController(imagePickerController, animated: true, completion: nil)

    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            memeImageView.image = image
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
         textField.resignFirstResponder()
        
        return true
    }
    
    
    
    @IBAction func shareMeme(sender: AnyObject) {
        
        let memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage],
                                                              applicationActivities: nil)
       
        //On an iPad the activityViewController will be displayed as a popover, so we specify the anchor
        activityViewController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        
        activityViewController.completionWithItemsHandler = { (activity: String?, completed: Bool, items: [AnyObject]?, error: NSError?) -> Void in
            
            if completed {
               
                //Create the meme
                //TODO: in Meme final version use a persistent store to save memes.
                let meme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!,originalImage:self.memeImageView.image!, memedImage:memedImage)
                
                self.dismissViewControllerAnimated(true, completion: nil)

            }
        }
        
        
        presentViewController(activityViewController, animated: true, completion: nil)
        
    }

    func generateMemedImage() -> UIImage {
        
        setNavToolBarButtonHidden(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        setNavToolBarButtonHidden(false)
        
        return memedImage
    }
    
    
    func setNavToolBarButtonHidden(hidden: Bool){
        
        bottomToolBar.hidden = hidden
        navigationController?.navigationBarHidden = hidden
    }
    
    @IBAction func resetUI(sender: AnyObject) {
            
        memeImageView.image = nil
        updateUIState()
    }
    
    
    func updateUIState(){
        
        if (memeImageView.image == nil){
            
            shareMemeNavBtn.enabled = false
            topTextField.text = "TOP"
            bottomTextField.text = "BOTTOM"
            
        }else {
            
            shareMemeNavBtn.enabled = true
        }
    }
    
    
}

