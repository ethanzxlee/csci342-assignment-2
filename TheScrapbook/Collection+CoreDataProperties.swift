//
//  Collection+CoreDataProperties.swift
//  TheScrapbook
//
//  Created by Zhe Xian Lee on 20/04/2016.
//  Copyright © 2016 Zhe Xian Lee. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Collection {

    @NSManaged var name: String?
    @NSManaged var clippings: NSSet?

}
