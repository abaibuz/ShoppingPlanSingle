//
//  LineTable.swift
//  ShoppingPlanSingle
//
//  Created by Olexandr Baybuz on 29.11.2017.
//  Copyright © 2017 Olexandr Baybuz. All rights reserved.
//

import Foundation
import CoreData
public struct TableLine {
    public let DocID: String
    public let NumberLine: Int
    public let NameProduct: String
    public let UnitProduct: String
    public let QuantityProduct: Float
    public let PriceProduct: Float
    public var switchLine: Bool
    
    static func == (left:TableLine, right:TableLine) -> Bool {
        return (left.DocID == right.DocID) && (left.NumberLine == right.NumberLine)
    }
    
    public init(docID: String, numberLine: Int, nameProduct: String, unitProduct: String, quantityProduct: Float, priceProduct: Float, switchLine: Bool) {
        self.DocID = docID
        self.NumberLine = numberLine
        self.NameProduct = nameProduct
        self.UnitProduct = unitProduct
        self.QuantityProduct = quantityProduct
        self.PriceProduct = priceProduct
        self.switchLine = switchLine
    }
    
}

public struct TableLines {
    var tableLines:[TableLine]
    
    public init() {
        self.tableLines = []
    }

    public init(tableLines:[TableLine]) {
        self.tableLines = tableLines
    }
    
    public func countChecked() -> Int {
        var retValue = 0
        for tableLine in tableLines {
            if tableLine.switchLine {
                retValue += 1
            }
        }
        return retValue
     }
    
    public func countUnchecked() -> Int {
        var retValue = 0
        for tableLine in tableLines {
            if !tableLine.switchLine {
                retValue += 1
            }
        }
        return retValue
    }
    
    public func sumChecked() -> Float {
        var retValue: Float
        retValue = 0.00
        for tableLine in tableLines {
            if tableLine.switchLine {
                retValue += (tableLine.QuantityProduct * tableLine.PriceProduct)
            }
        }
        return retValue
    }
    
    public func sumUnchecked() -> Float {
        var retValue: Float
        retValue = 0.00
        for tableLine in tableLines {
            if !tableLine.switchLine {
                retValue += (tableLine.QuantityProduct * tableLine.PriceProduct)
            }
        }
        return retValue
    }

}

public struct DocumentPurchase {
    public var IdDoc: String!
    public var DateDoc: Date!
    public var NameDoc: String!
    public var CommentDoc: String!
    public var TableDoc: TableLines!
 
    static func == (left:DocumentPurchase, right:DocumentPurchase) -> Bool {
        return left.IdDoc == right.IdDoc
    }
  
    
    public init() {
        self.IdDoc = UUID().uuidString
        self.CommentDoc = ""
        self.DateDoc = Date()
        self.NameDoc = ""
        self.TableDoc = TableLines()
    }
    
    public init(idDoc:String, dateDoc: Date, nameDoc:String, commentDoc: String, tableDoc: TableLines) {
        self.IdDoc = idDoc
        self.DateDoc = dateDoc
        self.NameDoc = nameDoc
        self.CommentDoc = commentDoc
        self.TableDoc = tableDoc
    }
    
    public init(docCoreData: DocPurchase) {
     //   self.IdDoc = docCoreData.idDoc!
     //   self.CommentDoc = docCoreData.commentDoc!
     //   self.DateDoc = docCoreData.dateDoc! as Date
     //   self.NameDoc = docCoreData.nameDoc!
        self.TableDoc = TableLines()
        var tLines: NSFetchedResultsController<NSFetchRequestResult>
        tLines = DocPurchase.getTLineOfDoc(docPurchase: docCoreData)
        
        do {
            try tLines.performFetch()
            let results = tLines.fetchedObjects
            for tLine in results as! [TLine] {
    //            let tableLine = TableLine(docID: self.IdDoc, numberLine: Int(tLine.numberLine), nameProduct: (tLine.productCD?.name)!, unitProduct: (tLine.unitCD?.shortname)!, quantityProduct: tLine.quantityProduct, priceProduct: tLine.priceProduct, switchLine: tLine.switchLine)
    //            self.TableDoc.tableLines.append(tableLine)
            }
        } catch {
        //    print(error)
        }
        
    }

    
    public func returnDateDocString(dateIn: Date?) -> String {
        var date: Date
        if dateIn == nil {
           date = self.DateDoc
        } else {
            date = dateIn!
        }
    
        let dateformatter = DateFormatter()
    
        dateformatter.dateStyle = DateFormatter.Style.short
    
        dateformatter.timeStyle = DateFormatter.Style.short
    
        let now = dateformatter.string(from: date)
    
        return now
    
    }
 
}

