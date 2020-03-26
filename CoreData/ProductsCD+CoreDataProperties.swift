//
//  ProductsCD+CoreDataProperties.swift
//  ShoppingPlanSingle
//
//  Created by Olexandr Baybuz on 14.06.2018.
//  Copyright © 2018 Olexandr Baybuz. All rights reserved.
//
//

import Foundation
import CoreData


extension ProductsCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductsCD> {
        return NSFetchRequest<ProductsCD>(entityName: "ProductsCD")
    }

    @NSManaged public var name: String?
    @NSManaged public var quantity: Float
    @NSManaged public var sum: Float
    @NSManaged public var image: NSData?
    @NSManaged public var unit: UnitCD?
    @NSManaged public var favourite: Bool
    @NSManaged public var category: Categories?
    @NSManaged public var selected: Bool
}
