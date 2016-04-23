//
//  ClippingListViewController.swift
//  TheScrapbook
//
//  Created by Zhe Xian Lee on 22/04/2016.
//  Copyright © 2016 Zhe Xian Lee. All rights reserved.
//

import UIKit

class ClippingListViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let scrapbookModel = ScrapbookModel.defaultModel
    var collection: Collection?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.setToolbarHidden(false, animated: true)
        

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    // MARK: - UIImagePickerControllerDelegate

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismissViewControllerAnimated(true, completion: {
            self.performSegueWithIdentifier("ShowClippingDetailViewController", sender: self)
        })
        
    }
    
    var selectedImage: UIImage?
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowClippingDetailViewController") {
            guard let clippingDetailViewController = segue.destinationViewController as? ClippingDetailViewController else {
                return
            }
            clippingDetailViewController.image = selectedImage
        }
    }


    // MARK: - IBAction
    
    @IBAction func didTouchNewClippingButton(sender: UIBarButtonItem) {
       presentNewClippingActionSheet()
    }

    
    // MARK: - Functions
    
    /**
        Present "New Clipping" action sheet
    */
    func presentNewClippingActionSheet() {
        // Alert
        let alertTitle = NSLocalizedString("New Clipping", comment: "New Clipping")
        let alertMessage = NSLocalizedString("Pick an image", comment: "Pick an image")
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .ActionSheet)
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        
        // From PhotoLibrary action
        let fromPhotoLibraryTitle = NSLocalizedString("From photo library", comment: "From photo library")
        let fromPhotoLibraryAction = UIAlertAction(title: fromPhotoLibraryTitle, style: .Default, handler: {(action) -> Void in
            self.presentImagePickerWithSourceType(.PhotoLibrary)
        })
        alert.addAction(fromPhotoLibraryAction)
        
        // From camera action
        let fromCameraTitle = NSLocalizedString("From camera", comment: "From camera")
        let fromCameraAction = UIAlertAction(title: fromCameraTitle, style: .Default, handler: {(action) -> Void in
            
        })
        alert.addAction(fromCameraAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }

    /**
        Present image picker with the specified type
    */
    func presentImagePickerWithSourceType(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        
        picker.sourceType = sourceType
        picker.delegate = self
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    
    
}
