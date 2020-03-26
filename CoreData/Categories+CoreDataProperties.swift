//
//  Categories+CoreDataProperties.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 2/21/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//
//

import Foundation
import CoreData


extension Categories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Categories> {
        return NSFetchRequest<Categories>(entityName: "Categories")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: NSData?
    @NSManaged public var favourite: Bool
    @NSManaged public var selected: Bool
}
