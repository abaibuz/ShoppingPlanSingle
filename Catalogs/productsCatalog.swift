//
//  productsCatalog.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 3/10/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class productsCatalog: Catalog<ProductsCD>, UIGestureRecognizerDelegate {
    @IBOutlet weak var openSideOutCatagories: UIBarButtonItem!
    @IBOutlet weak var choiceButton1: UIBarButtonItem!
    @IBOutlet weak var editButton1: UIBarButtonItem!
    @IBOutlet weak var addButton1: UIBarButtonItem!
    @IBOutlet weak var firstRowButton: UIBarButtonItem!
    @IBOutlet weak var lastRorButton: UIBarButtonItem!
    
    required init?(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        self.entityName = "ProductsCD"
        self.fieldForSort = "name"
        self.fieldForSearch = "name"
        self.fieldFavourite = "favourite"
        self.fieldSelected = "selected"
        self.colorNavigationBar = .backNavigationBarProduct
        self.colorTableSeparator = .backScrollViewProduct
        self.segueAddEdit = "productsAdd"
        
    }
    
    override func viewDidLoad() {
        self.OpenSideout = openSideOutCatagories
        self.addButton = addButton1
        self.editButton = editButton1
        self.choiceButton = choiceButton1
        self.goToFirstRowButton = firstRowButton
        self.goToLastRowButton = lastRorButton
        super.viewDidLoad()
    }
    
    //--------
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    //-----------
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "productsAdd" {
            let controller = segue.destination as! productsAdd
            if let unit   = sender as? ProductsCD {
                controller.unit = unit
            }
        }
        
        if segue.identifier == "showImageProduct" {
            if sender != nil {
                let indexPath = sender as! IndexPath
                let product = fetchedResultsController.object(at: indexPath) as! ProductsCD
                let controller = segue.destination as! ShowImageVC
                controller.product = product
                if product.image != nil {
                    controller.image = UIImage(data: product.image! as Data)
                }
                controller.nameUnit = product.name!
                controller.nameCatalog = "Товары"
              }
        }
        
    }
    
    
    //---------------
    override func changeFavourite(unit: ProductsCD!) {
        unit.favourite = !unit.favourite
        CoreDataManager.instance.saveContext()
    }
        
    //--------------
    override public func fillCell(cell: UITableViewCell, unit: ProductsCD) {
        if unit.favourite {
            cell.textLabel?.textColor = .magenta
            cell.detailTextLabel?.textColor = .magenta
        }
        cell.textLabel?.text = unit.name
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.numberOfLines = 0

        cell.layer.borderColor = self.colorTableSeparator?.cgColor
        cell.layer.borderWidth = 7
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        cell.clipsToBounds = true
    }
    
    //---------------------
    override func isFavourite(unit: ProductsCD) -> Bool {
        return unit.favourite
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
            performSegue(withIdentifier: "showImageProduct", sender: sender)
    }
    
    //-------------
    override func compareElementcatalog(unit1: ProductsCD, unit2: ProductsCD) -> Bool {
        return unit1 == unit2
    }
    
    //--------
    override func getIndexPathUnit() -> IndexPath! {
        if let unit = self.unit {
            let arrayUnit = fetchedResultsController.fetchedObjects as! [ProductsCD]?
            if let index = arrayUnit?.firstIndex(of: unit) {
                return IndexPath(row: index, section: 0)
            }
        }
        return nil
    }
    
   override public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = self.contextualToggleAlltAction(forRowAtIndexPath: indexPath, title: "Фото", image: UIImage(named: "icons8-компактная-камера-22")!, сolor: UIColor.white, backgroundColor: UIColor.systemBlue, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.performSegue(withIdentifier: "showImageProduct", sender: indexPath)
            success(true)
        })
        var actionArray: [UIContextualAction] = super.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)!.actions
        actionArray.append(editAction)
        let swipeActionConfig = UISwipeActionsConfiguration(actions: actionArray)
        return swipeActionConfig
    }
    
    override func setSelectedField(unit: ProductsCD, boolValue: Bool) {
        unit.selected = boolValue
    }
}
