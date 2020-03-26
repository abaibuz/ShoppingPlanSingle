//
//  wihListCatalog.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 5/19/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class wishListCatalog: Catalog<WishList>, UIGestureRecognizerDelegate {
    @IBOutlet weak var openSideOutCatagories: UIBarButtonItem!
    @IBOutlet weak var choiceButton1: UIBarButtonItem!
    @IBOutlet weak var editButton1: UIBarButtonItem!
    @IBOutlet weak var addButton2: UIBarButtonItem!
    

    var existProduct: ProductsCD! = nil
    
    required init?(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented"
        super.init(coder: aDecoder)
        initValue()
    }
    
    func initValue() {
        self.entityName = "WishList"
        self.fieldForSort = "name"
        self.fieldForSearch = "name"
        self.fieldFavourite = "favourite"
        self.colorNavigationBar = .backNavigationBarWishList
        self.colorTableSeparator = .backScrollViewWishList
        self.segueAddEdit = "productAdd"
    }
    
    override func viewDidLoad() {
        self.OpenSideout = openSideOutCatagories
        self.addButton = addButton2
        self.editButton = editButton1
        self.choiceButton = choiceButton1
        super.viewDidLoad()
    }
    //-------------
    @IBAction func editingDidEndQuntityText(_ sender: UITextField) {
        if let cell = parentViewCell(uiView: sender as UIView) {
            if let indexPath = tableView.indexPath(for: cell) {
                let wishList = fetchedResultsController.object(at: indexPath) as! WishList
                let cellWishList = cell as! wishListCatalogCell
                wishList.quantity = convertingData().returtSringToFloat(stringIn: cellWishList.quntityText.text, fractionDigits: 3)
                reloadData()
            }
        }
    }
    //------
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    //-------
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productAdd" {
                let controller = segue.destination.children[0] as! productsCatalog
                if let unit = sender as? WishList {
                    controller.unit = unit.wishListProducts
                } else {
                    controller.multiSelect = true
                }
                controller.didSelect = { [unowned self] (selectUnitArray) in
                    if let unitArray = selectUnitArray {
                        for  product in unitArray {
                            if !self.isProductInWishList(product: product) {
                                var wishList: WishList
                                if let wishList1 = sender as? WishList {
                                    wishList = wishList1
                                } else {
                                    wishList = WishList()
                                }
                                wishList.wishListProducts = product
                                wishList.name = product.name
                                wishList.quantity = product.quantity
                                self.reloadData()
                                self.existProduct = nil
                            } else {
                                self.existProduct = product
                            }
                        }
                    }
                }
        }
        
        if segue.identifier == "pictureSegue" {
            if let indexPath = sender as? IndexPath {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                let wishList = fetchedResultsController.object(at: indexPath) as! WishList
                let controller = segue.destination as! ShowImageVC
                if let image = wishList.wishListProducts?.image {
                    controller.image = UIImage(data: image as Data)
                } else {
                    controller.image = UIImage(named: "icons8-картина-96 цветная")
                }
                controller.nameUnit = wishList.name!
                controller.nameCatalog = "Товары"
                controller.product = wishList.wishListProducts
            }
        
        }
    }
    //-----------
    override func viewDidAppear(_ animated: Bool) {
        if let product = self.existProduct  {
            self.alertExistProduct(product: product)
            self.existProduct = nil
        }
        reloadData()
    }
    //---------------
    private func alertExistProduct(product: ProductsCD!) {
        let message = "Товар \"\(product.name ?? "")\" уже присутствует в \"Списке желаний\". Выберите другой товар!"
        let alert = UIAlertController(title: "Предупреждение", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true, completion: nil)
     }

    //---------------
    public func isProductInWishList(product: ProductsCD) -> Bool {
        let wishList = fetchedResultsController.fetchedObjects as! [WishList]
        if wishList.count > 0 {
            return wishList.contains{ (wishList) -> Bool in
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
    override func changeFavourite(unit: WishList!) {
        unit.favourite = !unit.favourite
        reloadData()
    }
    //------------
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wishList = fetchedResultsController.object(at: indexPath) as! WishList
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishCell")! as! wishListCatalogCell
        fillCell1(cell: cell, unit: wishList)
        return cell

    }
    //-------
    private func fillCell1(cell: wishListCatalogCell, unit: WishList) {
        if unit.favourite {
            cell.productName?.textColor = .magenta
        } else {
            cell.productName?.textColor = UITextField.appearance().tintColor
        }
        let name = unit.name! + ", " + (unit.wishListProducts?.unit!.shortname)!
        cell.productName?.text = name
        cell.productName?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.productName?.numberOfLines = 0

        if let product = unit.wishListProducts {
            if let image = product.image {
                let image1 = UIImage(data: image as Data)
                //     cell.imageView?.frame = CGRect(x : 10, y : 10,width: 48, height: 48)
                //  cell.imageView?.image = imageWithImage(image: image1!, scaledToSize: CGSize(width: 48, height: 48))
                cell.imageProduct?.image = image1
                //      cell.imageView?.contentMode = .scaleAspectFill
                
            } else {
                cell.imageProduct?.image = UIImage(named: "icons8-картина-96 цветная")
            }
        }
        setGactureCell(imageView: cell.imageProduct)
        cell.quntityText.text = convertingData().returnFloatToString(floatIn: unit.quantity, fractionDigits: 3)
        cell.layer.borderColor = self.colorTableSeparator?.cgColor
        cell.layer.borderWidth = 7
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        //     cell.clipsToBounds = true
    }
   //---------
    override func isFavourite(unit: WishList) -> Bool {
        return unit.favourite
    }
    //------------
    func reloadData() {
  //      self.playFile(forResource: "Sound_windows restore", withExtension: "wav")
        CoreDataManager.instance.saveContext()
        self.fetcheDate()
        self.tableView.reloadData()
    }
    
    //----------------
    private func setGactureCell(imageView: UIImageView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(perfomeSegueCell))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    //--------
    @objc func perfomeSegueCell(sender: Any) {
        if let cell = parentViewCell(uiView: (sender as! UIGestureRecognizer).view!) {
            if let indexPath = tableView.indexPath(for: cell) {
                performSegue(withIdentifier: "pictureSegue", sender: indexPath)
            }
        }
    }
    
   
}
