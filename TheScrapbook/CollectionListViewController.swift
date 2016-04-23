//
//  ViewController.swift
//  TheScrapbook
//
//  Created by Zhe Xian Lee on 18/04/2016.
//  Copyright © 2016 Zhe Xian Lee. All rights reserved.
//

import UIKit

class CollectionListViewController: UITableViewController {

    let scrapbookModel = ScrapbookModel.defaultModel
    var collections: [Collection]?
    
    let emptyTableImage = UIImage(named: "empty-collection")
    let emptyTableMessage = NSLocalizedString("You don't have any collections yet.", comment: "Empty collection message")
    var emptyTableBackgroundView: EmptyTableViewBackgroundView?
 
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var newCollectionBarButtonItem: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        // Prepare our Collections
        collections = scrapbookModel?.fetchAllCollections()
        
        // Setup the background that will be used when the table is empty
        emptyTableBackgroundView = EmptyTableViewBackgroundView(image: emptyTableImage, message: emptyTableMessage)
        tableView.backgroundView = emptyTableBackgroundView
        
        // Hides the dividers for empty cells
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.barTintColor = UIColor(red: 0x4D / 255, green: 0x36 / 255, blue: 0x6C / 255, alpha: 1)
    }
    
    
    // MARK: - UITableViewController
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            guard let _collections = collections else {
                // Show the background
                emptyTableBackgroundView?.show()
                tableView.separatorStyle = .None
                editBarButtonItem.enabled = false
                return 0
            }
            
            if (_collections.count == 0) {
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
                return _collections.count + 1
            }
            
        default:
            return 0
        }
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            guard let cell = tableView.dequeueReusableCellWithIdentifier("CollectionCell") as? CollectionTableViewCell else {
                return UITableViewCell()
            }
            
            if (indexPath.row == 0) {
                // "All Clippings" cell
                cell.titleLabel.text = NSLocalizedString("All Clippings", comment: "All CLippings")
            }
            else {
                cell.titleLabel.text = collections?[indexPath.row - 1].name
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }

    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
            case 0:
                return false
            default:
                return true
            }
            
        default:
            return false
        }
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch (editingStyle) {
        case .Delete:
            switch (indexPath.section) {
            case 0:
                if (indexPath.row > 0) {
                    if ((scrapbookModel!.deleteCollection(collections![indexPath.row - 1]))) {
                        collections!.removeAtIndex(indexPath.row - 1)
                        
                        var deleteIndexPaths = [NSIndexPath]()
                        if (collections!.count == 0) {
                            // Remove the "All Clippings" cell when there's nothing in the collections array
                            deleteIndexPaths.append(NSIndexPath(forRow: 0, inSection: 0))
                            // Make the table become non-editing
                            toogleTableEditing()
                        }
                        deleteIndexPaths.append(indexPath)
                        
                        tableView.deleteRowsAtIndexPaths(deleteIndexPaths, withRowAnimation: .Automatic)
                    }
                }
            default:
                return
            }
        default:
            return
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func didTouchNewCollectionButton(sender: UIBarButtonItem) {
        presentNewCollectionAlert()
    }
    
    
    @IBAction func didTouchEditButton(sender: UIBarButtonItem) {
        toogleTableEditing()
    }

    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowClippingListViewController") {
            guard let clippingListViewController = segue.destinationViewController as? ClippingListViewController else {
                return
            }
            
            if (tableView.indexPathForSelectedRow?.section == 0 && tableView.indexPathForSelectedRow?.row > 0) {
                clippingListViewController.collection = collections![(tableView.indexPathForSelectedRow?.row)! - 1]
            }
        }
    }
    
    
    // MARK: - Functions
    
    /**
        Toogle the table editing status. If the table is editing, then calling this 
        will make the table become non-editing and vice versa.
    */
    func toogleTableEditing() {
        if (tableView.editing) {
            editBarButtonItem.title = NSLocalizedString("Edit", comment: "Edit")
            newCollectionBarButtonItem.enabled = true
            navigationController?.setToolbarHidden(false, animated: true)
            tableView.setEditing(false, animated: true)
        }
        else {
            editBarButtonItem.title = NSLocalizedString("Done", comment: "Done")
            newCollectionBarButtonItem.enabled = false
            navigationController?.setToolbarHidden(true, animated: true)
            tableView.setEditing(true, animated: true)
        }
    }
    
    /**
        Presents an alert controller that allows user to create a collection
     */
    func presentNewCollectionAlert() {
        // Create the alert
        let alertTitle = NSLocalizedString("Create New Collection", comment: "Create New Collection")
        let alertMessage = NSLocalizedString("Enter the collection name", comment: "Enter the collection name")
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        alert.view.tintColor = UIColor(red: 0x75 / 255, green: 0x56 / 255, blue: 0x9A / 255, alpha: 1)

        // Add a textfield
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = NSLocalizedString("Collection name", comment: "Collection Name")
            textField.autocapitalizationType = .Words
        }
        
        // Cancel action
        let cancelTitle = NSLocalizedString("Cancel", comment: "Cancel")
        let cancelAction = UIAlertAction(title: cancelTitle, style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        
        // Create Action
        let createTitle = NSLocalizedString("Create", comment: "Create")
        let createAction = UIAlertAction(title: createTitle, style: .Default, handler: {(action) -> Void in
            guard let collectionTextField = alert.textFields?.first else {
                return
            }
            self.createCollectionWithName(collectionTextField.text!)
           
        })
        alert.addAction(createAction)
        
        presentViewController(alert, animated: true, completion: nil)

    }
    
    /**
        Create a collection with the specified name
     
        - Parameters:
            - name: Name of the collection
    */
    func createCollectionWithName(name: String) {
        guard let newCollection = self.scrapbookModel?.createCollectionWithName(name) else {
            return
        }
        
        self.collections?.append(newCollection)
        
        // Create index path for rows to be inserted
        var insertIndexPaths = [NSIndexPath]()
        if (self.collections?.count > 1) {
            // Adds only one row if the 'All Clippings' row exists
            let indexPath = NSIndexPath(forRow: self.collections!.count, inSection: 0)
            insertIndexPaths.append(indexPath)
        }
        else if (self.collections?.count == 1) {
            // Adds two rows, including the 'All Clipping' row
            let allClippingRowindexPath = NSIndexPath(forRow: 0, inSection: 0)
            insertIndexPaths.append(allClippingRowindexPath)
            let newRowIndexPath = NSIndexPath(forRow: 1, inSection: 0)
            insertIndexPaths.append(newRowIndexPath)
        }
        
        self.tableView.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: .Automatic)
    }
    
}

