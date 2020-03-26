//
//  WishList+CoreDataClass.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 5/19/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//
//

import Foundation
import CoreData

@objc(WishList)
public class WishList: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "WishList"),
                  insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
