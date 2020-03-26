//
//  WishList+CoreDataProperties.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 5/19/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//
//

import Foundation
import CoreData


extension WishList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WishList> {
        return NSFetchRequest<WishList>(entityName: "WishList")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var quantity: Float
    @NSManaged public var wishListProducts: ProductsCD?
    @NSManaged public var favourite: Bool
    @NSManaged public var selected: Bool
}

