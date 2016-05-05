//
//  ClippingListTableViewCell.swift
//  TheScrapbook
//
//  Created by Zhe Xian Lee on 23/04/2016.
//  Copyright © 2016 Zhe Xian Lee. All rights reserved.
//

import UIKit

class ClippingListTableViewCell: UITableViewCell {

    @IBOutlet weak var clippingImageView: UIImageView!
    @IBOutlet weak var clippingNoteLabel: UILabel!
    @IBOutlet weak var clippingDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0xE8 / 255, green: 0xE3 / 255, blue: 0xFE / 255, alpha: 1)
        self.selectedBackgroundView = backgroundView
        
        self.clippingImageView.layer.cornerRadius = 24
        self.clippingImageView.layer.masksToBounds = true
    }

   

}
