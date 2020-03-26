//
//  ProductsCD+CoreDataClass.swift
//  ShoppingPlanSingle
//
//  Created by Olexandr Baybuz on 14.06.2018.
//  Copyright © 2018 Olexandr Baybuz. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ProductsCD)

public class ProductsCD: NSManagedObject {
    
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "ProductsCD"),
                  insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
