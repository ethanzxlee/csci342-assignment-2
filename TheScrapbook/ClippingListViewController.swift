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
    var clippings = [Clipping]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        if (collection == nil) {
            if let allClippings = scrapbookModel?.fetchAllClippings() {
                clippings.appendContentsOf(allClippings)
            }
        }
        else {
            if let fetchedClippings = scrapbookModel?.fetchAllClippingsInCollection(collection!) {
                clippings.appendContentsOf(fetchedClippings)
            }
        }
        
    }
    
    // MARK: - UITableViewController

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (tableView == self.tableView) {
            return 1
        }
        else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.tableView) {
            switch (section) {
            case 0:
                return clippings.count
            default:
                return 0
            }
        }
        else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView == self.tableView) {
            
            switch (indexPath.section) {
            case 0:
                guard let cell = tableView.dequeueReusableCellWithIdentifier("ClippingListTableViewCell") as? ClippingListTableViewCell else {
                    return UITableViewCell()
                }
                print(clippings[indexPath.row].image!)
                
                cell.clippingImageView.image = UIImage(contentsOfFile: clippings[indexPath.row].image!)
                cell.clippingNoteLabel?.text = clippings[indexPath.row].note
                
                return cell
                
            default:
                return UITableViewCell()
            }
        }
        else {
            return UITableViewCell()
        }
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
            guard let clippingDetailNavController = segue.destinationViewController as? UINavigationController else {
                return
            }
            
            guard let clippingDetailViewController = clippingDetailNavController.childViewControllers.first as? ClippingDetailViewController else {
                return
            }
            
            clippingDetailViewController.collection = self.collection
            clippingDetailViewController.image = self.selectedImage
        }
    }
    
    @IBAction func unwindToClippingListViewController(segue: UIStoryboardSegue) {
        
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
        picker.navigationBar.barStyle = .Black
        picker.navigationBar.barTintColor = UIColor(red: 0x4D / 255, green: 0x36 / 255, blue: 0x6C / 255, alpha: 1)
        picker.navigationBar.tintColor = UIColor.whiteColor()
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    
    
}
