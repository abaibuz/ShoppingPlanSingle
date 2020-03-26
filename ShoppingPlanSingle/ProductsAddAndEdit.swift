//
//  ProductsAddAndEdit.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 17.06.2018.
//  Copyright © 2018 Olexandr Baybuz. All rights reserved.
//

import UIKit

class ProductsUnitsAddAndEdit : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var product: ProductsCD?
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var unitText: UITextField!
    @IBOutlet weak var quntityText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var productImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let productNew = product {
            nameText.text = productNew.name
            unitText.text = productNew.unit?.fullname
            quntityText.text = convertingData().returnFloatToString(floatIn: productNew.quantity, fractionDigits: 3)
            priceText.text = convertingData().returnFloatToString(floatIn: productNew.sum, fractionDigits: 2)
            if let imageData = productNew.image {
                productImage.image =  UIImage(data: imageData as Data)
            }
        }
        imagePicker.delegate = self
    }
    
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveProduct(_ sender: Any) {
        if save() {
            Cancel(sender)
        }
    }
    
    @IBAction func loadImageTaped(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    
    
    @IBAction func photoButtonTapped(_ sender: Any) {
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
        productImage.contentMode = .scaleAspectFit
        productImage.image = pickedImage
        dismiss(animated: true, completion: nil)
        
    }
  /*
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            productImage.contentMode = .scaleAspectFit
            productImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
  */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func save() -> Bool {
        if nameText.text!.isEmpty {
            let alert = UIAlertController(title: "Ошибка проверки", message: "Введите наименование!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        if product == nil {
            product = ProductsCD()
        }
        
        if let product = product {
            product.name = nameText.text!
            product.quantity = convertingData().returtSringToFloat(stringIn: quntityText.text, fractionDigits: 3)
            product.sum = convertingData().returtSringToFloat(stringIn: priceText.text, fractionDigits: 2)
            if let image =  productImage.image {
                self.product?.image = image.pngData()! as NSData
            }
            CoreDataManager.instance.saveContext()
        }
        return true

    }
    
    @IBAction func choiceUnit(_ sender: Any) {
        performSegue(withIdentifier: "unitsChoice", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unitsChoice" {
    
            let controller = segue.destination.children[0] as! unitsCatalog
            controller.unit = self.product?.unit
            controller.didSelect = { [unowned self] (unitArray) in
                for unit1 in unitArray! {
                    self.product?.unit = unit1
                    self.unitText.text = unit1.fullname
                }
            }
        }
    }
    
    @IBAction func clearUnit(_ sender: Any) {
        if product?.unit != nil {
            unitText.text = ""
            product?.unit = nil
        }
    }

}
