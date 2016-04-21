//
//  Collection.swift
//  TheScrapbook
//
//  Created by Zhe Xian Lee on 18/04/2016.
//  Copyright © 2016 Zhe Xian Lee. All rights reserved.
//

import Foundation
import CoreData


class Collection: NSManagedObject, CustomDebugStringConvertible {

    override var debugDescription: String {
        get {
            return "Name: \(self.name)"
        }
    }

}
