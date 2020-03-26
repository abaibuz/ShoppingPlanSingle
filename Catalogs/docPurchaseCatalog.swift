//
//  docPurchaseCatalog.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 3/20/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class docPurchaseCatalog : Catalog<DocPurchase> {
    
    @IBOutlet weak var openSideOutUnit: UIBarButtonItem!
    @IBOutlet weak var addButtonUnit: UIBarButtonItem!
    @IBOutlet weak var choiceButtonUnit: UIBarButtonItem!
    @IBOutlet weak var editButtonUnit: UIBarButtonItem!
    
    @IBOutlet weak var gotoFirstRowButton: UIBarButtonItem!
    @IBOutlet weak var lastRowButton: UIBarButtonItem!
    
    required init?(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        self.entityName = "DocPurchase"
        self.fieldForSort = "date"
        self.ascending = false
        self.localizedCaseInsensitiveCompare = false
        self.fieldForSearch = "name"
        self.fieldFavourite = "favourite"
        self.segueAddEdit = "docToTLine"
        self.colorNavigationBar = .backNavigationBarDocPurchase
        self.colorTableSeparator = .backTableDocPurchase
        //      self.OpenSideout = openSideOutUnit
    }
    
    override func viewDidLoad() {
        self.OpenSideout = openSideOutUnit
        self.addButton = addButtonUnit
        self.editButton = editButtonUnit
        self.choiceButton = choiceButtonUnit
        self.goToFirstRowButton = gotoFirstRowButton
        self.goToLastRowButton = lastRowButton
        super.viewDidLoad()
        tableView.separatorColor = .backTableDocPurchase
        self.navigationController?.navigationBar.barTintColor = .backNavigationBarDocPurchase
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "docToTLine" {
            let controller = segue.destination.children[0] as! docPurchaseAdd
            if let doc = sender {
                controller.unit = doc as? DocPurchase
            }
        }
        if segue.identifier == "photoCheckSegue" {
            let controller = segue.destination as! ShowImageVC
            if let indexPath = sender {
                let doc = fetchedResultsController.object(at: indexPath as! IndexPath) as! DocPurchase
                controller.product = doc
                controller.nameUnit = doc.name! + " от " + doc.date!.description
                controller.nameCatalog = "Мои покупки"
                if let image = doc.checkImage {
                    controller.image = UIImage(data: image as Data)
                }
                
            }
        }
            
    }
    
    override func changeFavourite(unit: DocPurchase!) {
        unit.favourite = !unit.favourite
        CoreDataManager.instance.saveContext()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let doc = fetchedResultsController.object(at: indexPath) as! DocPurchase
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseCell")! as! TableViewCellForDocPurchase

   //     let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
    //    cell.accessoryType = UITableViewCell.AccessoryType.detailDisclosureButton
        fillCell(cell: cell, unit: doc)
        cell.layer.borderColor = self.colorTableSeparator?.cgColor
        cell.layer.borderWidth = 6
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        
        return cell
        
    }
    //-------------
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86.0
    }
    
    
    //--------
    override func fillCell(cell: UITableViewCell, unit: DocPurchase) {
        let cell1 = cell as! TableViewCellForDocPurchase
        if unit.favourite {
      //      cell1.nameLabel?.textColor = .magenta
            cell1.dateLabel?.textColor = .magenta
      //      cell1.commentLabel?.textColor = .magenta
        } else {
            cell1.dateLabel?.textColor = UILabel.appearance().tintColor
        }
        cell1.nameLabel.text = unit.name
        cell1.dateLabel.text = (unit.date! as Date).convertDateAndTimeToString
        cell1.commentLabel.text = unit.comment
    
        let quantityLablel = unit.purchasedNumber.description + "/" + unit.scheduledNumber.description
        let sumLabel = convertingData().returnFloatToString(floatIn: unit.purchasedSum, fractionDigits: 2)  + "/" + convertingData().returnFloatToString(floatIn: unit.scheduledSum, fractionDigits: 2)
        
        cell1.quantityLabel.text = quantityLablel
        cell1.sumLabel.text = sumLabel
        
        cell1.checkLabel.isUserInteractionEnabled = false
        cell1.checkLabel.on = unit.checkImage != nil
   }
    //---------
    override func isFavourite(unit: DocPurchase) -> Bool {
        return unit.favourite
    }
    //----------
    override public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = self.contextualToggleAlltAction(forRowAtIndexPath: indexPath, title: "Фото чека", image: UIImage(named: "icons8-компактная-камера-22")!, сolor: UIColor.white, backgroundColor: UIColor.systemBlue, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.performSegue(withIdentifier: "photoCheckSegue", sender: indexPath)
            success(true)
        })
        var actionArray: [UIContextualAction] = super.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)!.actions
        actionArray.append(editAction)
        let swipeActionConfig = UISwipeActionsConfiguration(actions: actionArray)
        return swipeActionConfig
    }
    
}

