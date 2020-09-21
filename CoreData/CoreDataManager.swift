//
//  CoreDataManager.swift
//  ShoppingPlanSingle
//
//  Created by Olexandr Baybuz on 14.02.2018.
//  Copyright © 2018 Olexandr Baybuz. All rights reserved.
//

import CoreData
import Foundation

class CoreDataManager {
    
    static let instance = CoreDataManager()
    
    private init() {}
    // Entity for Name
    
    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)!
    }
    
    // Fetched Results Controller for Entity Name
    func fetchedResultsController(entityName: String, keyForSort: String, predicate: NSPredicate?, ascending: Bool = true, localizedCaseInsensitiveCompare: Bool = true)  -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        var sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: ascending)
        if localizedCaseInsensitiveCompare {
            sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: ascending, selector: #selector(NSString.localizedCaseInsensitiveCompare))
        }
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let pr = predicate {
            fetchRequest.predicate = pr
        }
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }

    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    
    lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = Bundle.main.url(forResource: "ShoppingPlanSingle", withExtension: "momd") else {
            return nil
        }
        
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        return managedObjectModel
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel!)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."

        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: url!.path) {
            guard let defaultURL = Bundle.main.url(forResource: "SingleViewCoreData", withExtension: "sqlite")
              else { return coordinator }
           
            do {
                try fileManager.copyItem(at: defaultURL, to: url!)
            } catch {
               print("Don't copy file \(url!.path)")
            }
            
        }

        
        do {
            let options = [ NSInferMappingModelAutomaticallyOption : true,
                            NSMigratePersistentStoresAutomaticallyOption : true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject as AnyObject
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        managedObjectContext.performAndWait {
            do {
                if self.managedObjectContext.hasChanges {
                    try self.managedObjectContext.save()
                }
            } catch {
                let saveError = error as NSError
                print("save error \(saveError) == \(saveError.localizedDescription)")
            }
        }
    }
    
    
    func getWishList(favourite: Bool) -> [WishList]! {
        var predicate: NSPredicate!
        if favourite {
             predicate = NSPredicate(format: "favourite = %@", "1")
            
        }
        
        let fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "WishList", keyForSort: "name", predicate: predicate, ascending: true, localizedCaseInsensitiveCompare: true)
        do {
            try fetchedResultsController.performFetch()

        } catch {
            print(error)
            return nil
        }
        let wishList = fetchedResultsController.fetchedObjects as! [WishList]
        return wishList
    }
    
    
   
}
