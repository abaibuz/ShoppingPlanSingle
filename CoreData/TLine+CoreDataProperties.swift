//
//  TLine+CoreDataProperties.swift
//  ShoppingPlanSingle
//
//  Created by Olexandr Baybuz on 12.02.2018.
//  Copyright © 2018 Olexandr Baybuz. All rights reserved.
//
//

import Foundation
import CoreData


extension TLine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TLine> {
        return NSFetchRequest<TLine>(entityName: "TLine")
    }

 
    @NSManaged public var numberLine: Int16
    @NSManaged public var priceProduct: Float
    @NSManaged public var quantityProduct: Float
    @NSManaged public var switchLine: Bool
    @NSManaged public var doc: DocPurchase?
    @NSManaged public var productLine: ProductsCD?
    @NSManaged public var unitLine: UnitCD?
}
