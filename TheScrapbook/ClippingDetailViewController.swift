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
        imageViewFullscreen = !imageViewFullscreen
        self.navigationController?.setNavigationBarHidden(imageViewFullscreen, animated: true)
        
        if (imageViewFullscreen) {
            self.scrollView.minimumZoomScale = 1
            self.scrollView.maximumZoomScale = 7
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.imageViewEqualHeightConstraint.priority = 750
                self.imageViewAspectConstraint.priority = 250
            })
            
        }
        else {
            self.scrollView.setZoomScale(1, animated: true)
            self.scrollView.minimumZoomScale = 1
            self.scrollView.maximumZoomScale = 1
        
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.imageViewEqualHeightConstraint.priority = 250
                self.imageViewAspectConstraint.priority = 750
            })
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return imageViewFullscreen
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    
    
}
