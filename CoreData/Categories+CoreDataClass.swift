//
//  Categories+CoreDataClass.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 2/21/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Categories)
public class Categories: NSManagedObject {

    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Categories"),
                  insertInto: CoreDataManager.instance.managedObjectContext)
    }
    
}
