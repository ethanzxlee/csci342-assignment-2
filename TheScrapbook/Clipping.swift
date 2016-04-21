//
//  Clipping.swift
//  TheScrapbook
//
//  Created by Zhe Xian Lee on 18/04/2016.
//  Copyright © 2016 Zhe Xian Lee. All rights reserved.
//

import Foundation
import CoreData


class Clipping: NSManagedObject, CustomDebugStringConvertible {

    override var debugDescription: String {
        get {
            return "Note: \(self.note)\nImagePath: \(self.image)\nDateCreated: \(self.dateCreated)\n"
        }
    }

}
