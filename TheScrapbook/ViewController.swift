//
//  ViewController.swift
//  TheScrapbook
//
//  Created by Zhe Xian Lee on 18/04/2016.
//  Copyright © 2016 Zhe Xian Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var scrapbookModel : ScrapbookModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test the database
        
        // Obtain the ScrapbookModel instance
        scrapbookModel = ScrapbookModel.defaultModel
        
//        // Uncomment the following lines to test the search results
//        // Create two collections (named: 'A' and 'B')
//        let collectionA = scrapbookModel?.createCollectionWithName("A")
//        let collectionB = scrapbookModel?.createCollectionWithName("B")
//        
//        // Create three Clippings (with note values: “1 foo”, “2 foo” and “3 bar” with a random image in the assets)
//        let clip1 = scrapbookModel?.createClippingWithNotes("1 foo", image: UIImage(named: "95")!)
//        let clip2 = scrapbookModel?.createClippingWithNotes("2 foo", image: UIImage(named: "95")!)
//        let clip3 = scrapbookModel?.createClippingWithNotes("3 bar", image: UIImage(named: "95")!)
//        
//        // Fetch all the collections
//        // Print all the collections' name
//        debugPrint("Print the collections' name")
//        if let collections = scrapbookModel?.fetchAllCollections() {
//            for collection in collections {
//                debugPrint(collection)
//            }
//        }
//        debugPrint("")
//        
//        // Fetch all the clippings
//        // Print all the clippings
//        debugPrint("Print all the clippings")
//        if let clippings = scrapbookModel?.fetchAllClippings() {
//            for clipping in clippings {
//                debugPrint(clipping)
//            }
//        }
//        debugPrint("")
//        
//        // Add clipping 1 and 2 to collection A
//        scrapbookModel?.addClipping(clip1!, toCollection: collectionA!)
//        scrapbookModel?.addClipping(clip2!, toCollection: collectionA!)
//        
//        
//        // Print all the clippings in collection A
//        debugPrint("Print all the clippings in collection A")
//        if let _collectionA = collectionA {
//            if let clippings = _collectionA.clippings?.allObjects as? [Clipping] {
//                for clipping in clippings {
//                    debugPrint(clipping)
//                }
//            }
//        }
//        
//        // Delete Clipping 1
//        if let _clip1 = clip1 {
//            scrapbookModel?.deleteClipping(_clip1)
//        }
//        
//        // Print all the clippings in collection A
//        debugPrint("Print all the clippings in collection A")
//        if let _collectionA = collectionA {
//            if let clippings = _collectionA.clippings?.allObjects as? [Clipping] {
//                for clipping in clippings {
//                    debugPrint(clipping)
//                }
//            }
//        }
//        debugPrint("")
        
        // Search for and print all the clippings that contain the search term 'bar'
        debugPrint("Search for and print all the clippings that contain the search term 'bar'")
        if let clippingsContainBar = scrapbookModel?.searchClippingContainsNote("bar") {
            for clipping in clippingsContainBar {
                debugPrint(clipping)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

