//
//  categoriesCatalogTableViewController.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 2/21/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class categoriesCatalog: Catalog<Categories> {

    @IBOutlet weak var openSideOutCatagories: UIBarButtonItem!
    @IBOutlet weak var choiceButton1: UIBarButtonItem!
    @IBOutlet weak var editButton1: UIBarButtonItem!
    @IBOutlet weak var addButton2: UIBarButtonItem!
    @IBOutlet weak var firstRowButton: UIBarButtonItem!
    @IBOutlet weak var lastRowButton: UIBarButtonItem!
    
    required init?(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        self.entityName = "Categories"
        self.fieldForSort = "name"
        self.fieldForSearch = "name"
        self.fieldFavourite = "favourite"
        self.colorNavigationBar = .backNavigationBar
        self.colorTableSeparator = .backScrollView
        self.segueAddEdit = "categoriesAdd"
        
    }
    
    override func viewDidLoad() {
        self.OpenSideout = openSideOutCatagories
        self.addButton = addButton2
        self.editButton = editButton1
        self.choiceButton = choiceButton1
        self.goToFirstRowButton = firstRowButton
        self.goToLastRowButton = lastRowButton
        super.viewDidLoad()
    }
  
    //--------
 /*   override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
 */
    //------
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    //-------
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categoriesAdd" {
            let controller = segue.destination as! categoriesAdd
            if let unit = sender as? Categories {
                controller.unit = unit
            }
        }
        
    }
    
    override func changeFavourite(unit: Categories!) {
             unit.favourite = !unit.favourite
             CoreDataManager.instance.saveContext()
    }
   //------------
    override public func fillCell(cell: UITableViewCell, unit: Categories) {
        if unit.favourite {
            cell.textLabel?.textColor = .magenta
            cell.detailTextLabel?.textColor = .magenta
        }
        cell.textLabel?.text = unit.name
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.numberOfLines = 0
        if let image = unit.image {
            let image1 = UIImage(data: image as Data)
       //     cell.imageView?.frame = CGRect(x : 10, y : 10,width: 48, height: 48)
      //  cell.imageView?.image = imageWithImage(image: image1!, scaledToSize: CGSize(width: 48, height: 48))
            cell.imageView?.image = image1
      //      cell.imageView?.contentMode = .scaleAspectFill
        
        }
        cell.layer.borderColor = self.colorTableSeparator?.cgColor
        cell.layer.borderWidth = 7
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
   //     cell.clipsToBounds = true
    }
    
    override func isFavourite(unit: Categories) -> Bool {
        return unit.favourite
    }
}
