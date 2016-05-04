//
//  ScrapbookModel.swift
//  TheScrapbook
//
//  Created by Zhe Xian Lee on 18/04/2016.
//  Copyright © 2016 Zhe Xian Lee. All rights reserved.
//
//  References:
//  Resize Image - http://nshipster.com/image-resizing/
//

import UIKit
import CoreData


class ScrapbookModel {
    
    static let defaultModel = ScrapbookModel()
    
    var managedObjectContext : NSManagedObjectContext?
    var documentDirectory : NSURL?
    
    private init?() {
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
            return nil
        }
        
        guard let documentDirectoryFound = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first else {
            return nil
        }
        
        managedObjectContext = appDelegate.managedObjectContext
        documentDirectory = documentDirectoryFound
    }
    
   
    /**
        Create a new collection
     
        - Parameters:
            - name: Name of the collection
     
        - Returns: the Collection if the creation was successful, otherwise nil
     */
    func createCollectionWithName(name: String) -> Collection? {
        guard let collection = NSEntityDescription.insertNewObjectForEntityForName("Collection", inManagedObjectContext: self.managedObjectContext!) as? Collection else {
            return nil
        }
        
        collection.name = name;
       
        do {
            try self.managedObjectContext?.save()
        }
        catch {
            return nil
        }
        
        return collection
    }
    

    /**
        Fetch all the collections.
    
        - Returns: An array of Collection, otherwise nil if the fetch request failed
    */
    func fetchAllCollections() -> [Collection]? {
        let fetchRequest = NSFetchRequest(entityName: "Collection")
    
        do {
            return try self.managedObjectContext?.executeFetchRequest(fetchRequest) as? [Collection]
        }
        catch {
            return nil
        }
    }
    
    
    /**
        Create a new clipping.
        
        - Parameters:
            - notes: Notes of the clipping
            - image: Image of the clipping

        - Returns: the Clipping if the creation was successful, otherwise nil

    */
    func createClippingWithNotes(notes: String, image: UIImage) -> Clipping? {
        // Create filename by using epoch time
        let epochTime = UInt64(NSDate().timeIntervalSince1970 * 1000)
        let imageFilename = "\(epochTime).jpg"
        
        // Thumbnail
        let thumbnailSize = CGSize(width: 50, height: 50);
        UIGraphicsBeginImageContextWithOptions(thumbnailSize, false, 0.0)
        image.drawInRect(CGRect(origin: CGPointZero, size: thumbnailSize))

        let thumbnailImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Appending the filename to the document directory
        guard let thumbnailUrl = self.documentDirectory?.URLByAppendingPathComponent(imageFilename + ".thumb") else {
            return nil;
        }

        guard let imageUrl = self.documentDirectory?.URLByAppendingPathComponent(imageFilename) else {
            return nil
        }
    
        // Generates JPEG representation of the UIImage
        guard let imageJpegRepresentation = UIImageJPEGRepresentation(image, 0.8) else {
            return nil
        }
        
        guard let thumbnailJpegRepresentation = UIImageJPEGRepresentation(thumbnailImage, 0.8) else {
            return nil
        }
    
        // Writes the JPEG file to disk
        if (!imageJpegRepresentation.writeToURL(imageUrl, atomically: true)) {
            return nil
        }
        
        if (!thumbnailJpegRepresentation.writeToURL(thumbnailUrl, atomically: true)) {
            return nil
        }
    
        // Creates a Clipping entity
        guard let clipping = NSEntityDescription.insertNewObjectForEntityForName("Clipping", inManagedObjectContext: self.managedObjectContext!) as? Clipping else {
            // Deletes the JPEG file wrote to disk if the Clipping entity was failed to create
            do {
                try NSFileManager.defaultManager().removeItemAtURL(imageUrl)
                try NSFileManager.defaultManager().removeItemAtURL(thumbnailUrl)
            }
            catch {}
            return nil
        }
        
        clipping.image = imageFilename
        clipping.note = notes
        clipping.dateCreated = NSDate()
        
        do {
            try managedObjectContext?.save()
        }
        catch {
            // Deletes the JPEG file wrote to disk if the context was failed to save
            do {
                try NSFileManager.defaultManager().removeItemAtURL(imageUrl)
                try NSFileManager.defaultManager().removeItemAtURL(thumbnailUrl)
            }
            catch {}
            return nil
        }

        return clipping
    }
    
    
    /**
        Fetch all the clipping.
     
        - Returns: An array of Clipping, otherwise nil if the fetch request failed
     */
    func fetchAllClippings() -> [Clipping]? {
        let fetchRequest = NSFetchRequest(entityName: "Clipping")
        
        do {
            return try self.managedObjectContext?.executeFetchRequest(fetchRequest) as? [Clipping]
        }
        catch {
            return nil
        }
    }
    
    
    /**
        Fetch all the clipping in the specified collection
     
        - Parameters:
            - collection: The collection to be searched
     
        - Returns: An array of Clipping, otherwise nil if the fetch request failed
     */
    func fetchAllClippingsInCollection(collection: Collection) -> [Clipping]? {
        let predicate = NSPredicate(format: "belongsTo = %@", collection)
        
        let fetchRequest = NSFetchRequest(entityName: "Clipping")
        fetchRequest.predicate = predicate
        
        do {
            return try self.managedObjectContext?.executeFetchRequest(fetchRequest) as? [Clipping]
        }
        catch {
            return nil
        }
    }
    
    
    /**
        Add a Clipping to a Collection
    
        - Parameters:
            - clipping: The Clipping which you want to add to a collection
            - toCollection: The Collection which you want to add the Clipping to 
     
        - Returns: true if the operation was successful, otherwise false
    
    */
    func addClipping(clipping: Clipping, toCollection collection: Collection) -> Bool {
        //collection.mutableSetValueForKey("clippings").addObject(clipping)
        clipping.belongsTo = collection
        
        do {
            try managedObjectContext?.save()
        }
        catch {
            return false
        }
        return true
    }
    
    
    /**
        Delete a Collection, including of the Clippings in the collection
     
        - Returns: true if the deletion was successful, otherwise false
    */
    func deleteCollection(collection: Collection) -> Bool {
        // Gets the image file, so that they can be deleted
        var imageFiles = [NSURL]()
        if let clippings = collection.clippings {
            for clipping in clippings {
                if let _clipping = clipping as? Clipping {
                    if let _image = _clipping.image {
                        imageFiles.append((self.documentDirectory?.URLByAppendingPathComponent(_image))!)
                        imageFiles.append((self.documentDirectory?.URLByAppendingPathComponent(_image + ".thumb"))!)
                    }
                }
            }
        }
        
        // Deletes the Collection
        managedObjectContext?.deleteObject(collection)
        
        // Commits the deletion
        do {
            try managedObjectContext?.save()
            for imageFile in imageFiles {
                try NSFileManager.defaultManager().removeItemAtURL(imageFile)
            }
        }
        catch {
            return false
        }
        
        return true
    }
    
    
    /**
        Delete a Clipping
     
        - Returns: true if the deletion was sucessful, otherwise false
     */
    func deleteClipping(clipping: Clipping) -> Bool {
        // Gets the image file URL so that it can be deleted after the record in DB is deleted
        var imageFileURL: NSURL?
        var thumbnailFileURL: NSURL?
        if let _image = clipping.image {
            imageFileURL = self.documentDirectory?.URLByAppendingPathComponent(_image)
            thumbnailFileURL = self.documentDirectory?.URLByAppendingPathComponent(_image + ".thumb")
        }
        
        managedObjectContext?.deleteObject(clipping)
        
        do {
            try managedObjectContext?.save()
            if let _imageFileURL = imageFileURL {
                try NSFileManager.defaultManager().removeItemAtURL(_imageFileURL)
            }
            if let _thumbnailFileURL = thumbnailFileURL {
                try NSFileManager.defaultManager().removeItemAtURL(_thumbnailFileURL)
            }
        }
        catch {
            return false
        }
        
        return true
    }
    
    
    /**
        Search all clippings whos notes attribute contains a provided search string. The search is case insensitive.
     
        - Parameters:
            - note: Search string
     
        - Returns: The array of Clipping if there's matching Clipping otherwise nil
    */
    func searchClippingContainsNote(note: String) -> [Clipping]? {
        // NSPredicates to search the notes (case insensitive)
        let containsNotePredicate = NSPredicate(format: "note CONTAINS[c] %@", note)
        
        // Create the fetch request
        let fetchRequest = NSFetchRequest(entityName: "Clipping")
        fetchRequest.predicate = containsNotePredicate
        
        do {
            return try self.managedObjectContext?.executeFetchRequest(fetchRequest) as? [Clipping]
        }
        catch {
            return nil
        }
    }
    
    
    /**
        Search all clippings whos notes attribute contains a provided search string in the specified collection. The search is case insensitive.
     
        - Parameters:
            - note: Search string
            - inCollection: Search within this collection
     
        - Returns: The array of Clipping if there's matching Clipping otherwise nil
     */
    func searchClippingContainsNote(note: String, inCollection collection: Collection) -> [Clipping]? {
        // NSPredicates to search the notes (case insensitive)
        let containsNotePredicate = NSPredicate(format: "(note CONTAINS[c] %@) AND (belongsTo = %@)", note, collection)
        
        // Create the fetch request
        let fetchRequest = NSFetchRequest(entityName: "Clipping")
        fetchRequest.predicate = containsNotePredicate
        
        do {
            return try self.managedObjectContext?.executeFetchRequest(fetchRequest) as? [Clipping]
        }
        catch {
            return nil
        }

    }

}
