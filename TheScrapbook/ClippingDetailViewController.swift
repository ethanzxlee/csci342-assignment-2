//
//  ClippingDetailViewController.swift
//  TheScrapbook
//
//  Created by Zhe Xian Lee on 22/04/2016.
//  Copyright © 2016 Zhe Xian Lee. All rights reserved.
//

import UIKit

class ClippingDetailViewController: UIViewController, UIScrollViewDelegate {
    
    var image: UIImage?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var imageViewAspectConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewEqualHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noteTextViewZeroHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopContraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewEqualWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateCreatedLabelZeroHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setToolbarHidden(true, animated: true)
        
        imageView.image = image
       
    
        imageView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "didTapImageView:")
        imageView.addGestureRecognizer(tap)
        
    }
    
    var imageViewFullscreen = false
    
    func didTapImageView(gestureRecognizer: UITapGestureRecognizer) {
        noteTextView.resignFirstResponder()
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
    
    override func prefersStatusBarHidden() -> Bool {
        return imageViewFullscreen
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    

    
    
    
}
