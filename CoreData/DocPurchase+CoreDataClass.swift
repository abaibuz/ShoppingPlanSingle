//
//  DocPurchase+CoreDataClass.swift
//  ShoppingPlanSingle
//
//  Created by Olexandr Baybuz on 12.02.2018.
//  Copyright © 2018 Olexandr Baybuz. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DocPurchase)
public class DocPurchase: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "DocPurchase"),
                insertInto: CoreDataManager.instance.managedObjectContext)
    }
    
//-------------
    class func getTLineOfDoc(docPurchase: DocPurchase) -> NSFetchedResultsController<NSFetchRequestResult> {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TLine")
        
        let sortNumberLine = NSSortDescriptor(key: "numberLine", ascending: true)
        let sortSwitch = NSSortDescriptor(key: "switchLine", ascending: true)

        fetchRequest.sortDescriptors = [sortSwitch, sortNumberLine]
        
        let predicate = NSPredicate(format: "%K == %@", "doc", docPurchase)
        fetchRequest.predicate = predicate
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }

//--------------
    class func copyFromSource(dest: DocPurchase, source: DocumentPurchase) {
 //       dest.commentDoc = source.CommentDoc
 //       dest.dateDoc = source.DateDoc as NSDate
 //       dest.nameDoc = source.NameDoc
    }
    
    class func fetchManagedObjectForDocumentPurchase(index: Int, fetchedResultsControllerDoc: NSFetchedResultsController<NSFetchRequestResult>) -> NSManagedObject? {
        var managedObject: NSManagedObject?
        do {
            try fetchedResultsControllerDoc.performFetch()
            let results = fetchedResultsControllerDoc.fetchedObjects
            if results != nil {
                let indexPath = fetchedResultsControllerDoc.indexPath(forObject: results![index]) //
                managedObject = fetchedResultsControllerDoc.object(at: indexPath!) as? NSManagedObject
            }
        } catch {
            
        }
        return managedObject!
        
    }
 
//-----------
    class func getDoc(identifier : String) -> DocPurchase? {
        let condition = NSPredicate(format: "idDoc == %@", identifier)
        return getDocObject(where:  condition)
    }
    
    class func getDocObject(where condition: NSPredicate?)-> DocPurchase? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"DocPurchase")
        
        if let predicate = condition {
            fetchRequest.predicate = predicate
        }
        
        let note: DocPurchase?
        
        do {
            let fetchedResults  =  try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            note = fetchedResults.first as! DocPurchase?
        }
        catch {
            let fetchError = error as NSError
            note = nil
            print("\(fetchError),  \(fetchError.userInfo)")
        }
        return note
    }

}
