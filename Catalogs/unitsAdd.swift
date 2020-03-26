//
//  unitsAdd.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 3/18/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//

import Foundation
import Foundation

class unitsAdd : ElementCatalog<UnitCD> {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.pictureSegue = "showImageSegue"
        self.nameCatalog = "Единица измерения"
        self.colorTableSeparator = .backGreen
        self.colorNavigationBar = .backGray
    }
    
    @IBOutlet weak var scrollView1: UIScrollView!
    @IBOutlet weak var nameElement: UITextField!
    @IBOutlet weak var favouriteElemebt: BEMCheckBox!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var viewOutlet: UIView!
    @IBOutlet weak var nvOutlet: UINavigationBar!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var savebatton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var fullNameElement: UITextField!
    
   
    
    override func viewDidLoad() {
        self.scrollView = scrollView1
        self.shortName = nameElement
        self.favourite = favouriteElemebt
        self.shortNameLable = nameLabel
        self.fullname = fullNameElement
        self.fullNameLable = fullNameLabel
        self.viewForScrollView = viewOutlet
        self.navigationBar = nvOutlet
        super.viewDidLoad()
        cancelButton.addTarget(self, action: #selector(ElementCatalog<UnitCD>.cancel), for: .touchUpInside)
        savebatton.addTarget(self, action: #selector(ElementCatalog<UnitCD>.save), for: .touchUpInside)
        nameElement.addTarget(self, action: #selector(ElementCatalog<UnitCD>.shortNameEditingChanged), for: .editingChanged)
        fullNameElement.addTarget(self, action: #selector(ElementCatalog<UnitCD>.fullNameEditingChanged), for: .editingChanged)

     //   imagePicker.delegate = self
    //    setGacture()
    }
    //--------------
    override func validateFillFields() -> Bool {
        if shortName.text!.isEmpty {
            let alert = UIAlertController(title: "Ошибка проверки", message: "Введите краткое наименование!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
        
    }
    
    //-----------------
    override func dataWasChanged() -> Bool {
        if self.unit == nil && ( !self.shortName.text!.isEmpty || self.favourite.on) {
            return true
        }
        if self.unit == nil {
            return false
        }
        if self.unit?.shortname != self.shortName.text {
            return true
        }
        if self.unit?.favourite != self.favourite.on {
            return true
        }
        if self.unit?.fullname !=  self.fullNameElement.text {
            return true
        }
        return false
    }
    
    //--------------
    override func getNameElement(unit : UnitCD) -> String {
        return unit.fullname!
    }
    //-------------------
    
    override func copyDataFromField(unit : UnitCD) {
        unit.shortname = self.shortName.text!
        unit.favourite = self.favourite.on
        unit.fullname = self.fullNameElement.text
    }
    
    //---------------
    override func pasteDataToField(unit : UnitCD) {
        self.shortName.text = unit.shortname
        self.favourite.on = unit.favourite
        self.fullNameElement.text = unit.fullname
    }
    
    //---------------------
    override func createTypeElement() -> UnitCD {
        return UnitCD()
    }
    
    //------------------
    override public func setVisibleLables() {
        super.setVisibleLables()
        fullNameLable.isHidden = (fullname.text?.isEmpty)!
    }
    
    //------------
    override public func setDelegate() {
        super.setDelegate()
        fullname.delegate = self
    }

}
