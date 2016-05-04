//
//  ClippingDetailViewController.swift
//  TheScrapbook
//
//  Created by Zhe Xian Lee on 22/04/2016.
//  Copyright © 2016 Zhe Xian Lee. All rights reserved.
//

import UIKit

class ClippingDetailViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    
    let scrapbookModel = ScrapbookModel.defaultModel
    
    var collection: Collection?
    var clipping: Clipping?
    var image: UIImage?
    var imageViewFullscreen = false
    var shouldSave = true
    var shouldDelete = false
    var noteTextViewEdited = false
    
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var deleteBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewAspectConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewEqualHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopContraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewEqualWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var dateCreatedLabelZeroHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var noteTextViewZeroHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.barTintColor = UIColor(red: 0x4D / 255, green: 0x36 / 255, blue: 0x6C / 255, alpha: 1)
        
        // Preparation
        if (clipping != nil) {
            let imageURL = scrapbookModel?.documentDirectory?.URLByAppendingPathComponent(clipping!.image!)
            self.image = UIImage(contentsOfFile: (imageURL?.path)!)
            
            noteTextView.text = clipping?.note
            deleteBarButtonItem.title = NSLocalizedString("Delete", comment: "Delete")
        }
        else {
            // Manually put placeholder for text view
            noteTextView.text = NSLocalizedString("Type your note here", comment: "Type your note here")
            deleteBarButtonItem.title = NSLocalizedString("Cancel", comment: "Cancel")
            noteTextView.textColor = UIColor(red: 0x4D / 255, green: 0x34 / 255, blue: 0x6C / 255, alpha: 0.3)
        }
        noteTextView.delegate = self
        
        
        // Setup the image view
        imageView.image = self.image
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "didTapImageView:"))
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        registerForKeyboardNotifications()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        deregisterForKeyboardNotification()
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return imageViewFullscreen
    }
    
    
    // MARK: - UITextViewDelegate 
    
    func textViewDidBeginEditing(textView: UITextView) {
        if (textView == noteTextView) {
            if (clipping == nil) {
                if (!noteTextViewEdited) {
                    noteTextView.text = ""
                    noteTextView.textColor = UIColor(red: 0x4D / 255, green: 0x34 / 255, blue: 0x6C / 255, alpha: 1)
                }
            }
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView == noteTextView) {
            if (clipping == nil) {
                if (noteTextView.text == "") {
                    noteTextView.text = NSLocalizedString("Type your note here", comment: "Type your note here")
                    noteTextView.textColor = UIColor(red: 0x4D / 255, green: 0x34 / 255, blue: 0x6C / 255, alpha: 0.3)
                    noteTextViewEdited = false;
                }
                else {
                    noteTextViewEdited = true;
                }
            }
        }
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    
    // MARK: - IBActions
    
    @IBAction func didTouchBarButtonItem(sender: UIBarButtonItem) {
        shouldSave = true;
        shouldDelete = false;
    
        noteTextView.resignFirstResponder()
        performSegueWithIdentifier("UnwindToClippingListViewSegue", sender: nil)
    }
    
    
    @IBAction func didTouchDeletBarButtonItem(sender: AnyObject) {
        shouldSave = false;
        shouldDelete = true;
        
        performSegueWithIdentifier("UnwindToClippingListViewSegue", sender: nil)
    }
    
    
    // MARK: - Gesture Recogniser
    
    func didTapImageView(gestureRecognizer: UITapGestureRecognizer) {
        if (noteTextView.isFirstResponder()) {
            noteTextView.resignFirstResponder()
        }
        else {
            toggleFullscreenImageView()
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let clippingListViewController = segue.destinationViewController as? ClippingListViewController {
            if (shouldSave) {
                guard let image = image else {
                    return
                }
                
                // If it's a new clipping
                if (clipping == nil) {
                    var noteText = "";
                    
                    if (noteTextViewEdited) {
                        noteText = noteTextView.text
                    }
                    
                    if let newClipping = scrapbookModel?.createClippingWithNotes(noteText, image: image) {
                        // It it belongs to a collection
                        if (collection != nil) {
                            scrapbookModel?.addClipping(newClipping, toCollection: collection!)
                        }
                        
                        // Reload the clippings array
                        if (self.collection == nil) {
                            clippingListViewController.clippings = (scrapbookModel?.fetchAllClippings())!
                        }
                        else {
                            clippingListViewController.clippings = (scrapbookModel?.fetchAllClippingsInCollection(self.collection!))!
                        }
                    }
                }
                // otherwise update the existing clipping
                else {

                }
                
                // Reload the list
                clippingListViewController.tableView.reloadData()
            }
            else if (shouldDelete) {
                // Only delete if the clipping has already been saved
                // Do nothing if it has not been saved yet, just don't save it
                if let _clipping = clipping {
                    scrapbookModel?.deleteClipping(_clipping)
                    
                    // Reload the clippings array
                    if (self.collection == nil) {
                        clippingListViewController.clippings = (scrapbookModel?.fetchAllClippings())!
                    }
                    else {
                        clippingListViewController.clippings = (scrapbookModel?.fetchAllClippingsInCollection(self.collection!))!
                    }
                    
                    clippingListViewController.tableView.reloadData()
                }
            }
            
        }
    }
    
    
    // MARK: - Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() else {
            return
        }
        
        scrollViewBottomConstraint.constant = keyboardSize.height
        UIView.animateWithDuration(0.5) { () -> Void in
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        scrollViewBottomConstraint.constant = 0
        UIView.animateWithDuration(0.5) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    
    // MARK: - Functions
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func deregisterForKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func toggleFullscreenImageView() {
        imageViewFullscreen = !imageViewFullscreen
        self.navigationController?.setNavigationBarHidden(imageViewFullscreen, animated: true)
        
        if (imageViewFullscreen) {
            self.scrollView.minimumZoomScale = 1
            self.scrollView.maximumZoomScale = 7
            
            self.imageViewEqualHeightConstraint.priority = 750
            self.imageViewAspectConstraint.priority = 250
            self.noteTextViewZeroHeightConstraint.priority = 999
            self.imageViewEqualWidthConstraint.constant = 0
            self.imageViewTopContraint.constant = 0
            self.dateCreatedLabelZeroHeightConstraint.priority = 999
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                self.view.layoutIfNeeded()
                self.view.backgroundColor = UIColor.blackColor()
            })
            
        }
        else {
            self.scrollView.setZoomScale(1, animated: true)
            self.scrollView.minimumZoomScale = 1
            self.scrollView.maximumZoomScale = 1
            
            self.imageViewEqualHeightConstraint.priority = 250
            self.imageViewAspectConstraint.priority = 750
            self.noteTextViewZeroHeightConstraint.priority = 1
            self.imageViewEqualWidthConstraint.constant = -20
            self.imageViewTopContraint.constant = 8
            self.dateCreatedLabelZeroHeightConstraint.priority = 1
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                self.view.layoutIfNeeded()
                self.view.backgroundColor = UIColor.whiteColor()
            })
        }
    }
    
    
    
    
    
    
    
    
    
    
}
