//
//  editPriceSumPopoverVC.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 5/13/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class editSumViewController : UIViewController, AVAudioPlayerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    var tline: TLine!
    var changeField : ((Bool) -> ())?
    var audioPlayer: AVAudioPlayer?
    var unitLocal: UnitCD!
    
    @IBOutlet weak var unitlabeloutlet: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var quantitytextField: UITextField! {
        didSet {
            quantitytextField.addDoneCancelToolbar(isCancel: false, onDone: (target: self, action: #selector(onDoneKeyboardTappedQuantity)))
        }
    }
    @IBOutlet weak var priceTextField: UITextField!{
        didSet {
            priceTextField.addDoneCancelToolbar(isCancel: false, onDone: (target: self, action: #selector(onDoneKeyboardTappedPrice)))
        }
    }
    @IBOutlet weak var sumtextField: UITextField! {
        didSet {
            sumtextField.addDoneCancelToolbar(isCancel: false, onDone: (target: self, action: #selector(onDoneKeyboardTappedSum)))
        }
    }
    
    //----------------------------
    @objc func onDoneKeyboardTappedQuantity() {
        validateNumberTextField(sender: self.quantitytextField, fractionDigits: 3)
    }
    //----------------------------
    @objc func onDoneKeyboardTappedPrice() {
        validateNumberTextField(sender: self.priceTextField, fractionDigits: 2)
    }
    //----------------------------
    @objc func onDoneKeyboardTappedSum() {
        validateNumberTextField(sender: self.sumtextField, fractionDigits: 2)
    }

    //----------------------------
    private func validateNumberTextField(sender: UITextField, fractionDigits: Int) {
        let num = convertingData().returtSringToFloat(stringIn: sender.text, fractionDigits: fractionDigits)
        sender.text = convertingData().returnFloatToString(floatIn: num, fractionDigits: fractionDigits)
        sender.resignFirstResponder()
    }
    //--------
    @IBAction func editingChangedQuatity(_ sender: Any) {
        deletePoint(textField: self.quantitytextField)
    }
    //---------
    
    @IBAction func editingChangedPrice(_ sender: Any) {
        deletePoint(textField: self.priceTextField)
    }
    //--------------
    
    @IBAction func editingChangedSum(_ sender: Any) {
        deletePoint(textField: self.sumtextField)
    }
    
    //----------
    
    @IBAction func editingEndQuantity(_ sender: Any) {
        onDoneKeyboardTappedQuantity()
        calcSum()
    }
    //-----------
    
    @IBAction func editingEndPrice(_ sender: Any) {
        onDoneKeyboardTappedPrice()
        calcSum()
    }
    //
    @IBAction func editingEndSum(_ sender: Any) {
        onDoneKeyboardTappedSum()
        calcPrice()
    }
    //------
    
    @IBAction func increseButtonTapped(_ sender: Any) {
        var quantity = convertingData().returtSringToFloat(stringIn: self.quantitytextField.text, fractionDigits: 3)
        quantity = quantity + 1
        quantitytextField.text = convertingData().returnFloatToString(floatIn:  quantity, fractionDigits: 3)
        calcSum()
    }
    //-----
    
    @IBAction func decreseButtonTapped(_ sender: Any) {
        var quantity = convertingData().returtSringToFloat(stringIn: self.quantitytextField.text, fractionDigits: 3)
        quantity = quantity - 1
        if quantity < 0 {
            quantity = 0
        }
        quantitytextField.text = convertingData().returnFloatToString(floatIn:  quantity, fractionDigits: 3)
        calcSum()

    }
    //-----------
    func calcSum() {
        let sum = convertingData().returtSringToFloat(stringIn: self.quantitytextField.text, fractionDigits: 3) * convertingData().returtSringToFloat(stringIn: self.priceTextField.text, fractionDigits: 2)
        sumtextField.text = convertingData().returnFloatToString(floatIn:  sum, fractionDigits: 2)
    }
    //-----
    func calcPrice() {
        let quantity = convertingData().returtSringToFloat(stringIn: self.quantitytextField.text, fractionDigits: 3)
        var price = quantity
        if quantity <= 0 {
            price = 0
        } else {
            price = convertingData().returtSringToFloat(stringIn: self.sumtextField.text, fractionDigits: 2) / quantity
        }
        priceTextField.text = convertingData().returnFloatToString(floatIn:  price, fractionDigits: 2)
        
    }
    //--------
    func deletePoint(textField: UITextField) {
        let decimalSeparetor = NumberFormatter().decimalSeparator.first
        var str = textField.text
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
    //----------------
    func playFile(forResource: String, withExtension: String) {
        DispatchQueue.main.async {
            guard let url = Bundle.main.url(forResource: forResource, withExtension: withExtension) else { return }
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                try AVAudioSession.sharedInstance().setActive(true)
                self.audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                guard let player = self.audioPlayer else { return }
                
                player.play()
            } catch let error{
                print(error.localizedDescription)
            }
        }
    }
    //---------
    @IBAction func cancelButtonTapped(_ sender: Any) {
        changeField!(false)
        dismiss(animated: true)
    }
    //-------------
    @IBAction func saveButtonTapped(_ sender: Any) {
        if dataWasChanged() {
            setTline()
            changeField!(true)
        } else {
            changeField!(false)
        }
        dismiss(animated: true)
    }
    
    //------------
    func setFields() {
        if let tline = tline {
            productLabel.text = tline.productLine?.name
            unitTextField.text = tline.unitLine?.fullname
            quantitytextField.text = convertingData().returnFloatToString(floatIn: tline.quantityProduct, fractionDigits: 3)
            priceTextField.text = convertingData().returnFloatToString(floatIn: tline.priceProduct, fractionDigits: 2)
            let sum = tline.quantityProduct * tline.priceProduct
            sumtextField.text = convertingData().returnFloatToString(floatIn:  sum, fractionDigits: 2)
            self.unitLocal = tline.unitLine
        }
    }
    //--------------
    func setTline() {
        if let tline = tline {
            tline.quantityProduct = convertingData().returtSringToFloat(stringIn: self.quantitytextField.text, fractionDigits: 3)
            tline.priceProduct = convertingData().returtSringToFloat(stringIn: self.priceTextField.text, fractionDigits: 2)
            tline.unitLine = unitLocal
        }
    }
    //---------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setFields()
        setGacture()
    }
    
    //--------
    public func setGacture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(choiceUnit))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        self.unitlabeloutlet.addGestureRecognizer(tap)
        self.unitlabeloutlet.isUserInteractionEnabled = true
    }
    //-------
    @objc func choiceUnit() {
        performSegue(withIdentifier: "choiceUnit", sender: nil)
    }
    
    //---------
    func dataWasChanged() -> Bool {
        if self.tline?.quantityProduct != convertingData().returtSringToFloat(stringIn: self.quantitytextField.text, fractionDigits: 3) {
            return true
        }
        
        if self.tline?.priceProduct != convertingData().returtSringToFloat(stringIn: self.priceTextField.text, fractionDigits: 2) {
            return true
        }
        
        if self.tline.unitLine != self.unitLocal {
            return true
        }
        
        return false
    
    }
    
    //----------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "choiceUnit" {
            let controller = segue.destination.children[0] as! unitsCatalog
            controller.unit = self.tline.unitLine
            controller.didSelect = { [unowned self] (unitArray) in
                for unit1 in unitArray! {
                    self.unitLocal = unit1
                    self.unitTextField.text = unit1.fullname
                }
            }
        }

    }
    
    
}
