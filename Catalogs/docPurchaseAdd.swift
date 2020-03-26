//
//  docPurchaseAdd.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 3/28/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class docPurchaseAdd: ElementCatalog<DocPurchase>, UITableViewDataSource, UITableViewDelegate {
    //-------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fetchedResultsController != nil {
            if let sections = fetchedResultsController.sections {
               return sections[section].numberOfObjects
            }
        }
        return 0
    }
    
    //---------
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    //---------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let tline = fetchedResultsController.object(at: indexPath) as! TLine
       let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell")! as! RowTableViewCellForDocPurchase
 //       let cell = UITableViewCell()
        
       if tline.switchLine {
            cell.backgroundColor = UIColor.green
        }
        else {
            cell.backgroundColor = UIColor.cyan
        }
     
        cell.productLabel.text = tline.productLine!.name
        cell.unitLabel.text = tline.unitLine?.shortname
        cell.quantityLabel.text = convertingData().returnFloatToString(floatIn: tline.quantityProduct, fractionDigits: 3)
        cell.priceLabel.text = convertingData().returnFloatToString(floatIn: tline.priceProduct, fractionDigits: 2)
        let sum = tline.quantityProduct * tline.priceProduct
        cell.sumLabel.text = convertingData().returnFloatToString(floatIn: sum, fractionDigits: 2)
        cell.switchLabel.on =  tline.switchLine
        if let image = tline.productLine?.category?.image {
            cell.imageCategory.image = UIImage(data: image as Data)
        }
        cell.layer.borderColor = self.colorTableSeparator.cgColor
        cell.layer.borderWidth = 6
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        return cell
    }
    //-----------------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == self.previuosSelected {
            return
        }
        
        let tline = fetchedResultsController.object(at: indexPath) as! TLine
        let cell = tableView.cellForRow(at: indexPath) as! RowTableViewCellForDocPurchase
    
        if let prIn = self.previuosSelected {
            let prtline = fetchedResultsController.object(at: prIn) as! TLine
            let prcell = tableView.cellForRow(at: prIn) as! RowTableViewCellForDocPurchase
            if let image = prtline.productLine?.category?.image {
                prcell.imageCategory.image = UIImage(data: image as Data)
            }
            prcell.imageCategory.isUserInteractionEnabled = false
        }
        
        if let image = tline.productLine?.image {
            cell.imageCategory.image = UIImage(data: image as Data)
        }
        self.previuosSelected = indexPath
        setGactureCell(imageView: cell.imageCategory)
  //      } else {
  //          self.previuosSelected = nil
  //      }

    }
    //--------
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let tline = fetchedResultsController.object(at: indexPath) as! TLine
        self.tableView(tableView, didSelectRowAt: indexPath)
  //      let cell = tableView.cellForRow(at: indexPath) as! RowTableViewCellForDocPurchase
        var title = "В желаемые"
        var name = "icons8-bookmark fill-24"

        if isProductInWishList(product: tline.productLine!) {
            title = "Из желаемых"
            name = "icons8-bookmark-22"
        }
        let choiceAction = self.contextualToggleAlltAction(forRowAtIndexPath: indexPath, title: title, image: UIImage(named: name)!, сolor: UIColor.white, backgroundColor: UIColor.blue, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if title == "В желаемые" {
                self.addProductToWishList(line: tline)
            } else {
                self.deleteProductFromWishList(tline: tline)
            }
            success(true)
        })
            
            let swipeActionConfig = UISwipeActionsConfiguration(actions: [choiceAction])
            swipeActionConfig.performsFirstActionWithFullSwipe = false
            return swipeActionConfig
    }
    
    //------
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions : [UIContextualAction] = []
       
        self.tableView(tableView, didSelectRowAt: indexPath)
        let deleteAction = self.contextualToggleAlltAction(forRowAtIndexPath: indexPath, title: "Удалить", image: UIImage(named: "icons8-удалить-22")!, сolor: UIColor.white, backgroundColor: UIColor.red, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.deleteProductIndexPath(indexPath: indexPath)
            success(true)
        })
        actions.append(deleteAction)
        
        let editAction = self.contextualToggleAlltAction(forRowAtIndexPath: indexPath, title: "Изменить", image: UIImage(named: "icon edit pencil")!, сolor: UIColor.white, backgroundColor: UIColor.darkGray, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.editProductIndexPath(indexPath: indexPath)
            success(true)
        })
        
        actions.append(editAction)
     /*
        let addAction = self.contextualToggleAlltAction(forRowAtIndexPath: indexPath, title: "Добавить", image: UIImage(named: "icons8-добавить-23")!, сolor: UIColor.white, backgroundColor: UIColor.brown, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.addProduct()
            success(true)
        })
     */
        
        // let tline = fetchedResultsController.object(at: indexPath) as! TLine
        //    let product = tline.productLine
       //   if product?.image != nil {
            let photoAction = self.contextualToggleAlltAction(forRowAtIndexPath: indexPath, title: "Фото", image: UIImage(named: "icons8-компактная-камера-22")!, сolor: UIColor.white, backgroundColor: UIColor.magenta, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                self.perfomeSegueCell(sender: 1)
                 success(true)
            })
            actions.append(photoAction)
       // }
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: actions)
        swipeActionConfig.performsFirstActionWithFullSwipe = true
        return swipeActionConfig
    }
    
    //----------
    func contextualToggleAlltAction(forRowAtIndexPath indexPath: IndexPath, title: String, image: UIImage, сolor: UIColor, backgroundColor: UIColor,  handler: @escaping UIKit.UIContextualAction.Handler) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title:  "", handler: handler)
        let cell = productTable.cellForRow(at: indexPath)
        let rowHeight = (cell?.frame.height)!
        if let newImage = self.fixAction(title: title, image: image, сolor: сolor, rowHeight: rowHeight) {
            action.image = newImage
        } else {
            action.image = image
        }
        action.backgroundColor = backgroundColor
        return action
    }

    //--------------
    private func setGactureCell(imageView: UIImageView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(perfomeSegueCell))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }

    //-------    
    @objc func perfomeSegueCell(sender: Any) {
        if self.previuosSelected != nil {
            performSegue(withIdentifier: pictureSegue, sender: nil)
        }
    }

    //-------------
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nameCatalog = "Мои покупки"
        self.colorTableSeparator = .backTableDocPurchase
        self.colorNavigationBar = .backNavigationBarDocPurchase
        self.pictureSegue = "showImageSegue"
        
    }
    
    var previuosSelected: IndexPath!
    @IBOutlet weak var productTable: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scrollViewProduct: UIScrollView!
    @IBOutlet weak var viewProduct: UIView!
    @IBOutlet weak var nvOutlet: UINavigationItem!
    @IBOutlet weak var titleDoc: UITextField!
    @IBOutlet weak var commentDoc: UITextField!
    @IBOutlet weak var quantitylabeloutlet: UILabel!
    
    @IBOutlet weak var productNumberLabeloutlet: UILabel!
    @IBOutlet weak var totalSumLabelOutlet: UILabel!
    
    
    private var dateDoc = Date()
    @IBOutlet weak var lableDate: UILabel!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    @IBOutlet weak var isPhotoCheck: BEMCheckBox!
    var purchasedSum: Float = 0
    var scheduledSum: Float = 0
    var purchasedNumber: Int16 = 0
    var scheduledNumber: Int16 = 0
   
    //---------------
    override func viewDidLoad() {
        self.scrollView = scrollViewProduct
        self.shortName = titleDoc
   //     self.favourite = favouriteElemebt
   //     self.shortNameLable = nameLabel
        self.fullname = commentDoc
   //     self.fullNameLable = fullNameLabel
        self.viewForScrollView = viewProduct
        self.navigationController?.navigationBar.barTintColor = self.colorNavigationBar
        super.viewDidLoad()
        cancelButton.addTarget(self, action: #selector(ElementCatalog<DocPurchase>.cancel), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(ElementCatalog<DocPurchase>.save), for: .touchUpInside)
        titleDoc.addTarget(self, action: #selector(ElementCatalog<DocPurchase>.shortNameEditingChanged), for: .editingChanged)
        commentDoc.addTarget(self, action: #selector(ElementCatalog<DocPurchase>.fullNameEditingChanged), for: .editingChanged)
        
        self.isPhotoCheck.isUserInteractionEnabled = false
  //      productTable.delegate = self
  //      productTable.dataSource = self
 //       productTable.allowsSelection = true
        fetchData()
        addButtononView()
        
    }
    
    //---------------
    func parentViewCell(uiView: UIView) -> UITableViewCell? {
        var viewOrNil: UIView? = uiView
        while let view = viewOrNil {
            if let cellView = view as? UITableViewCell {
                return cellView
            }
            viewOrNil = view.superview
        }
        return nil
    }

    //-------------
    @IBAction func switchChanged(_ sender: BEMCheckBox) {
        if let cell = parentViewCell(uiView: sender) {
            if let indexPath = productTable.indexPath(for: cell) {
                let tline = fetchedResultsController.object(at: indexPath) as! TLine
                tline.switchLine = sender.on
                self.reloadData()
                let indexPath1 = fetchedResultsController.indexPath(forObject: tline)
                self.previuosSelected = indexPath1
                self.repainTableCell(indexPath: indexPath1)
            }
        }
    }
    //---------------
     func fetchData()  {
        if let unit = unit {
            fetchedResultsController = DocPurchase.getTLineOfDoc(docPurchase: unit)
              do {
                try fetchedResultsController.performFetch()
                calcTotalSum()
            } catch {
                print(error)
            }
        }
    }
    //-----------
    func calcTotalSum() {
        var countObjects = self.fetchedResultsController.fetchedObjects?.count
        var productNumber: Int16 = 0
        var totalSum: Float = 0
        var puchaseSum: Float = 0
        if countObjects != nil {
            for i in 0..<countObjects! {
                let indexPath = IndexPath(row: i, section: 0)
                let tline = fetchedResultsController.object(at: indexPath) as! TLine
                    totalSum = totalSum + tline.quantityProduct * tline.priceProduct
                    if tline.switchLine {
                        productNumber = productNumber + 1
                        puchaseSum = puchaseSum + tline.quantityProduct * tline.priceProduct
                    }
            }
        } else {
            countObjects = 0
        }
        
        self.purchasedNumber = productNumber
        self.purchasedSum = puchaseSum
        self.scheduledNumber = Int16(countObjects!)
        self.scheduledSum = totalSum
        
        self.productNumberLabeloutlet.text = productNumber.description + "/" + countObjects!.description
        self.totalSumLabelOutlet.text = convertingData().returnFloatToString(floatIn: puchaseSum, fractionDigits: 2) + "/" +
                                        convertingData().returnFloatToString(floatIn: totalSum, fractionDigits: 2)
    }
    //--------------
    override func validateFillFields() -> Bool {
        if shortName.text!.isEmpty {
            let alert = UIAlertController(title: "Ошибка проверки", message: "Введите заголовок!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
        
    }
    
    //-----------------
    override func dataWasChanged() -> Bool {
        if self.unit == nil && ( !self.shortName.text!.isEmpty) {
            return true
        }
        
        if self.unit == nil {
            return false
        }
        
        if self.unit?.name != self.shortName.text {
            return true
        }
        
  //      if self.unit?.favourite != self.favourite.isOn {
  //          return true
  //      }
    
        if self.unit?.comment !=  self.commentDoc.text {
            return true
        }
        
        if self.unit?.scheduledSum != self.scheduledSum {
            return true
        }
  
        if self.unit?.scheduledNumber != self.scheduledNumber {
            return true
        }
        
        if self.unit?.purchasedSum != self.purchasedSum {
            return true
        }
        
        if self.unit?.purchasedNumber != self.purchasedNumber {
            return true
        }
        
        return false
    }
    
    //--------------

    
    override func getNameElement(unit : DocPurchase) -> String {
        return unit.name! + " от " + (unit.date! as Date).convertDateAndTimeToString
    }
    //-------------------
    
    override func copyDataFromField(unit : DocPurchase) {
        unit.name = self.shortName.text!
  //      unit.favourite = self.favourite.isOn
        unit.comment = self.fullname.text
        unit.date = self.dateDoc as NSDate
        unit.purchasedNumber = self.purchasedNumber
        unit.purchasedSum = self.purchasedSum
        unit.scheduledNumber = self.scheduledNumber
        unit.scheduledSum = self.scheduledSum
    }
    
    //---------------
    override func pasteDataToField(unit : DocPurchase) {
        self.shortName.text = unit.name
       //self.favourite.isOn = unit.favourite
        self.fullname.text = unit.comment
        self.dateDoc = unit.date! as Date
        self.lableDate.text = self.dateDoc.convertDateAndTimeToString
        self.isPhotoCheck.on = unit.checkImage != nil
    }
    //--------
    override func defaultFillFields() {
    //    self.unit = DocPurchase()
        self.dateDoc = Date()
        self.lableDate.text = self.dateDoc.convertDateAndTimeToString
}
    
    //---------------------
    override func createTypeElement() -> DocPurchase {
        return DocPurchase()
    }
    
    //------------------
    override public func setVisibleLables() {
   //     super.setVisibleLables()
   //     fullNameLable.isHidden = (fullname.text?.isEmpty)!
    }
    
    //------------
    override public func setDelegate() {
        super.setDelegate()
        fullname.delegate = self
    }
    
    @IBOutlet weak var menuButtonOutlet: UIButton!
 
    var menuTitles = ["Добавить", "Добавить из желаемых", "         Все", "         Избранные", "В желаемые", "Удалить из желаемых", "Обновить цены товаров" , "         Всех", "         Купленных","Назад"]
    var menuPictures = ["icons8-добавить-17", "icons8-bookmark-24", "", "", "icons8-bookmark fill-24", "icons8-bookmark-22", "icons8-ценник-24", "", "", "icons8-отмена-22"]
    var isUserEnable = [ true, false, true, true, true, true, false, true, true, true]
    
    //------------------
    @IBAction func fotoCheckButtonTapped(_ sender: Any) {
        if unit == nil {
            unit = createTypeElement()
            self.copyDataFromField(unit: unit!)
        }
        performSegue(withIdentifier: pictureSegue, sender: 1)
    }
    
    
    //------------------
    @IBAction func menuButtonTaped(_ sender: Any) {
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "popVC") else {
            return
        }
        popVC.modalPresentationStyle = .popover
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = menuButtonOutlet
   
        let xx: Double = Double(self.menuButtonOutlet.bounds.minX)
        let yy: Double = Double(self.menuButtonOutlet.bounds.maxY)
        popOverVC?.sourceRect = CGRect(x: xx, y: yy, width: 0, height: 0)
        popVC.preferredContentSize = CGSize(width: 240, height: 240)
        let popOverVCClass = popVC as! PopoverTableViewController
        popOverVCClass.setMenutitlesAndPictires(menuTitles1: menuTitles, menuPictures1: menuPictures, sizeSystemFont: 15, widthImage: 22, menuTitles2: nil, menuPictures2: nil)
        popOverVCClass.isUserEnable = self.isUserEnable
        popOverVCClass.choiceCellNum = { [unowned self] num in
            if num >= 0 {
                //popVC.dismiss(animated: true)
                self.runMenuFunc(numMenu: num)
            }
        }
        
        self.present(popVC, animated: true)

    }
    //------------------------------
    private func runMenuFunc(numMenu: Int) {
        switch numMenu {
        case 0:
            addProduct()
        case 2:
            pasteFromWishList(favourite: false)
        case 3:
            pasteFromWishList(favourite: true)
        case 4:
            editWishList(tline: nil, wishListActs: .add)
        case 5:
            editWishList(tline: nil, wishListActs: .remove)
        case 7:
            updatePrices(allProducts: true)
        case 8:
            updatePrices(allProducts: false)
        default:
            break
        }
        
    }
    //--------
    private func updatePrices(allProducts: Bool) {
        var numberUpdateProduct: Int = 0
        let tlines = self.fetchedResultsController.fetchedObjects as! [TLine]
        for line in tlines {
            if allProducts || (!allProducts && line.switchLine) {
                if let product = line.productLine {
                    if (product.unit != line.unitLine) || (product.sum != line.priceProduct) {
                        numberUpdateProduct = numberUpdateProduct + 1
                        product.unit = line.unitLine
                        product.sum = line.priceProduct
                    }
                }
            }
        }
        var massage: String
        if numberUpdateProduct > 0 {
            CoreDataManager.instance.saveContext()
            massage = "Для \(numberUpdateProduct) товаров цены и единицы измерений обновлены в справочнике \"Товары\"!"
        } else {
            massage = "Цены и единицы измерений актуальны для всех товаров. Обнолять их нет необходимости!"
        }
        
        let alert = UIAlertController(title: "Обновление цен!", message: massage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //-------
    private func pasteFromWishList(favourite: Bool) {
        let wishListArray = CoreDataManager.instance.getWishList(favourite: favourite)
        var countElement: Int16 = 0
        for wishList in wishListArray! {
            let product = wishList.wishListProducts
            product?.quantity = wishList.quantity
            self.addTline(producd: product!, tline: nil)
            countElement = countElement + 1
        }
        let massage = "Добавлено \(countElement) товаров из \"Списока желаемого\"!"
        let alert = UIAlertController(title: "Добавление из \"Списока желаемого\"", message: massage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    //------
    func editWishList(tline: TLine!, wishListActs: WishListActs ) {
        if fetchedResultsController == nil {
            let alert = UIAlertController(title: "Список желаемого", message: "Нет данных для корректировки \"Списка желаемого\"", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        var addElement: Int16 = 0
        switch wishListActs {
            case .add:
                if tline == nil {
                    let tlines = fetchedResultsController.fetchedObjects as! [TLine]
                    for line in tlines {
                        if !isProductInWishList(product: line.productLine!) {
                            addProductToWishList(line: line)
                            addElement = addElement + 1
                        }
                        
                    }
                    var massage = "Добавлено \(addElement) из \(tlines.count) товаров в \"Список желаемого\"!"
                    if addElement < tlines.count {
                        massage = massage + " Остальные товары уже есть в \"Список желаемого\"!"
                    }
                    let alert = UIAlertController(title: "Добавление в \"Список желаемого\"", message: massage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
   
                    if !isProductInWishList(product: tline.productLine!) {
                        addProductToWishList(line: tline)
                    }
                }
            
          case .remove:
             if tline == nil {
                let tlines = fetchedResultsController.fetchedObjects as! [TLine]
                for line in tlines {
                    if isProductInWishList(product: line.productLine!) {
                        deleteProductFromWishList(tline: line)
                        addElement = addElement + 1
                    }
                }
                var massage = "Удалено \(addElement) из \(tlines.count) товаров из \"Списока желаемого\"!"
                if addElement < tlines.count {
                    massage = massage + " Остальные товаров нет в \"Списоке желаемого\"!"
                }
                let alert = UIAlertController(title: "Удаление из \"Списока желаемого\"", message: massage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                        deleteProductFromWishList(tline: tline)
            }
                
        }
    }
    
    //---------
    private func isProductInWishList(product: ProductsCD) -> Bool {
        let wishList = CoreDataManager.instance.getWishList(favourite: false)
        if wishList!.count > 0 {
            return wishList!.contains{ (wishList) -> Bool in
                if wishList.wishListProducts == product {
                    return true
                } else {
                    return false
                }
            }
        }
        return false
    }
    //----------------
    private func addProductToWishList(line: TLine) {
        let wishList = WishList()
        wishList.wishListProducts = line.productLine
        wishList.name = line.productLine?.name
        wishList.quantity = line.quantityProduct
        CoreDataManager.instance.saveContext()
    }
    //--------------
    private func deleteProductFromWishList(tline: TLine) {
        let product = tline.productLine
        if isProductInWishList(product: product!) {
            let wishList = CoreDataManager.instance.getWishList(favourite: false)
            if let object = wishList!.filter({ $0.wishListProducts == product }).first {
                let managedObject = object as NSManagedObject
                //self.fetchedResultsController.object(at: IndexPath) as! NSManagedObject
                CoreDataManager.instance.managedObjectContext.delete(managedObject)
                CoreDataManager.instance.saveContext()
            }
        }
    }
    //---------------
    @objc private func addProduct() {
        performSegue(withIdentifier: "addEditProductLine", sender: nil)
    }
    
    //--------------------
    private func editProduct() {
        if let selectedRows = productTable.indexPathsForSelectedRows {
            self.editProductIndexPath(indexPath: selectedRows[0])
        }
    }
    //--------------
    private func editProductIndexPath(indexPath: IndexPath!) {
        if let indexPath = indexPath {
            self.editPriceSumPopover(indexPath: indexPath)
        
        }
    }
    //------------
    private func deleteProduct() {
        if let selectedRows = productTable.indexPathsForSelectedRows {
            let indexPath = selectedRows[0]
            self.deleteProductIndexPath(indexPath: indexPath)
        }
    }
    
    //--------
    private func deleteProductIndexPath(indexPath: IndexPath!) {
        if let indexPath = indexPath {
            let alert = UIAlertController(title: "Удаление строки!", message: "Удалить?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler:{  (UIAlertAction) -> Void in
                let managedObject = self.fetchedResultsController.object(at: indexPath) as! NSManagedObject
                CoreDataManager.instance.managedObjectContext.delete(managedObject)
                CoreDataManager.instance.saveContext()
                self.fetchData()
                self.productTable.reloadData()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //---------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addEditProductLine" {

            let controller  = segue.destination.children[0]  as! productsCatalog
            let tline = sender as? TLine
            if tline != nil {
                controller.unit = tline!.productLine
            }
            controller.multiSelect = true
            controller.didSelect = { [unowned self] (unitArray) in
                for unit1 in unitArray! {
                    self.addTline(producd: unit1, tline: tline)
                }
            }
            return
        }
        
        if segue.identifier == "seguePhotoCheck" {
                let controller  = segue.destination  as! photoCheck
                controller.unit = unit
                return
        }
        
        if segue.identifier == pictureSegue {
            if sender == nil {
                if let selectedIndexPath = self.previuosSelected {
                    let prtline = fetchedResultsController.object(at: selectedIndexPath) as! TLine
                    let controller = segue.destination as! ShowImageVC
                    if let image = prtline.productLine!.image {
                        controller.image = UIImage(data: image as Data)
                    }
                    controller.nameUnit = prtline.productLine!.name!
                    controller.nameCatalog = "Товары"
                controller.product = prtline.productLine
              }
          }
          else {
                let controller = segue.destination as! ShowImageVC
                controller.product = unit
                controller.nameUnit = unit!.name! + " от " + unit!.date!.description
                controller.nameCatalog = "Мои покупки"
                if let image = unit!.checkImage {
                    controller.image = UIImage(data: image as Data)
                }
            return
          }

        }
    }
    
    //----------------------
    private func addTline(producd: ProductsCD, tline: TLine!) {
        if unit == nil {
           unit = createTypeElement()
           self.copyDataFromField(unit: unit!)
      //     CoreDataManager.instance.saveContext()
        }
        var mytline: TLine
        if tline == nil {
           mytline = TLine()
           mytline.numberLine = calcMaxNumberLine()
        } else {
            mytline = tline
        }
        TLine.copyFromProductsCD(dest: mytline, source: producd, doc: unit!)
        self.reloadData()
    }
    
    //---------------
    private func calcMaxNumberLine() -> Int16 {
        var maxNumberLine : Int16 = 0
        
        if let fetchRes = self.fetchedResultsController {
            let fetchObjects = fetchRes.fetchedObjects as! [TLine]
                if fetchObjects.count > 0 {
                    for record in fetchObjects {
                        if maxNumberLine < record.numberLine {
                            maxNumberLine = record.numberLine
                        }
                    }
                }
        }
        return maxNumberLine + 1
    }
    
    //-------------
    override func viewDidAppear(_ animated: Bool) {
        if let unit = unit {
            self.isPhotoCheck.on = unit.checkImage != nil
       //         self.productTable.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            self.repainTableCell(indexPath: self.previuosSelected)
        }
    }
    
    // ------------------
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
       self.repainTableCell(indexPath: indexPath!)
    }
    
    
    //-----------
 //   func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
 //       self.repainTableCell(indexPath: indexPath)
 //   }
    //-----------
    func repainTableCell(indexPath: IndexPath!) {
        if let indexPath = indexPath {
            self.productTable.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            productTable.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
            let cell = productTable.cellForRow(at: indexPath) as! RowTableViewCellForDocPurchase
            let tline = fetchedResultsController.object(at: indexPath) as! TLine
            if let image = tline.productLine?.image {
                cell.imageCategory.image = UIImage(data: image as Data)
            }
            setGactureCell(imageView: cell.imageCategory)
        }
    }
    //----------------
    
      func addButtononView() {
        //create a button or any UIView and add to subview
        let button = UIButton.init(type: .custom)
     //   button.setTitle("+", for: .normal)
     //   button.backgroundColor = .blue
     //   button.tintColor = .white
        button.setBackgroundImage(UIImage(named: "icons8-добавить-filled-75 aqua"), for: .normal)
     //   button.imageView?.image = UIImage(named: "icons8-добавить-23")
        button.frame.size = CGSize(width: 100, height: 100)
     //  button.layer.cornerRadius = 0.5 * button.bounds.size.width
     //   button.layer.masksToBounds = true
    //    button.layer.borderWidth = 1
    //    button.layer.borderColor = UIColor.blue.cgColor
        self.view.addSubview(button)
        
        //set constrains
        button.translatesAutoresizingMaskIntoConstraints = false
        button.rightAnchor.constraint(equalTo: productTable.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        button.bottomAnchor.constraint(equalTo: productTable.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
            
  //      } else {
    //        button.rightAnchor.constraint(equalTo: productTable.layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
    //        button.bottomAnchor.constraint(equalTo: productTable.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
      //  }
        
        button.addTarget(self, action: #selector(addProduct), for: .touchUpInside)
        
    }
 
}
