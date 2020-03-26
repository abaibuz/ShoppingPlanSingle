//
//  DataController.swift
//  ShoppingPlanSingle
//
//  Created by Olexandr Baybuz on 29.11.2017.
//  Copyright © 2017 Olexandr Baybuz. All rights reserved.
//

import Foundation
import CoreData

enum NoteModificationTask {
    case create
    case edit
    case delete
    case load
}

protocol DataControllerdelegate {
    func DataSourceChanged(dataSource:[DocumentPurchase]?, error:Error?)
}

class DataController {
    var  documents: [DocumentPurchase] = []
    var  delegate:DataControllerdelegate?
    var  fetchedResultsControllerDoc = CoreDataManager.instance.fetchedResultsController(entityName: "DocPurchase", keyForSort: "dateDoc", predicate: nil)
    
    func getDocuments() {
        do {
            try fetchedResultsControllerDoc.performFetch()
            
            let results = fetchedResultsControllerDoc.fetchedObjects
            if results != nil {
                for result in results as! [DocPurchase] {
                    let doc = DocumentPurchase(docCoreData: result)
                    modify(doc: doc, task:.load)
                }
                self.delegate?.DataSourceChanged(dataSource: self.documents, error: nil)
            }
            
        } catch {
            //print(error)
        }
    }
    
    func modify(doc: DocumentPurchase, task: NoteModificationTask) {
        switch task {
        case .load:
            documents.append(doc)
            break

        case .create:
            documents.append(doc)
            let docPurchase = DocPurchase()
            DocPurchase.copyFromSource(dest: docPurchase, source: doc)
            break

        case .edit:
            if let index = documents.index(where: {$0==doc}) {
                documents[index] = doc
  //              let managedObject = DocPurchase.fetchManagedObjectForDocumentPurchase(index: index, fetchedResultsControllerDoc: fetchedResultsControllerDoc)
                let managedObject = DocPurchase.getDoc(identifier: doc.IdDoc)
                if managedObject != nil {
                    DocPurchase.copyFromSource(dest: managedObject!, source: doc)
                }
            }
            break
    
        case .delete:
            if let index = documents.index(where: {$0==doc}) {
                documents.remove(at:index)
//                let managedObject = DocPurchase.fetchManagedObjectForDocumentPurchase(index: index, fetchedResultsControllerDoc: fetchedResultsControllerDoc)
                let managedObject = DocPurchase.getDoc(identifier: doc.IdDoc)
                if managedObject != nil {
                    CoreDataManager.instance.managedObjectContext.delete(managedObject!)
                }
            break
            }
        }
        self.delegate?.DataSourceChanged(dataSource:documents, error:nil)
        CoreDataManager.instance.saveContext()
    }
}


protocol DataControllerDocDelegate {
    func DataDocSourceChanged(dataSourceDoc: DocumentPurchase?, error:Error?)
}

class DataControllerDoc {
    
    var document = DocumentPurchase()
    var delegateDoc: DataControllerDocDelegate?
    var docCoreData: DocPurchase?
    
  //  var fetchedResultsControllerDoc = CoreDataManager.instance.fetchedResultsController(entityName: "TLine", keyForSort: "numberLine")

    func modifyDoc(lineTableDoc: TableLine, task: NoteModificationTask) {
        var tableDocLines = self.document.TableDoc.tableLines
        switch task {
        case .create:
            tableDocLines.append(lineTableDoc)
            let tLine = TLine();
            TLine.copyFromSource(dest: tLine, source: lineTableDoc, docCoreData: self.docCoreData!)
            break
            
        case .edit:
            if let index = tableDocLines.index(where: {$0==lineTableDoc}) {
                tableDocLines[index] = lineTableDoc
                let tLine = TLine.getTLine(docCoreData: self.docCoreData!, index: lineTableDoc.NumberLine)
                if tLine != nil {
                    TLine.copyFromSource(dest: tLine! as! TLine, source: lineTableDoc, docCoreData: self.docCoreData!)
                }
            }
            break
            
        case .delete:
            if let index = tableDocLines.index(where: {$0==lineTableDoc}) {
                tableDocLines.remove(at:index)
                let managedObject = TLine.getTLine(docCoreData: self.docCoreData!, index: lineTableDoc.NumberLine)
                if managedObject != nil {
                    CoreDataManager.instance.managedObjectContext.delete(managedObject!)
                }
            }
            break
            
        case .load:
            break
        }
        
        self.document.TableDoc.tableLines = tableDocLines
        self.delegateDoc?.DataDocSourceChanged(dataSourceDoc:self.document, error:nil)
        CoreDataManager.instance.saveContext()
        
    }
}


