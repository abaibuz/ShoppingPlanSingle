//
//  ShowImageVC.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 3/3/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AVFoundation


class ShowImageVC: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
     var image: UIImage!
     var nameUnit: String = "Элемент каталога"
     var nameCatalog: String = "Каталог"
     var product: Any!//ProductsCD!
     let imagePicker = UIImagePickerController()
     var sizeImage: CGFloat = 1024
     var imageChange = ImageChangeAct.none

    //----------------
    override func viewDidLoad() {
       super.viewDidLoad()
       if let image1 = image {
          imageView.image = image1
       } else {
          imageView.image = UIImage(named: "icons8-картина-96 цветная")
        }
        scrollView.delegate = self
        setGacture()
        imagePicker.delegate = self
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    //-----------------
    @objc func cancelbuttonTapped(_ sender: Any) {
        saveImage()
        dismiss(animated: true)
    }
    
    //-------------
    private func  saveImage() {
        var isChangeImage = false
        switch imageChange {
            case .edit:
                
                switch nameCatalog {
                    case "Товары":
                     if let product = self.product as! ProductsCD? {
                            product.image =  imageView.image!.pngData()! as NSData
                            isChangeImage = true
                    }
                    case "Категория":
                        if let product = self.product as! Categories? {
                            product.image =  imageView.image!.pngData()! as NSData
                            isChangeImage = true
                    }
                    case "Мои покупки":
                    if let product = self.product as! DocPurchase? {
                        product.checkImage =  imageView.image!.pngData()! as NSData
                        isChangeImage = true
                    }
                    default:
                       break
                }
            
            case .clear:
                switch nameCatalog {
                case "Товары":
                    if let product = self.product as! ProductsCD? {
                        if product.image != nil {
                            product.image = nil
                            isChangeImage = true
                        }
                    }
                case "Категория":
                    if let product = self.product as! Categories? {
                        if product.image != nil {
                            product.image = nil
                            isChangeImage = true
                        }
                    }
                case "Мои покупки":
                    if let product = self.product as! DocPurchase? {
                        if product.checkImage != nil {
                            product.checkImage = nil
                            isChangeImage = true
                        }
                    }
               default:
                    break
                }
                      default:
                break
        }
        if isChangeImage {
            CoreDataManager.instance.saveContext()
        }
    }
    
    //-----------------------
     @objc func sharedButtonTapped(_ sender: Any) {
        let text = "Наименование товара:\n" + self.nameUnit
        let image = self.image
        let shareAll = [text, image!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        //    activityViewController.excludedActivityTypes = [UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.postToFacebook]
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }

    //-------------
    @objc func oneTouchTapped(_ sender: Any) {
            showAlertMenu()
    }
    //------------
    func albumButton() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    //------------
    
    
    ///-------
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
    //--------------------
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
    //------------------
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.originalImage] as? UIImage else {
            print("Error: \(info)")
            return
        }
        self.imageView.image = pickedImage.resizeImage(to: self.sizeImage)
        imageChange = .edit
        imagePickerControllerDidCancel(picker)
    }
    //-------
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    //-------------------
    func clearImage() {
        imageChange = .clear
        self.imageView.image = UIImage(named: "icons8-картина-96 цветная")
    }
    //----
    private func showAlertMenu() {
        let alertController = UIAlertController(title: nameCatalog, message: self.nameUnit, preferredStyle: UIAlertController.Style.actionSheet)
        
        let photoAction = UIAlertAction(title: "Сделать фото", style: UIAlertAction.Style.default,  handler: {(alert :UIAlertAction!) in
              self.openCamera()
        })
        let image2 = UIImage(named: "icons8-компактная-камера-22")
        photoAction.setValue(image2, forKey: "image")
        alertController.addAction(photoAction)
        
        let gelleryAction = UIAlertAction(title: "Выбрать фото", style: UIAlertAction.Style.default,  handler: {(alert :UIAlertAction!) in
            self.albumButton()
        })
        let image3 = UIImage(named: "icons8-стопка-фотографий-22")
        gelleryAction.setValue(image3, forKey: "image")
        alertController.addAction(gelleryAction)
        
        let clearAction = UIAlertAction(title: "Очистить фото", style: UIAlertAction.Style.default,  handler: {(alert :UIAlertAction!) in
             self.clearImage()
        })
        let image4 = UIImage(named: "icons8-удалить-22")
        clearAction.setValue(image4, forKey: "image")
        alertController.addAction(clearAction)
        
        let sharedAction = UIAlertAction(title: "Поделиться", style: UIAlertAction.Style.default,  handler: {(alert :UIAlertAction!) in
            self.sharedButtonTapped(0)
        })
        let image1 = UIImage(named: "icons8-поделиться-30")
        sharedAction.setValue(image1, forKey: "image")
        alertController.addAction(sharedAction)
      
        let closeAction = UIAlertAction(title: "Закрыть", style: UIAlertAction.Style.destructive, handler: {(alert :UIAlertAction!) in
            self.cancelbuttonTapped(0)
        })
        let image = UIImage(named: "icons8-отмена-22")
        closeAction.setValue(image, forKey: "image")
        alertController.addAction(closeAction)

        let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    //------------------
    private func setGacture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelbuttonTapped))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 2
        tap.delegate = self
        self.imageView.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(oneTouchTapped))
        tap1.numberOfTapsRequired = 1
        tap1.numberOfTouchesRequired = 1
        tap1.delegate = self
        self.imageView.addGestureRecognizer(tap1)
    }

    //-------------------
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}
