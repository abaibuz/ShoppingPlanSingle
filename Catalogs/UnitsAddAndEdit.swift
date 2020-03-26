//
//  UnitsAddAndEdit.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 22.05.2018.
//  Copyright © 2018 Olexandr Baybuz. All rights reserved.
//

import UIKit
import Foundation

class UnitsAddAndEdit : UIViewController, UITextFieldDelegate {
    var unit : UnitCD?
    
    weak var activeField: UITextField?

    @IBAction func cancel(_ sender: Any) {
        
        if !dataWasChanged() {
            self.dismiss(animated: true)
        } else {
            self.alertForSaveData(isExit: true)
        }
        
    }
    
    private func alertForSaveData(isExit: Bool) {
        let alert = UIAlertController(title: "Предупреждение", message: "Данные был изменены! Сохранить?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler:{  (UIAlertAction) -> Void in
            self.save(0)
        }))
        
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: { (UIAlertAction) -> Void in
            if isExit {
                self.dismiss(animated: true)
            }
        } ))
        self.present(alert, animated: true, completion: nil)
        
    }

    private func dataWasChanged() -> Bool {
        
        if self.unit == nil && ( !self.shortName.text!.isEmpty || !self.fullname.text!.isEmpty || self.favourite.isOn) {
            return true
        }
        
        if self.unit == nil {
            return false
        }
        
        if self.unit?.shortname != self.shortName.text {
            return true
            
        }
        
        if self.unit?.fullname != self.fullname.text {
            return true
        }
        
        if self.unit?.favourite != self.favourite.isOn {
            return true
        }
        
        return false
    }
    
    @IBAction func save(_ sender: Any) {
        if saveUnit() {
    
            let fullName = unit?.fullname
            let message = "Данные о единице измерения \"\(fullName ?? "")\" сохранены!"
            let alert1 = UIAlertController(title: "Сообщение", message: message, preferredStyle: .alert)
            alert1.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert1, animated: true, completion: nil)

//            cancel(sender)
            //dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var shortName: UITextField!
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var favourite: UISwitch!
    @IBOutlet weak var scrollView: UIScrollView!    
    @IBOutlet weak var shortNameLable: UILabel!
    @IBOutlet weak var fullNameLable: UILabel!
    @IBOutlet weak var viewOutlet: UIView!
    @IBOutlet weak var navigationBarOutlet: UINavigationBar!
    
    @IBAction func shortNameEditingChanged(_ sender: Any) {
        setVisibleLables()
    }
    
    @IBAction func fullNameEditingChanged(_ sender: Any) {
        setVisibleLables()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shortName.delegate = self
        fullname.delegate = self
        setSCRViewControl()
        if let unit = unit {
            shortName.text = unit.shortname
            fullname.text = unit.fullname
            favourite.isOn = unit.favourite
        }
        setVisibleLables()
    }
    
    private func setVisibleLables() {
        shortNameLable.isHidden = (shortName.text?.isEmpty)!
        fullNameLable.isHidden = (fullname.text?.isEmpty)!
    }
    
    func saveUnit() -> Bool {
        if shortName.text!.isEmpty {
            let alert = UIAlertController(title: "Ошибка проверки", message: "Введите краткое наименование!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        if !dataWasChanged() {
            return false
        }
        
        if unit == nil {
            unit = UnitCD()
        }
        
        if let unit = unit {
            unit.shortname = shortName.text!
            unit.fullname = fullname.text
            unit.favourite = favourite.isOn
            CoreDataManager.instance.saveContext()
        }
        
        return true
        
    }
    
    
    private func setSCRViewControl() {
   //     NotificationCenter.default.addObserver(self, selector: <#T##Selector#>, name: NSNotificationN, object: <#T##Any?#>)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow),
                                               name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        if let activeField = self.activeField {
            let activeRect = activeField.convert(activeField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(activeRect, animated: true)
            return
        }
        
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func doneButtonPressed(_ sender: Any) {
        activeField?.resignFirstResponder()
    }
}
