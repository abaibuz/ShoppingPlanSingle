//
//  DocPurchase+CoreDataProperties.swift
//  ShoppingPlanSingle
//
//  Created by Olexandr Baybuz on 12.02.2018.
//  Copyright © 2018 Olexandr Baybuz. All rights reserved.
//
//

import Foundation
import CoreData


extension DocPurchase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DocPurchase> {
        return NSFetchRequest<DocPurchase>(entityName: "DocPurchase")
    }

    @NSManaged public var comment: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var tline: NSSet?
    @NSManaged public var favourite: Bool
    @NSManaged public var purchasedNumber: Int16
    @NSManaged public var purchasedSum: Float
    @NSManaged public var scheduledNumber: Int16
    @NSManaged public var scheduledSum: Float
    @NSManaged public var checkImage: NSData?
    @NSManaged public var selected: Bool
}

// MARK: Generated accessors for tline
extension DocPurchase {

    @objc(addTlineObject:)
    @NSManaged public func addToTline(_ value: TLine)

    @objc(removeTlineObject:)
    @NSManaged public func removeFromTline(_ value: TLine)

    @objc(addTline:)
    @NSManaged public func addToTline(_ values: NSSet)

    @objc(removeTline:)
    @NSManaged public func removeFromTline(_ values: NSSet)

}
