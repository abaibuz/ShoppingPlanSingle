//
//  AddAndEditDokViewController.swift
//  ShoppingPlanSingle
//
//  Created by Olexandr Baybuz on 28.11.2017.
//  Copyright © 2017 Olexandr Baybuz. All rights reserved.
//

import UIKit

class AddAndEditDokViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,  DataControllerDocDelegate {
    
    public var dataController: DataController!
    public var document: DocumentPurchase?
    var task = NoteModificationTask.create
    public var dataControllerDoc = DataControllerDoc()
    public var docCoreData: DocPurchase?
    private var dateDoc = Date()
    
    @IBOutlet weak var productTable: UITableView!
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        copyDataFromFieldToDoc()
        DispatchQueue.main.async {
            CoreDataManager.instance.saveContext()
        }
    }
    
    private func copyDataFromFieldToDoc() {
        if docCoreData == nil  {
            docCoreData = DocPurchase()
        }
        docCoreData?.name = nameText.text
        docCoreData?.comment = commentDoc.text
        docCoreData?.date = dateDoc as NSDate
    }
    
    func DataDocSourceChanged(dataSourceDoc: DocumentPurchase?, error: Error?) {
        if let doc = dataSourceDoc {
            self.document = doc
            sortDoc()
        }
    }
    
    func sortDoc() {
        if let sortTable = self.document?.TableDoc.tableLines.sorted(by: sortTableLines) {
            self.document?.TableDoc.tableLines = sortTable
            calcTotalParam()
        }
        
        DispatchQueue.main.async {
            self.productTable.reloadData()
        }
    }
    
    func sortTableLines(this: TableLine, that: TableLine) -> Bool {
        if !this.switchLine && that.switchLine {
            return true
        }
        if this.switchLine && !that.switchLine {
            return false
        }
        return this.NumberLine < that.NumberLine
    }
    
    
    func calcTotalParam() {
        if let tableDoc = self.document?.TableDoc {
            let countChecked = tableDoc.countChecked()
            let countUnchecked = tableDoc.countUnchecked()
            let totalRow = countChecked + countUnchecked
            self.productNumber.text = "\(countChecked)/\(totalRow)"
            let sumChecked = tableDoc.sumChecked()
            let sumTotal = sumChecked + tableDoc.sumUnchecked()
            self.totalSum.text = "\(sumChecked)/\(sumTotal)"
        } else {
            self.productNumber.text = "0/0"
            self.totalSum.text = "0.00/0.00"
        }
    }
    
    func parentViewCell(uiView: UIView) -> UITableViewCell? {
        var viewOrNil: UIView? = uiView
        while let view = viewOrNil {
            if let cellView = view as? UITableViewCell {
                return cellView
            }
            viewOrNil = view.superview
        }
        return nil
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if let cell = parentViewCell(uiView: sender) {
            if let indexPath = productTable.indexPath(for: cell) {
                if var tableLine = document?.TableDoc.tableLines[indexPath.row] {
                    tableLine.switchLine = sender.isOn
                    document?.TableDoc.tableLines[indexPath.row] = tableLine
                    self.dataControllerDoc.modifyDoc(lineTableDoc: tableLine, task: .edit)
                    sortDoc()
                }
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let productCount = document?.TableDoc.tableLines.count {
            return productCount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell")! as! RowTableViewCellForDocPurchase
        if let tableLine = document?.TableDoc.tableLines[indexPath.row] {
            if tableLine.switchLine {
                cell.backgroundColor = UIColor.green
            }
            else {
                cell.backgroundColor = UIColor.cyan
            }
          cell.productLabel.text = tableLine.NameProduct
          cell.unitLabel.text = tableLine.UnitProduct
          cell.quantityLabel.text = convertingData().returnFloatToString(floatIn: tableLine.QuantityProduct, fractionDigits: 3)
          cell.priceLabel.text = convertingData().returnFloatToString(floatIn: tableLine.PriceProduct, fractionDigits: 2)
          cell.sumLabel.text = convertingData().returnFloatToString(floatIn: tableLine.QuantityProduct * tableLine.PriceProduct, fractionDigits: 2)
          cell.switchLabel.on =  tableLine.switchLine
        }
        
        return cell
    }
    
    @IBAction func addRowTableButtom(_ sender: Any) {
   //     performSegue(withIdentifier: "EditRowTable", sender: nil)
    }
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var dateTime: UILabel!
    
    @IBOutlet weak var commentDoc: UITextField!
    
    @IBOutlet weak var productNumber: UILabel!
    
    @IBOutlet weak var totalSum: UILabel!
    
//--------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
 
        if let doc = self.docCoreData {
            dateTime.text = (doc.date! as Date).convertDateToString
            nameText.text = doc.name
            commentDoc.text = doc.comment
            dateDoc = doc.date! as Date
            DispatchQueue.main.async {
                    self.productTable.reloadData()
            }
        } else {
         //  self.nameText.text = "Покупка"
   //        let tableLines = TableLines(tableLines: [])
   //        self.document = DocumentPurchase(idDoc: NSUUID().uuidString, dateDoc: Date(), nameDoc: self.nameText.text!, commentDoc: "", tableDoc: tableLines)
           self.dateTime.text = Date().convertDateAndTimeToString
           dateDoc = Date()
    //       dataController.modify(doc: self.document!, task: .create)
    //       task = .edit
        }
    //    calcTotalParam()
    //    dataControllerDoc.delegateDoc = self
    //    dataControllerDoc.document = document!
    //    docCoreData = DocPurchase.getDoc(identifier: (document?.IdDoc)!)
    //    dataControllerDoc.docCoreData = docCoreData
        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(document?.TableDoc.tableLines[indexPath.row].switchLine)! {
            performSegue(withIdentifier: "EditRowTable", sender: indexPath.row)
        }
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            dataControllerDoc.modifyDoc(lineTableDoc: (self.document?.TableDoc.tableLines[indexPath.row])!, task: .delete)
//        }
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       
        if (document?.TableDoc.tableLines[indexPath.row].switchLine)! {
            return []
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Удалить") {
            _, indexPath in
            self.dataControllerDoc.modifyDoc(lineTableDoc: (self.document?.TableDoc.tableLines[indexPath.row])!, task: .delete)
    //        tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
        return [deleteAction]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    /*    self.document?.NameDoc = nameText.text!
        self.document?.CommentDoc = commentDoc.text!
        dataController.modify(doc: self.document!, task: task)
        dataControllerDoc.document = document!
        task = .edit
    */
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let composeVC = segue.destination as? AddAndEditRowTableProductDoc {
            if segue.identifier == "EditRowTable" {
                dataControllerDoc.document = document!
                dataControllerDoc.docCoreData = docCoreData
                composeVC.dataControllerDoc = dataControllerDoc
                if let productCount = document?.TableDoc.tableLines.count {
                    composeVC.numberLine = Int16(productCount)
                } else {
                    composeVC.numberLine = 0
                }
                composeVC.docPurchase = docCoreData
                if let index = sender as? Int {
//                    composeVC.tLine = document?.TableDoc.tableLines[index]
                }
            }
        }
    }
    
}
