//
//  CollectionListEmptyBackgroundView.swift
//  TheScrapbook
//
//  Created by Zhe Xian Lee on 22/04/2016.
//  Copyright © 2016 Zhe Xian Lee. All rights reserved.
// 
//  References:
//  http://stackoverflow.com/questions/27056864/swift-subclass-uiview
//

import UIKit

/// A custom background view for table view when the table view is empty
class EmptyTableViewBackgroundView: UIView {

    var image: UIImage?
    var imageView: UIImageView?
    var message: String?
    var messageLabel: UILabel?
    
    convenience init (image: UIImage?, message: String?) {
        self.init(frame: CGRect.zero)
        
        self.image = image
        self.imageView?.image = self.image
        self.message = message
        self.messageLabel?.text = self.message
    }
    
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        // Setup the ImageView
        self.imageView = UIImageView()
        self.imageView!.translatesAutoresizingMaskIntoConstraints = false
        self.imageView!.contentMode = .ScaleAspectFit
        self.imageView?.alpha = 0.75
        
        self.addSubview(self.imageView!)
        
        // Setup the Label
        self.messageLabel = UILabel()
        self.messageLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.messageLabel?.textColor = UIColor(red: 0x44 / 255, green: 0x5C / 255, blue: 0x72 / 255, alpha: 1)
        self.messageLabel?.font = UIFont.systemFontOfSize(20, weight: UIFontWeightLight)
        self.messageLabel?.numberOfLines = 2
        self.messageLabel?.textAlignment = .Center
        
        self.addSubview(self.messageLabel!)
        
        self.addConstraints([
            NSLayoutConstraint(item: self.imageView!, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.imageView!, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.imageView!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 240),
            NSLayoutConstraint(item: self.imageView!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 240),
            NSLayoutConstraint(item: self.messageLabel!, attribute: .Top, relatedBy: .Equal, toItem: self.imageView, attribute: .Bottom, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: self.messageLabel!, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.messageLabel!, attribute: .Width, relatedBy: .LessThanOrEqual, toItem: self.imageView, attribute: .Width, multiplier: 1, constant: 0)
        ])
        self.alpha = 0

    }

    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    
    /**
        Make this view becomes visible with a fade animation
     */
    func show() {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.alpha = 1
        }
    }
    
    /**
        Make this view becomes invisible with a fade animation
    */
    func hide() {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.alpha = 0
        }
    }
    
}
