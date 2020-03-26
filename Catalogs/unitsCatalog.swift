//
//  unitsCatalog.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 25.08.2018.
//  Copyright © 2018 Olexandr Baybuz. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class unitsCatalog : Catalog<UnitCD> {

    @IBOutlet weak var openSideOutUnit: UIBarButtonItem!
    @IBOutlet weak var addButtonUnit: UIBarButtonItem!
    @IBOutlet weak var choiceButtonUnit: UIBarButtonItem!
    @IBOutlet weak var editButtonUnit: UIBarButtonItem!
 
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        self.entityName = "UnitCD"
        self.fieldForSort = "fullname"
        self.fieldForSearch = "fullname"
        self.fieldFavourite = "favourite"
        self.segueAddEdit = "unitsCatalogToUnit"
        self.colorNavigationBar = .backGray
        self.colorTableSeparator = .backGreen
  //      self.OpenSideout = openSideOutUnit
    }
    
    override func viewDidLoad() {
        self.OpenSideout = openSideOutUnit
        self.addButton = addButtonUnit
        self.editButton = editButtonUnit
        self.choiceButton = choiceButtonUnit
        super.viewDidLoad()
   //     tableView.separatorColor = .backGreen
   //     self.navigationController?.navigationBar.barTintColor = .backGray
    }
    
   override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unitsCatalogToUnit" {
            let controller = segue.destination as! unitsAdd
            controller.unit = sender as? UnitCD
        }
    }
    
    override public func changeFavourite(unit: UnitCD!) {
       unit.favourite = !unit.favourite
       CoreDataManager.instance.saveContext()
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let unit = fetchedResultsController.object(at: indexPath) as! UnitCD
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        cell.accessoryType = UITableViewCell.AccessoryType.detailDisclosureButton
        fillCell(cell: cell, unit: unit)
        cell.layer.borderColor = self.colorTableSeparator?.cgColor
        cell.layer.borderWidth = 7
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true

        return cell
        
    }
 
 //--------
    override public func fillCell(cell: UITableViewCell, unit: UnitCD) {
        if unit.favourite {
            cell.textLabel?.textColor = .magenta
            cell.detailTextLabel?.textColor = .magenta
        }
        cell.textLabel?.text = unit.fullname
        cell.detailTextLabel?.text = "(" + unit.shortname + ")"
    }
 //---------
    override func isFavourite(unit: UnitCD) -> Bool {
        return unit.favourite
    }
}
