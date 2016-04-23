//
//  ClippingDetailViewController.swift
//  TheScrapbook
//
//  Created by Zhe Xian Lee on 22/04/2016.
//  Copyright © 2016 Zhe Xian Lee. All rights reserved.
//

import UIKit

class ClippingDetailViewController: UIViewController, UIScrollViewDelegate {
    
    let scrapbookModel = ScrapbookModel.defaultModel
    
    var collection: Collection?
    var clipping: Clipping?
    var image: UIImage?
    var imageViewFullscreen = false
    
    
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
            noteTextView.text = clipping?.note
        }
        
        // Setup the image view
        imageView.image = image
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

    
    // MARK: - UIScrollViewDelegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    
    // MARK: - IBActions
    
    @IBOutlet weak var didTouchDeleteBarButtonItem: UIBarButtonItem!

    
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
           
            guard let image = image else {
                return
            }
            
            if (clipping == nil) {
                if let newClipping = scrapbookModel?.createClippingWithNotes(noteTextView.text, image: image) {
                    clippingListViewController.clippings.append(newClipping)
                    
                    if (collection != nil) {
                        scrapbookModel?.addClipping(newClipping, toCollection: collection!)
                    }
                }
                else {
                    // TODO: update the clipping
                    
                }
                
                
                clippingListViewController.tableView.reloadData()
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
