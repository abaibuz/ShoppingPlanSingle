//
//  ElementCatalog.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 2/26/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AVFoundation



class ElementCatalog<TypeElement> : UIViewController, UITextFieldDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, AVAudioPlayerDelegate, BEMCheckBoxDelegate {
   
    var unit : TypeElement?
    var pictureSegue: String = ""
    var nameCatalog: String = ""
    var colorNavigationBar: UIColor = .backGray
    var colorTableSeparator: UIColor = .backGreen
    var audioPlayer: AVAudioPlayer?
    var sizeImage: CGFloat = 1024
    
    weak var activeField: UITextField?
    
    @objc func cancel(_ sender: Any) {
        
        if !dataWasChanged() {
            self.dismiss(animated: true)
        } else {
            self.alertForSaveData(isExit: true)
  //          self.dismiss(animated: true)
        }
        
    }
    
    private func alertForSaveData(isExit: Bool) {
        let alert = UIAlertController(title: "Предупреждение", message: "Данные был изменены! Сохранить?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler:{  (UIAlertAction) -> Void in
            self.save(1)
      //      self.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: { (UIAlertAction) -> Void in
            if isExit {
                self.dismiss(animated: true)
            }
        } ))
        self.present(alert, animated: true, completion: nil)
        
    }
    //-----------------
    public func dataWasChanged() -> Bool {
         return false
    }
    //-----------------------------
    
    @objc func save(_ sender: Any) {
        if saveUnit() {
            
    /*        let fullName = getNameElement(unit: unit!)  //?.fullname
            let message = "Данные об элементе  \"\(fullName )\" сохранены!"
            let alert1 = UIAlertController(title: "Сообщение", message: message, preferredStyle: .alert)
            alert1.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert1, animated: true, completion: nil)
    */
     //       if  sender as! Int == 1 {
                self.dismiss(animated: true)
     //       }
        }
    }
    
    //---------------
    @IBAction func sharedButtonTapped(_ sender: Any) {
        let text =  sharedText()//"Наименование товара:\n" + self.nameElement.text! + "\nЦена:\n" + self.priceText.text!
        
        let image = self.imageElement.image
        let shareAll = [text, image!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        //    activityViewController.excludedActivityTypes = [UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.postToFacebook]
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    //---------------
    @IBAction func clearImageButtonTapped(_ sender: Any) {
        showAlertMenu()
    }
    
    //------------------
    public func sharedText() -> String {
        return ""
    }
    //-----------------
    public func getNameElement(unit : TypeElement) -> String {
        return ""
    }
    
    @IBOutlet weak var shortName: UITextField!
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var favourite: BEMCheckBox!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var shortNameLable: UILabel!
    @IBOutlet weak var fullNameLable: UILabel!
    @IBOutlet weak var imageElement: UIImageView!
    @IBOutlet weak var viewForScrollView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    

    let imagePicker = UIImagePickerController()
    
    @IBAction func albumButton(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    
    @IBAction func photoButton(_ sender: Any) {
        openCamera()
    }
    
    
    func openCamera(){
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "Нет камеры!",
            message: "Извините, на этом устройстве нет камеры!",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.originalImage] as? UIImage else {
            print("Error: \(info)")
            return
        }
   //     let resizeImage = pickedImage.fixOrientation()
        self.imageElement.image = pickedImage.resizeImage(to: self.sizeImage)
   //     let size = self.imageElement.image!.size
   //     print("imagePickerController: width=\(size.width), height = \(size.height)")
        
        self.setAvalability()
        imagePickerControllerDidCancel(picker)

    }
    //-------
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    //--------
    @IBAction func shortNameEditingChanged(_ sender: Any) {
        setVisibleLables()
    }
    //-----------
    @IBAction func fullNameEditingChanged(_ sender: Any) {
        setVisibleLables()
    }
    //---------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setSCRViewControl()
        if let unit = unit {
            pasteDataToField(unit: unit)
        }
        else {
            defaultFillFields()
        }
        setVisibleLables()
        setColor()
      //  setAvalability()
    }
    
     //-----------
    override func viewDidAppear(_ animated: Bool) {
        if let unit = unit {
            pasteDataToField(unit: unit)
        }
    }
    //---------------------
    private func setColor() {
        if let viewSV = self.viewForScrollView {
            viewSV.backgroundColor = self.colorTableSeparator
        }
        if let nv = self.navigationBar {
            nv.barTintColor = self.colorNavigationBar
        }
    }
    
    //----------

    //
    public func setGacture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(perfomeSegue))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        self.imageElement.addGestureRecognizer(tap)
    }
    //-------
    
    @objc func perfomeSegue(sender: Any) {
        if validateFillFields() {
            performSegue(withIdentifier: pictureSegue, sender: nil)
        }
    }
    //--------
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        }
    }

    //------------
    public func setDelegate() {
        shortName.delegate = self
        //fullname.delegate = self
    }
    //---------------
    public func pasteDataToField(unit : TypeElement) {
      //
    }
    //---------------
    public func defaultFillFields() {
    //
    }
    //----
    public func copyDataFromField(unit : TypeElement) {
      //
    }
    //------------------
    public func setVisibleLables() {
        shortNameLable.isHidden = (shortName.text?.isEmpty)!
        
   //     fullNameLable.isHidden = (fullname.text?.isEmpty)!
    }
    //-------
    public func validateFillFields() -> Bool {
        if shortName.text!.isEmpty {
            let alert = UIAlertController(title: "Ошибка проверки", message: "Введите краткое наименование!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    //---------
    public func setAvalability() {
        if let imageView = self.imageElement {
            if imageIsEmpty() {
               imageView.isUserInteractionEnabled = false
            }  else {
                imageView.isUserInteractionEnabled = true
            }
        }
    }
    //-------------------------
    func saveUnit() -> Bool {
        if !validateFillFields() {
            return false
        }
        
        if !dataWasChanged() {
 /*           let alert = UIAlertController(title: "Проверка изменений", message: "Данные не были изменены и сохранять их не надо!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
 */
            return true
        }
        
        if unit == nil {
            unit = createTypeElement()
        }
        
   //     let loadDataQueue = DispatchQueue(label: "com.myshopping.saveunit")

        if let unit = unit {
            self.playFile(forResource: "Sound_windows restore", withExtension: "wav")

            copyDataFromField(unit: unit)
            CoreDataManager.instance.saveContext()
        }
        
        return true
        
    }
    
    //---------------------
    public func createTypeElement() -> TypeElement {
        return unit!
    }
    
    private func setSCRViewControl() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
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
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        if let activeField = self.activeField {
            let activeRect = activeField.convert(activeField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(activeRect, animated: true)
            return
        }
        
    }
    //-------------
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    //-----------
    @objc func doneButtonPressed(_ sender: Any) {
        activeField?.resignFirstResponder()
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
   //----------------
    private func showAlertMenu() {
        let alertController = UIAlertController(title: nameCatalog, message: self.shortName.text, preferredStyle: UIAlertController.Style.actionSheet)
        
        let closeAction = UIAlertAction(title: "Удалить изображение", style: UIAlertAction.Style.destructive, handler: {(alert :UIAlertAction!) in
            self.imageElement.image = UIImage(named: "icons8-картина-96 цветная")
            self.setAvalability()
        })
        alertController.addAction(closeAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
  //-----------
    public func imageIsEmpty() -> Bool {
        if let image = self.imageElement.image {
            let boolVar = (image.isEqual(UIImage(named: "icons8-картина-96 цветная")))
             return boolVar
        } else {
            return true
        }
    }
}
