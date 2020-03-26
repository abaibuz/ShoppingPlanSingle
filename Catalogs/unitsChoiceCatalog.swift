//
//  unitsChoiceCatalog.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 13.07.2018.
//  Copyright © 2018 Olexandr Baybuz. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/*
extension UIViewController: SWRevealViewControllerDelegate {
    
    func setupMenuGestureRecognizer() {
        
        revealViewController().delegate = self
        revealViewController().frontViewController.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        revealViewController().frontViewController.view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
    }
    
    //MARK: - SWRevealViewControllerDelegate
    public func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        let tagId = 112151
        if revealController.frontViewPosition == FrontViewPosition.right {
            let lock = self.view.viewWithTag(tagId)
            UIView.animate(withDuration: 0.25, animations: {
                lock?.alpha = 0
            }, completion: {(finished: Bool) in
                lock?.removeFromSuperview()
            }
            )
            lock?.removeFromSuperview()
        } else if revealController.frontViewPosition == FrontViewPosition.left {
            let lock = UIView(frame:  self.view.bounds)
            lock.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            lock.tag = tagId
            lock.alpha = 0
            lock.backgroundColor = UIColor.black
            lock.addGestureRecognizer(UITapGestureRecognizer(target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
            self.view.addSubview(lock)
            UIView.animate(withDuration: 0.75, animations: {
                lock.alpha = 0.333
            }
            )
        }
    }
    
}
*/

extension unitChoiceCatalog: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
 //       self.selectedScope = selectedScope
        filterContent(searchText: searchBar.text!, selectedScope: searchBar.selectedScopeButtonIndex)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
 //       self.selectedScope = 0
        searchBar.selectedScopeButtonIndex = 0
        filterContent(searchText: searchBar.text!, selectedScope: searchBar.selectedScopeButtonIndex)
     }
}


class unitChoiceCatalog : UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating  {
 
    typealias Select = (UnitCD?) -> ()
    var didSelect: Select?

    public var unit: UnitCD?
    var indexPathSelect: IndexPath?
    
