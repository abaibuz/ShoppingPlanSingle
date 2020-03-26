//
//  photoCheck.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 4/12/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//

import UIKit
import Foundation

class photoCheck: ElementCatalog<DocPurchase> {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.pictureSegue = "showImageProductSegue"
        self.nameCatalog = "Чеки"
        self.colorTableSeparator = .backTableDocPurchase
        self.colorNavigationBar = .backNavigationBarDocPurchase
  //      self.sizeImage = 48
        //       cancelButton
    }

    @IBOutlet weak var scrollView1: UIScrollView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var navigationBar1: UINavigationBar!
    
    @IBOutlet weak var cancelButton1: UIButton!
    @IBOutlet weak var saveButton1: UIButton!
    @IBOutlet weak var namePurcahse: UITextField!
    @IBOutlet weak var photoButton1: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var sharedButton: UIButton!
    @IBOutlet weak var clearButton1: UIButton!
    @IBOutlet weak var imageCheck: UIImageView!
    
    //-----------
    override func viewDidLoad() {
        self.scrollView = scrollView1
        self.shortName = namePurcahse
   //     self.favourite = favouriteElemebt
    //    self.shortNameLable = nameLabel
        self.imageElement = imageCheck
        self.navigationBar = navigationBar1
        self.viewForScrollView = view1
        super.viewDidLoad()
        cancelButton1.addTarget(self, action: #selector(ElementCatalog<ProductsCD>.cancel), for: .touchUpInside)
        saveButton1.addTarget(self, action: #selector(ElementCatalog<ProductsCD>.save), for: .touchUpInside)
    //    namePurcahse.addTarget(self, action: #selector(ElementCatalog<ProductsCD>.shortNameEditingChanged), for: .editingChanged)
        photoButton1.addTarget(self, action: #selector(ElementCatalog<ProductsCD>.photoButton), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(ElementCatalog<ProductsCD>.albumButton), for: .touchUpInside)
        sharedButton.addTarget(self, action: #selector(ElementCatalog<ProductsCD>.sharedButtonTapped), for: .touchUpInside)
        clearButton1.addTarget(self, action: #selector(ElementCatalog<ProductsCD>.clearImageButtonTapped), for: .touchUpInside)
        imagePicker.delegate = self
        setGacture()
    }
    
    //------------
    override public func setDelegate() {
    }
    //----------
    override func validateFillFields() -> Bool {
        return true
    }
    
    //------------------
    override func setVisibleLables() {
     }
    //------------
    override func dataWasChanged() -> Bool {
        if (self.unit?.checkImage ==  nil  && self.imageElement.image == UIImage(named: "icons8-картина-96 цветная")) {
           return false
        }
        
        if self.unit?.checkImage !=  self.imageElement.image!.pngData()! as NSData {
            return true
        }
        return false
    }

  //-------------

    override func getNameElement(unit : DocPurchase) -> String {
        return unit.name! + " от " + (unit.date! as Date).convertDateAndTimeToString
    }
    
    //------------------
    override func createTypeElement() -> DocPurchase {
        return DocPurchase()
    }
    
    //---------
    override func copyDataFromField(unit : DocPurchase) {
        if self.imageElement.image == UIImage(named: "icons8-картина-96 цветная") {
            unit.checkImage = nil
        } else {
            unit.checkImage = self.imageElement.image!.pngData()! as NSData
        }
    }
    
    //---------------
    override func pasteDataToField(unit : DocPurchase) {
        self.shortName.text = getNameElement(unit : self.unit!)
        if let imageData = unit.checkImage {
            self.imageElement.image =  UIImage(data: imageData as Data)
        }
    }

    
}
