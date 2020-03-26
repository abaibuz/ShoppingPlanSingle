//
//  UnitCD+CoreDataProperties.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 13.05.2018.
//  Copyright © 2018 Olexandr Baybuz. All rights reserved.
//
//

import Foundation
import CoreData


extension UnitCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UnitCD> {
        return NSFetchRequest<UnitCD>(entityName: "UnitCD")
    }

    @NSManaged public var shortname: String
    @NSManaged public var fullname: String?
    @NSManaged public var favourite: Bool
    @NSManaged public var selected: Bool
    
}
