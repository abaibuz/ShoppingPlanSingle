//
//  productsAdd.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 3/11/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//

import UIKit
import Foundation

class productsAdd : ElementCatalog<ProductsCD> {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.pictureSegue = "showImageProductSegue"
        self.nameCatalog = "Товары"
        self.colorTableSeparator = .backScrollViewProduct
        self.colorNavigationBar = .backNavigationBarProduct
        //       cancelButton
    }
    
    var categoryProduct: Categories!
    var unitProduct: UnitCD!
    
    @IBOutlet weak var scrollView1: UIScrollView!
    @IBOutlet weak var nameElement: UITextField!
    @IBOutlet weak var favouriteElemebt: BEMCheckBox!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var savebatton: UIButton!
    @IBOutlet weak var imageCategory: UIImageView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var sharedButton: UIButton!
    @IBOutlet weak var clearImageButton: UIButton!
    
    @IBOutlet weak var nvOutlet: UINavigationBar!
    @IBOutlet weak var viewOutlet: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var unitText: UITextField!
    @IBOutlet weak var quntitylabel: UILabel!
    @IBOutlet weak var quntityText: UITextField! {
        didSet {
            quntityText.addDoneCancelToolbar(isCancel: false, onDone: (target: self, action: #selector(onDoneKeyboardTapped)))
        }
    }
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceText: UITextField! {
        didSet {
            priceText.addDoneCancelToolbar(isCancel: false, onDone: (target: self, action: #selector(onDoneKeyboardTapped1)))
        }
    }
    //----------------------------
    @objc func onDoneKeyboardTapped() {
        validateNumberTextField(sender: self.quntityText, fractionDigits: 3)
    }
    //----------------------------
    @objc func onDoneKeyboardTapped1() {
        validateNumberTextField(sender: self.priceText, fractionDigits: 2)
    }

    //----------------------------
    private func validateNumberTextField(sender: UITextField, fractionDigits: Int) {
        let num = convertingData().returtSringToFloat(stringIn: sender.text, fractionDigits: fractionDigits)
        sender.text = convertingData().returnFloatToString(floatIn: num, fractionDigits: fractionDigits)
        sender.resignFirstResponder()
    }
    
    //-----------
    override func viewDidLoad() {
        self.scrollView = scrollView1
        self.shortName = nameElement
        self.favourite = favouriteElemebt
        self.shortNameLable = nameLabel
        self.imageElement = imageCategory
        self.navigationBar = nvOutlet
        self.viewForScrollView = viewOutlet
        super.viewDidLoad()
        cancelButton.addTarget(self, action: #selector(ElementCatalog<ProductsCD>.cancel), for: .touchUpInside)
        savebatton.addTarget(self, action: #selector(ElementCatalog<ProductsCD>.save), for: .touchUpInside)
        nameElement.addTarget(self, action: #selector(ElementCatalog<ProductsCD>.shortNameEditingChanged), for: .editingChanged)
        imagePicker.delegate = self
        setGacture()
        //     imageElement.delegate = self
    }
    //------------
    @IBAction func editChangedPrice(_ sender: Any) {
        self.deletePoint(textField: self.priceText)
        setVisibleLables()
    }
    //-----------
    @IBAction func editingDidBeginPrice(_ sender: Any) {
        setVisibleLables()
    }
    //-------------
    @IBAction func editingDidEndPrice(_ sender: Any) {
        onDoneKeyboardTapped1()
        setVisibleLables()
    }
    //--------
    @IBAction func editChangedQuantity(_ sender: Any) {
        self.deletePoint(textField: self.quntityText)
        setVisibleLables()
    }
    //---------------------------
    @IBAction func editingDidBeginQuantity(_ sender: Any) {
        setVisibleLables()
    }
    
    @IBAction func editingDidEndQuantity(_ sender: Any) {
        onDoneKeyboardTapped()
        setVisibleLables()
    }
    //----------------
    @IBAction func choiceUnitTapped(_ sender: Any) {
        performSegue(withIdentifier: "choiceUnit", sender: nil)
    }
    
    
    //---------------
    @IBAction func choiceCategoryTapped(_ sender: Any) {
        performSegue(withIdentifier: "choiceCategory", sender: nil)
        
    }
  //-----------------------
    
    @IBAction func clearUnitTapped(_ sender: Any) {
        self.unitProduct = nil
        self.unitText.text = ""
        setVisibleLables()
    }
    //--------------
    override func setVisibleLables() {
        super.setVisibleLables()
        self.unitLabel.isHidden = (self.unitText.text?.isEmpty)!
        self.categoryLabel.isHidden = (self.categoryText.text?.isEmpty)!
        self.quntitylabel.isHidden = (self.quntityText.text?.isEmpty)!
        self.priceLabel.isHidden = (self.priceText.text?.isEmpty)!
    }
 
    //------------
    override func sharedText() -> String {
        return "Наименование товара:\n" + self.nameElement.text! + "\nЦена:\n" + self.priceText.text!
    }
    
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "choiceCategory" {
            let controller = segue.destination.children[0] as! categoriesCatalog
            controller.unit = self.unit?.category
            controller.didSelect = { [unowned self] (unitArray) in
                for unit1 in unitArray! {
                    self.categoryProduct = unit1
                    self.categoryText.text = unit1.name
                    self.setVisibleLables()
                }
                self.copyDataFromField(unit: self.unit)
            }
        }
        
        if segue.identifier == "choiceUnit" {
            let controller = segue.destination.children[0] as! unitsCatalog
            controller.unit = self.unit?.unit
            controller.didSelect = { [unowned self] (unitArray) in
                for unit1 in unitArray! {
                    self.unitProduct = unit1
                    self.unitText.text = unit1.fullname
                    self.setVisibleLables()
                }
                self.copyDataFromField(unit: self.unit)
            }
        }
        
        if segue.identifier == pictureSegue {
            let controller = segue.destination as! ShowImageVC
            controller.image = self.imageElement.image
            controller.nameUnit = self.shortName.text!
            controller.nameCatalog = nameCatalog
            if  self.unit == nil {
                self.unit = createTypeElement()
            }
            self.copyDataFromField(unit: self.unit!)
            controller.product = self.unit
            if let image = unit?.image {
                controller.image = UIImage(data: image as Data)
            } else {
                controller.image = nil
            }
        }

    }
    //--------------
    override func validateFillFields() -> Bool {
        var returnVar = true
        var message: String = ""
        if shortName.text!.isEmpty {
            message = message + "Введите наименование!"
            if self.categoryProduct == nil {
                message = message + " Выберите категорию!"
            }
            returnVar = false
        }
        else if self.categoryProduct == nil {
            message = message + "Выберите категорию!"
            returnVar = false
        }
        
        if !returnVar {
            let alert = UIAlertController(title: "Ошибка проверки", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        return returnVar
    }
    
    //-----------------
    override func dataWasChanged() -> Bool {
        if self.unit == nil && ( !self.shortName.text!.isEmpty || self.favourite.on ||
            self.imageElement.image != UIImage(named: "icons8-картина-96 цветная")) {
            return true
        }
        
        if self.unit == nil {
            return false
        }
        if self.unit?.name != self.shortName.text {
            return true
        }
        if self.unit?.favourite != self.favourite.on {
            return true
        }
        
        if self.unit?.category != self.categoryProduct {
            return true
        }
        
        if self.unit?.unit != self.unitProduct {
            return true
        }
        
        if self.unit?.quantity != convertingData().returtSringToFloat(stringIn: self.quntityText.text, fractionDigits: 3) {
            return true
        }
        
        if self.unit?.sum != convertingData().returtSringToFloat(stringIn: self.priceText.text, fractionDigits: 2) {
           return true
        }
        
        return false
    }
    
    //--------------
    override func getNameElement(unit : ProductsCD) -> String {
        return unit.name!
    }
    //-------------------
    
    override func copyDataFromField(unit : ProductsCD?) {
        if let unit = self.unit {
            unit.name = self.shortName.text!
            unit.favourite = self.favourite.on
            if let image =  imageCategory.image {
                if image.isEqual(UIImage(named: "icons8-картина-96 цветная")) {
                    unit.image = nil
                }   else {
                    unit.image =  image.jpegData(compressionQuality: 1) as NSData?
                }
            } else {
                unit.image = nil
            }
            
            unit.category = self.categoryProduct
            unit.unit = self.unitProduct
            unit.quantity = convertingData().returtSringToFloat(stringIn: self.quntityText.text, fractionDigits: 3)
            unit.sum = convertingData().returtSringToFloat(stringIn: self.priceText.text, fractionDigits: 2)
        }
    }
    
    //---------------
    override func pasteDataToField(unit : ProductsCD) {
        self.shortName.text = unit.name
        self.favourite.on = unit.favourite
        if let imageData = unit.image {
            self.imageCategory.image =  UIImage(data: imageData as Data)
        } else {
            self.imageCategory.image = UIImage(named: "icons8-картина-96 цветная")
        }


        if let category = unit.category {
            categoryProduct = category
            self.categoryText.text = categoryProduct.name
        }
        
        if let unit = unit.unit {
            unitProduct = unit
            self.unitText.text = unitProduct.fullname
        }
    
        self.quntityText.text = convertingData().returnFloatToString(floatIn: unit.quantity, fractionDigits: 3)
        self.priceText.text = convertingData().returnFloatToString(floatIn: unit.sum, fractionDigits: 2)
        
    }
    //-----------
    override func defaultFillFields() {
        self.quntityText.text = convertingData().returnFloatToString(floatIn: 1.000, fractionDigits: 3)
        self.priceText.text = convertingData().returnFloatToString(floatIn: 0.00, fractionDigits: 2)
    }
    
    //---------------------
    override func createTypeElement() -> ProductsCD {
        return ProductsCD()
    }
    //--------
    func deletePoint(textField: UITextField) {
        var str = textField.text
        let decimalSeparetor = NumberFormatter().decimalSeparator.first
        
        if let str1 = str {
            if str1.last == decimalSeparetor {
                let substring = String(str1.dropLast())
                if substring.contains(decimalSeparetor!) {
                    self.playFile(forResource: "Sound_windows error", withExtension: "wav")
                    str = substring
                }
            }
        }
        textField.text = str
    }
}
