//
//  ClippingListViewController.swift
//  TheScrapbook
//
//  Created by Zhe Xian Lee on 22/04/2016.
//  Copyright © 2016 Zhe Xian Lee. All rights reserved.
//

import UIKit

class ClippingListViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UISearchResultsUpdating {
    
    let scrapbookModel = ScrapbookModel.defaultModel
    var collection: Collection?
    var clippings = [Clipping]()
    var documentDirectory : NSURL?
    var selectedImage: UIImage?
    
    let emptyTableImage = UIImage(named: "empty-clipping")
    let emptyTableMessage = NSLocalizedString("You don't have any clipping yet.", comment: "Empty clipping message")
    var emptyTableBackgroundView: EmptyTableViewBackgroundView?

    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var newClippingBarButtonItem: UIBarButtonItem!
    
    // TODO: Display created date
    // TODO: Search filter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setToolbarHidden(false, animated: true)
        tableView.editing = false
        
        // Setup the background that will be used when the table is empty
        emptyTableBackgroundView = EmptyTableViewBackgroundView(image: emptyTableImage, message: emptyTableMessage)
        tableView.backgroundView = emptyTableBackgroundView
        
        // Hides the dividers for empty cells
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    
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
        
        documentDirectory = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first
        
        
    }
    
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
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
                if (clippings.count == 0) {
                    // Show the background when the table is empty
                    emptyTableBackgroundView?.show()
                    tableView.separatorStyle = .None
                    editBarButtonItem.enabled = false
                    return 0
                }
                else {
                    // Hide the background when the table has data
                    emptyTableBackgroundView?.hide()
                    tableView.separatorStyle = .SingleLine
                    editBarButtonItem.enabled = true
                    return clippings.count
                }
                
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
                
                let imageURL = documentDirectory?.URLByAppendingPathComponent(clippings[indexPath.row].image! + ".thumb")

                cell.clippingImageView.image = UIImage(contentsOfFile: imageURL!.path!)
                cell.clippingNoteLabel.text = clippings[indexPath.row].note
                cell.clippingDateLabel.text = NSDateFormatter.localizedStringFromDate(clippings[indexPath.row].dateCreated!, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
                
                return cell
                
            default:
                return UITableViewCell()
            }
        }
        else {
            return UITableViewCell()
        }
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (tableView == self.tableView) {
        switch (editingStyle) {
            case .Delete:
                switch (indexPath.section) {
                case 0:
                    if ((scrapbookModel!.deleteClipping(self.clippings[indexPath.row]))) {
                        self.clippings.removeAtIndex(indexPath.row)
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                        
                        if (self.clippings.count == 0) {
                            toogleTableEditing()
                        }
                    }
                    
                default:
                    return
                }
            default:
                return
            }
        }
    }
    
    
    // MARK: - UIImagePickerControllerDelegate

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismissViewControllerAnimated(true, completion: {
            self.performSegueWithIdentifier("ShowNewClippingDetailViewController", sender: self)
        })
        
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowNewClippingDetailViewController") {
            guard let clippingDetailNavController = segue.destinationViewController as? UINavigationController else {
                return
            }
            
            guard let clippingDetailViewController = clippingDetailNavController.childViewControllers.first as? ClippingDetailViewController else {
                return
            }
            
            clippingDetailViewController.collection = self.collection
            clippingDetailViewController.image = self.selectedImage
        }
        else if (segue.identifier == "ShowClippingDetailViewController") {
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            if (selectedIndexPath.section == 0) {
                guard let clippingDetailNavController = segue.destinationViewController as? UINavigationController else {
                    return
                }
                
                guard let clippingDetailViewController = clippingDetailNavController.childViewControllers.first as? ClippingDetailViewController else {
                    return
                }
                
                clippingDetailViewController.clipping =  clippings[selectedIndexPath.row]
                clippingDetailViewController.collection = self.collection
            }
        }
    }

    
    @IBAction func unwindToClippingListViewController(segue: UIStoryboardSegue) {
        
    }


    // MARK: - IBAction
    
    @IBAction func didTouchNewClippingButton(sender: UIBarButtonItem) {
       presentNewClippingActionSheet()
    }

    
    @IBAction func didTouchEditBarButtonItem(sender: UIBarButtonItem) {
        toogleTableEditing()
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
    
    
    /**
     Toogle the table editing status. If the table is editing, then calling this
     will make the table become non-editing and vice versa.
     */
    func toogleTableEditing() {
        if (tableView.editing) {
            editBarButtonItem.title = NSLocalizedString("Edit", comment: "Edit")
            newClippingBarButtonItem.enabled = true
            navigationController?.setToolbarHidden(false, animated: true)
            tableView.setEditing(false, animated: true)
        }
        else {
            editBarButtonItem.title = NSLocalizedString("Done", comment: "Done")
            newClippingBarButtonItem.enabled = false
            navigationController?.setToolbarHidden(true, animated: true)
            tableView.setEditing(true, animated: true)
        }
    }
    
    
}
