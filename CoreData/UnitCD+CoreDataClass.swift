//
//  UnitCD+CoreDataClass.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 13.05.2018.
//  Copyright © 2018 Olexandr Baybuz. All rights reserved.
//
//

import Foundation
import CoreData

@objc(UnitCD)

public class UnitCD: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "UnitCD"),
                  insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
