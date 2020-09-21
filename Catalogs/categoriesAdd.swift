//
//  categoriesAdd.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 2/26/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//

import UIKit
import Foundation

class categoriesAdd : ElementCatalog<Categories> {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.pictureSegue = "showImageSegue"
        self.nameCatalog = "Категория"
        self.colorTableSeparator = .backScrollView
        self.colorNavigationBar = .backNavigationBar
        self.sizeImage = 48
    }
    
    @IBOutlet weak var scrollView1: UIScrollView!
    @IBOutlet weak var nameElement: UITextField!
    @IBOutlet weak var favouriteElemebt: BEMCheckBox!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var savebatton: UIButton!
    @IBOutlet weak var imageCategory: UIImageView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var viewOutlet: UIView!
    @IBOutlet weak var nvOutlet: UINavigationBar!
    @IBOutlet weak var clearImageButton: UIButton!
    
    
    override func viewDidLoad() {
        self.scrollView = scrollView1
        self.shortName = nameElement
        self.favourite = favouriteElemebt
        self.shortNameLable = nameLabel
        self.imageElement = imageCategory
        self.viewForScrollView = viewOutlet
        self.navigationBar = nvOutlet
        super.viewDidLoad()
        cancelButton.addTarget(self, action: #selector(ElementCatalog<Categories>.cancel), for: .touchUpInside)
        savebatton.addTarget(self, action: #selector(ElementCatalog<Categories>.save), for: .touchUpInside)
        nameElement.addTarget(self, action: #selector(ElementCatalog<Categories>.shortNameEditingChanged), for: .editingChanged)
  //      photoButton.addTarget(self, action: #selector(ElementCatalog<Categories>.photoButton), for: .touchUpInside)
  //      albumButton.addTarget(self, action: #selector(ElementCatalog<Categories>.albumButton), for: .touchUpInside)
  //      clearImageButton.addTarget(self, action: #selector(ElementCatalog<ProductsCD>.clearImageButtonTapped), for: .touchUpInside)

        imagePicker.delegate = self
        setGacture()
    }
    //--------------
    override func validateFillFields() -> Bool {
        if shortName.text!.isEmpty {
            let alert = UIAlertController(title: "Ошибка проверки", message: "Введите наименование!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true

    }
    
    //-----------------
    override func dataWasChanged() -> Bool {
         if self.unit == nil && ( !self.shortName.text!.isEmpty || self.favourite.on || !self.imageIsEmpty()) {
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
        
        return false
    }
    
    //--------------
    override func getNameElement(unit : Categories) -> String {
        return unit.name!
    }
    //-------------------
    
    override func copyDataFromField(unit : Categories) {
         unit.name = self.shortName.text!
         unit.favourite = self.favourite.on

        if let image =  imageCategory.image {
            if self.imageIsEmpty() {
                unit.image = nil
            }   else {
                unit.image = image.pngData()! as NSData
            }
        } else {
            unit.image = nil
        }
    }
    
    //---------------
    override func pasteDataToField(unit : Categories) {
        self.shortName.text = unit.name
        self.favourite.on = unit.favourite
        if let imageData = unit.image {
            self.imageCategory.image =  UIImage(data: imageData as Data)
        } else {
            self.imageCategory.image = UIImage(named: "icons8-картина-96 цветная")
        }
    }
    
    //---------------------
    override func createTypeElement() -> Categories {
        return Categories()
    }
    
    override func setAvalability() {
        super.setAvalability()
        if let outlet = self.clearImageButton {
            outlet.isUserInteractionEnabled = !self.imageIsEmpty()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
}