    var fetchedResultsController  = CoreDataManager.instance.fetchedResultsController(entityName: "UnitCD", keyForSort: "fullname", predicate: nil)
    var searchController: UISearchController!
    var searchFooter: SearchFooter!

    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        filterContent(searchText: searchText!, selectedScope: searchController.searchBar.selectedScopeButtonIndex)
    }
    
    func filterContent(searchText: String, selectedScope: Int) {
        var filteredImemsCount: Int = 0
        var totalItemCount: Int = 0

        if searchText != "" {
            let predicate = selectedScope == 0 ? NSPredicate(format: "fullname CONTAINS[cd] %@", searchText) :
                                                 NSPredicate(format: "fullname CONTAINS[cd] %@ && favourite = %@", searchText, "1")
            fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "UnitCD", keyForSort: "fullname", predicate: predicate)
            fetchedResultsController.delegate = self as NSFetchedResultsControllerDelegate
        } else {
            let predicate = selectedScope == 0 ? nil : NSPredicate(format: "favourite = %@",  "1")
            fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "UnitCD", keyForSort: "fullname", predicate: predicate)
            fetchedResultsController.delegate = self as NSFetchedResultsControllerDelegate
        }
        do {
            try fetchedResultsController.performFetch()
            filteredImemsCount = fetchedResultsController.sections![0].numberOfObjects
            if searchText != "" {
                let predicate = selectedScope == 0 ? nil : NSPredicate(format: "favourite = %@",  "1")
                let fetchedResultsControllerTotal = CoreDataManager.instance.fetchedResultsController(entityName: "UnitCD", keyForSort: "fullname", predicate: predicate)
                do {
                    try fetchedResultsControllerTotal.performFetch()
                    totalItemCount = fetchedResultsControllerTotal.sections![0].numberOfObjects
                }
                catch{
                    print(error)
                    
                }
            } else {
                    totalItemCount = filteredImemsCount
            }
        } catch {
            print(error)
        }
        indexPathSelect = nil
        self.searchFooter.setIsFilteringToShow(filteredItemCount: filteredImemsCount, of: totalItemCount)
        tableView.reloadData()

    }
    
    @IBAction func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func choiceTapped(_ sender: Any) {
        if let indexPath = indexPathSelect {
            let unit = fetchedResultsController.object(at: indexPath) as? UnitCD
    
            if searchController.isActive {
 //               searchController.searchBar.text = ""
                searchController.isActive = false
            }

            if let dSelect = self.didSelect {
                dSelect(unit)
                dismiss(animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Ошибка проверки", message: "Выберите строку таблицы!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
   
    @IBAction func editTapped(_ sender: Any) {
        if indexPathSelect != nil {
             let unit = fetchedResultsController.object(at: indexPathSelect!) as? UnitCD
             performSegue(withIdentifier: "unitsCatalogToUnit", sender: unit)
        } else {
            let alert = UIAlertController(title: "Ошибка проверки", message: "Выберите строку таблицы!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    
    }
    
    @IBAction func addTapped(_ sender: Any) {
       if searchController.isActive {
  //        searchController.searchBar.text = ""
          searchController.isActive = false
        }
        performSegue(withIdentifier: "unitsCatalogToUnit", sender: nil)
    }
    
  
    @IBAction func choiceButtonTypped(_ sender: Any) {
        choiceTapped(sender)
    }
    
    @IBOutlet weak var OpenSideout: UIBarButtonItem!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self as NSFetchedResultsControllerDelegate
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Поиск..."
        searchController.searchBar.scopeButtonTitles = ["Все", "Избранное"]
        searchController.searchBar.showsScopeBar = false
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .candyGreen
        tableView.tableHeaderView = searchController.searchBar
        searchFooter = SearchFooter(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        searchFooter.searchBackgroundColor = .candyGreen
        tableView.tableFooterView = searchFooter
        definesPresentationContext = true
        
        if self.didSelect != nil {
           OpenSideout.image = UIImage(named: "icons8-отмена-22")
           OpenSideout.target = self
           OpenSideout.action = #selector(unitChoiceCatalog.cancelTapped)
           let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
           tap.numberOfTapsRequired = 2
           tableView.addGestureRecognizer(tap)
        } else {
            self.navigationItem.rightBarButtonItems?.remove(at: 0)
            setupMenuGestureRecognizer()
            OpenSideout.target = self.revealViewController()
            OpenSideout.action = #selector(SWRevealViewController.revealToggle(_:))
       }
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 1.0
        lpgr.delaysTouchesBegan = true
        tableView.addGestureRecognizer(lpgr)

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }

    }
    
    override func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if searchController.isActive {
            if revealController.frontViewPosition == FrontViewPosition.right {
                self.searchController.searchBar.isUserInteractionEnabled = true
        } else if revealController.frontViewPosition == FrontViewPosition.left {
                self.searchController.searchBar.isUserInteractionEnabled = false
               }
        }
        if revealController.frontViewPosition == FrontViewPosition.right {
            self.tableView.isUserInteractionEnabled = true
        } else if revealController.frontViewPosition == FrontViewPosition.left {
            self.tableView.isUserInteractionEnabled = false
        }

        super.revealController(revealController, willMoveTo: position)
    }
    
    @objc func handleLongPress(sender: UITapGestureRecognizer) {
        let tappoint = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: tappoint) {
            indexPathSelect = indexPath
            editTapped(0)
        }
    }
    
    @objc func doubleTapped(sender: UITapGestureRecognizer) {
        let tappoint = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: tappoint) {
            indexPathSelect = indexPath
            choiceTapped(0)
       }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let unit = fetchedResultsController.object(at: indexPath) as! UnitCD
        let cell = UITableViewCell()
        if unit.favourite {
            cell.textLabel?.textColor = .magenta
        }
        cell.textLabel?.text = unit.fullname
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unitsCatalogToUnit" {
            let controller = segue.destination as! UnitsAddAndEdit
            controller.unit = sender as? UnitCD
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert :
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
                indexPathSelect = indexPath
             }
        case .update:
            if let indexPath = indexPath {
                let unit = fetchedResultsController.object(at: indexPath) as! UnitCD
                let cell = tableView.cellForRow(at: indexPath)
                cell!.textLabel?.text = unit.fullname
                indexPathSelect = indexPath
             }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                indexPathSelect = nil
            }
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        updateSearchResults(for: self.searchController)
     }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPathSelect = indexPath
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if indexPathSelect != nil {
            tableView.selectRow(at: indexPathSelect!, animated: true, scrollPosition: .middle)
        }
    }
    
    func deleteunit(forRowAtIndexPath indexPath: IndexPath)  {
        let unit = self.fetchedResultsController.object(at: indexPath) as! UnitCD
        let fullname = unit.fullname
        let alert = UIAlertController(title: "Удаление элемента справочника", message: "Удалить \"\(fullname ?? "")\"", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler:{  (UIAlertAction) -> Void in
            let managedObject = self.fetchedResultsController.object(at: indexPath) as! NSManagedObject
            CoreDataManager.instance.managedObjectContext.delete(managedObject)
            CoreDataManager.instance.saveContext()

        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
  
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        self.indexPathSelect = indexPath
        let deleteAction = self.contextualToggleAlltAction(forRowAtIndexPath: indexPath, title: "Удалить", image: UIImage(named: "icons8-удалить-22")!, сolor: UIColor.white, backgroundColor: UIColor.red, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.deleteunit(forRowAtIndexPath: indexPath)
            success(true)
        })
        let editAction = self.contextualToggleAlltAction(forRowAtIndexPath: indexPath, title: "Изменить", image: UIImage(named: "icon edit pencil")!, сolor: UIColor.white, backgroundColor: UIColor.darkGray, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.indexPathSelect = indexPath
            self.editTapped(0)
            success(true)
        })

        let addAction = self.contextualToggleAlltAction(forRowAtIndexPath: indexPath, title: "Добавить", image: UIImage(named: "icons8-добавить-23")!, сolor: UIColor.white, backgroundColor: UIColor.brown, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.indexPathSelect = indexPath
            self.addTapped(0)
            success(true)
        })
        
        let unit = fetchedResultsController.object(at: indexPathSelect!) as? UnitCD
        var titleFavourite: String = "В избранное"
        var imageFavourite = UIImage(named:"icons8-сердце-30")
        if (unit?.favourite)! {
            titleFavourite = "Из избранного"
            imageFavourite = UIImage(named: "icons8-червы-30")
        }
        let favouriteAction = self.contextualToggleAlltAction(forRowAtIndexPath: indexPath, title: titleFavourite, image: imageFavourite!, сolor: UIColor.white, backgroundColor: UIColor.magenta, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.indexPathSelect = indexPath
            self.changeFavourite(unit: unit)
            success(true)
        })

        let swipeActionConfig = UISwipeActionsConfiguration(actions: [deleteAction,editAction,addAction,favouriteAction])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
    func changeFavourite(unit: UnitCD!) {
        unit.favourite = !unit.favourite
        CoreDataManager.instance.saveContext()
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if self.didSelect != nil {
            self.indexPathSelect = indexPath
            let choiceAction = self.contextualToggleAlltAction(forRowAtIndexPath: indexPath, title: "Выбрать", image: UIImage(named: "icons8-единый-выбор-filled-22")!, сolor: UIColor.white, backgroundColor: UIColor.blue, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                self.indexPathSelect = indexPath
                self.choiceTapped(0)
                success(true)
            })

            let swipeActionConfig = UISwipeActionsConfiguration(actions: [choiceAction])
            swipeActionConfig.performsFirstActionWithFullSwipe = false
            return swipeActionConfig
        } else {
          return nil
        }
    }
    
    func contextualToggleAlltAction(forRowAtIndexPath indexPath: IndexPath, title: String, image: UIImage, сolor: UIColor, backgroundColor: UIColor,  handler: @escaping UIKit.UIContextualActionHandler) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title:  "", handler: handler)
        let cell = tableView.cellForRow(at: indexPath)
        let rowHeight = (cell?.frame.height)!
        if let newImage = self.fixAction(title: title, image: image, сolor: сolor, rowHeight: rowHeight) {
            action.image = newImage
        } else {
            action.image = image
        }
        action.backgroundColor = backgroundColor
        return action
    }
    
    func fixAction(title: String, image:UIImage, сolor: UIColor, rowHeight: CGFloat) -> UIImage! {
        // make sure the image is a mask that we can color with the passed color
        let mask = image.withRenderingMode(.alwaysTemplate)
        // compute the anticipated width of that non empty string
        let titleAction = NSString(string: title)
        let stockSize = titleAction.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]) 
        // I know my row height
        let height:CGFloat = rowHeight + 2
        // Standard action width computation seems to add 15px on either side of the text
        let width = (stockSize.width + 30).rounded()
        let actionSize = CGSize(width: width, height: height)
        // lets draw an image of actionSize
        UIGraphicsBeginImageContextWithOptions(actionSize, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            context.clear(CGRect(origin: .zero, size: actionSize))
        }
        сolor.set()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes = [NSAttributedStringKey.foregroundColor: сolor, NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size: 12), NSAttributedStringKey.paragraphStyle: paragraphStyle]
   //      title.size(withAttributes: [NSAttributedStringKey : Any]?)
        let textSize = title.size(withAttributes: attributes )
        // implementation of `half` extension left up to the student
        let textPoint = CGPoint(x: (width - textSize.width)/2, y: (height - (textSize.height * 3))/2 + (textSize.height * 2))
        title.draw(at: textPoint, withAttributes: attributes )
        let maskHeight = textSize.height * 2
        let maskRect = CGRect(x: (width - maskHeight)/2, y: textPoint.y - maskHeight, width: maskHeight, height: maskHeight)
        mask.draw(in: maskRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

}
