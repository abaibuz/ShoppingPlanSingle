//
//  AddAndEditRowTableProductDoc.swift
//  ShoppingPlanSingle
//
//  Created by Olexandr Baybuz on 11.12.2017.
//  Copyright © 2017 Olexandr Baybuz. All rights reserved.
//

import UIKit

class AddAndEditRowTableProductDoc: UIViewController {
    public var tLine : TLine?

    public var numberLine: Int16 = 0
    public var docPurchase: DocPurchase?
    var product: ProductsCD?
    var unit: UnitCD?

    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var produckTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var sumTextField: UITextField!
    
    
    public var dataControllerDoc: DataControllerDoc!
    @IBAction func endEditSum(_ sender: Any) {
        calculateSum()
    }
    @IBAction func endEditPrice(_ sender: Any) {
        calculateSum()
    }
    @IBAction func endEditQuantity(_ sender: Any) {
        calculateSum()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func choiceTapped(_ sender: Any) {
        if savetLine() {
            cancelTapped(sender)
        }
        
    }
    
    @IBAction func choiceProductTapped(_ sender: Any){
    }
    
    
    @IBAction func clearUnitTapped(_ sender: Any) {
        unit = nil
        unitTextField.text = ""
        
    }
    
    @IBAction func ChoiceUnitTapped(_ sender: Any) {
        performSegue(withIdentifier: "unitsChoice", sender: unit)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unitsChoice" {
            let controller = segue.destination.children[0] as! unitsCatalog
            controller.unit = unit
            controller.didSelect = { [unowned self] (unitArray) in
                for  unit1 in unitArray! {
                    self.unit = unit1
                    self.unitTextField.text = unit1.fullname
                }
            }
        }
    }
    
    private func calculateSum() {
        let quantity = convertingData().returtSringToFloat(stringIn: self.quantityTextField.text, fractionDigits: 3)
        let price = convertingData().returtSringToFloat(stringIn: self.priceTextField.text, fractionDigits: 2)
        let sum = quantity * price
        self.quantityTextField.text = convertingData().returnFloatToString(floatIn: quantity, fractionDigits: 3)
        self.priceTextField.text = convertingData().returnFloatToString(floatIn: price, fractionDigits: 2)
        self.sumTextField.text = convertingData().returnFloatToString(floatIn: sum, fractionDigits: 2)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tLine = self.tLine {
    //        self.produckTextField.text = tLine.productCD?.name
    //        self.unitTextField.text = tLine.unitCD?.fullname
            self.quantityTextField.text = convertingData().returnFloatToString(floatIn: tLine.quantityProduct, fractionDigits: 3)
            self.priceTextField.text = convertingData.init().returnFloatToString(floatIn: tLine.priceProduct, fractionDigits: 2)
            let sum = tLine.quantityProduct * tLine.priceProduct
            self.sumTextField.text = convertingData().returnFloatToString(floatIn: sum, fractionDigits: 2)
      //      product = tLine.productCD;
      //      unit = tLine.unitCD;
            numberLine = tLine.numberLine
        } else {
            self.quantityTextField.text = "0"
            self.unitTextField.text = ""
            self.priceTextField.text = "0"
            self.sumTextField.text = "0"
        }
        
    }
    
    func savetLine() -> Bool {
        if produckTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Ошибка проверки", message: "Выберите товар!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        if tLine == nil {
            tLine = TLine()
            tLine?.doc = docPurchase
            tLine?.numberLine = numberLine
        }
        
        if let tLine = tLine {
            tLine.priceProduct = convertingData().returtSringToFloat(stringIn: self.priceTextField.text, fractionDigits: 2)
     //       tLine.productCD = self.product
            tLine.quantityProduct = convertingData().returtSringToFloat(stringIn: self.quantityTextField.text, fractionDigits: 3)
     //       tLine.unitCD = self.unit
            CoreDataManager.instance.saveContext()
        }
        return true
    }
/*
    override func viewDidDisappear(_ animated: Bool) {
        var task: NoteModificationTask
        var currentLine: TableLine
        let quantity = convertingData().returtSringToFloat(stringIn: self.quantityTextField.text, fractionDigits: 3)
        let price = convertingData().returtSringToFloat(stringIn: self.priceTextField.text, fractionDigits: 2)
        
        if let tLine = self.tableLine {
            task = .edit
            currentLine = TableLine(docID: tLine.DocID, numberLine: tLine.NumberLine, nameProduct: self.produckTextField.text!, unitProduct: self.unitTextField.text!, quantityProduct: quantity, priceProduct: price, switchLine: tLine.switchLine)
        } else {
            task = .create
            currentLine = TableLine(docID: docId, numberLine: countProduct+1, nameProduct: self.produckTextField.text!, unitProduct: self.unitTextField.text!, quantityProduct: quantity, priceProduct: price, switchLine: false)
        }
        dataControllerDoc.modifyDoc(lineTableDoc: currentLine, task: task)
    }
*/
}
