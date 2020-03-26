//
//  TLine+CoreDataClass.swift
//  ShoppingPlanSingle
//
//  Created by Olexandr Baybuz on 12.02.2018.
//  Copyright © 2018 Olexandr Baybuz. All rights reserved.
//
//

import Foundation
import CoreData

@objc(TLine)
public class TLine: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "TLine"),
                  insertInto: CoreDataManager.instance.managedObjectContext)
    }
    
    class func copyFromSource(dest: TLine, source: TableLine, docCoreData: DocPurchase) {
        dest.doc = docCoreData
  //      dest.nameProduct = source.NameProduct
        dest.numberLine = Int16(source.NumberLine)
        dest.priceProduct = source.PriceProduct
        dest.quantityProduct = source.QuantityProduct
        dest.switchLine = source.switchLine
  //      dest.unitProduct = source.UnitProduct
    }
    
    class func getTLine(docCoreData: DocPurchase, index: Int) -> NSManagedObject? {
   //     let condition = NSPredicate(format: "doc == %@ AND numberLine == %@)", docCoreData, index)
        let tLines =  DocPurchase.getTLineOfDoc(docPurchase: docCoreData)
        do {
            try tLines.performFetch()
            let results = tLines.fetchedObjects
            for tLine in results as! [TLine] {
                if tLine.numberLine == Int16(index) {
                    let indexPath = tLines.indexPath(forObject: tLine) //
                    let managedObject = tLines.object(at: indexPath!) as? NSManagedObject
                    return managedObject
                }
            }
        } catch {
            //    print(error)
        }
        
        return nil
    }
    
    class func copyFromProductsCD(dest: TLine, source: ProductsCD, doc: DocPurchase) {
        dest.doc = doc
        dest.productLine = source
        dest.priceProduct = source.sum
        dest.quantityProduct = source.quantity
     //   dest.switchLine = source.favourite
        dest.unitLine = source.unit
    }

    
    
 }
