//
//  CollectionTableViewCell.swift
//  TheScrapbook
//
//  Created by Zhe Xian Lee on 21/04/2016.
//  Copyright © 2016 Zhe Xian Lee. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let backgroundView = UIView() // e8e3fe
        backgroundView.backgroundColor = UIColor(red: 0xE8 / 255, green: 0xE3 / 255, blue: 0xFE / 255, alpha: 1)
        self.selectedBackgroundView = backgroundView
    }
    

}
