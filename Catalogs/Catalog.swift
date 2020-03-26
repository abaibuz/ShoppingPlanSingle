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


class Catalog<Typecatalog> : UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
 
    typealias Select = ([Typecatalog]?) -> ()
    var didSelect: Select?
    var multiSelect: Bool = false
    var cancelBbutton: UIButton?

    
    public var unit: Typecatalog?
    public var unitsArray: [Typecatalog] = []

    var indexPathSelect: IndexPath?
    
    var entityName: String?
    var fieldForSort: String?
    var ascending: Bool = true
    var localizedCaseInsensitiveCompare: Bool = true

    var fieldForSearch : String?
    var fieldFavourite: String?
    var fieldSelected: String?
    var segueAddEdit: String?
    var colorNavigationBar: UIColor?
    var colorTableSeparator: UIColor?

    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var searchController: UISearchController!
    var searchFooter: SearchFooter!

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //       self.selectedScope = selectedScope
        filterContent(searchText: searchBar.text!, selectedScope: searchBar.selectedScopeButtonIndex)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //       self.selectedScope = 0
        searchBar.selectedScopeButtonIndex = 0
        filterContent(searchText: searchBar.text!, selectedScope: searchBar.selectedScopeButtonIndex)
  //      searchBar.sizeToFit()
    }

    public func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        filterContent(searchText: searchText!, selectedScope: searchController.searchBar.selectedScopeButtonIndex)
    }
    
    func filterContent(searchText: String, selectedScope: Int) {
        var filteredImemsCount: Int = 0
        var totalItemCount: Int = 0

        if searchText != "" {
            let predicate = selectedScope == 0 ? NSPredicate(format: "\(self.fieldForSearch!) CONTAINS[cd] %@", searchText) :
                            selectedScope == 1 ? NSPredicate(format: "\(self.fieldForSearch!) CONTAINS[cd] %@ && \(self.fieldFavourite!) = %@", searchText, "1") :
                                                 NSPredicate(format: "\(self.fieldForSearch!) CONTAINS[cd] %@ && \(self.fieldSelected!) = %@", searchText, "1")
            fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: self.entityName!, keyForSort: self.fieldForSort!, predicate: predicate, ascending: ascending, localizedCaseInsensitiveCompare: localizedCaseInsensitiveCompare)
        } else {
             let predicate = selectedScope == 0 ? nil :
                             selectedScope == 1 ? NSPredicate(format: "\(self.fieldFavourite!) = %@",  "1") :
                                                  NSPredicate(format: "\(self.fieldSelected!) = %@",  "1")
                fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: self.entityName!, keyForSort: self.fieldForSort!, predicate: predicate, ascending: ascending, localizedCaseInsensitiveCompare: localizedCaseInsensitiveCompare)
        }
        fetchedResultsController.delegate = self as NSFetchedResultsControllerDelegate
        do {
                try fetchedResultsController.performFetch()
                filteredImemsCount = fetchedResultsController.sections![0].numberOfObjects
                if searchText != "" {
                    let predicate = selectedScope == 0 ? nil :
                                    selectedScope == 1 ? NSPredicate(format: "\(self.fieldFavourite!) = %@",  "1") :
                                                         NSPredicate(format: "\(self.fieldSelected!) = %@",  "1")
                    let fetchedResultsControllerTotal = CoreDataManager.instance.fetchedResultsController(entityName: self.entityName!, keyForSort: self.fieldForSort!, predicate: predicate, ascending: ascending, localizedCaseInsensitiveCompare: localizedCaseInsensitiveCompare)
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
    //-----------
    @IBAction func cancelTapped() {
        if searchController.isActive {
            searchController.isActive = false
            filterContent(searchText: "", selectedScope: 0)
        }
        if let dSelect = self.didSelect {
            for unit in self.unitsArray {
                 self.setSelectedField(unit: unit, boolValue: false)
                CoreDataManager.instance.saveContext()
            }
            dSelect(self.unitsArray)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //---------------------------
    @IBAction func choiceTapped(_ sender: Any) {
        if let indexPath = indexPathSelect {
            if let unit = fetchedResultsController.object(at: indexPath) as? Typecatalog {
                let isContains = arrayChoiceUnitsContainUnit(lastUnit: unit)
                if !isContains {
                    self.unitsArray.append(unit)
                    self.setSelectedField(unit: unit, boolValue: true)
                } else {
                    self.setSelectedField(unit: unit, boolValue: false)
                    self.unitsArray = self.unitsArray.filter {
                        element in
                        if !self.compareElementcatalog(unit1: element, unit2: unit) {
                            return true
                        } else {
                            return false
                        }
                    }
                }
                
                if !self.multiSelect {
                       self.cancelTapped()
                } else {
                    CoreDataManager.instance.saveContext()
                    fetcheDate()
                }
               tableView.reloadData()
            }
        } else {
            let alert = UIAlertController(title: "Ошибка проверки", message: "Выберите строку таблицы!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //----------
    public func setSelectedField(unit: Typecatalog, boolValue: Bool) {
        
    }
    
    //-----------
    public func arrayChoiceUnitsContainUnit(lastUnit: Typecatalog) -> Bool {
        if self.unitsArray.count > 0 {
            let isContains = self.unitsArray.contains {
                element in
                if self.compareElementcatalog(unit1: element, unit2: lastUnit) {
                    return true
                } else {
                    return false
                }
            }
            return isContains
        } else {
            return false
        }
    }
    
   //------------------
    @IBAction func editTapped(_ sender: Any) {
        if indexPathSelect != nil {
             let unit = fetchedResultsController.object(at: indexPathSelect!) as? Typecatalog
             performSegue(withIdentifier: self.segueAddEdit!, sender: unit)
        } else {
            let alert = UIAlertController(title: "Ошибка проверки", message:  "Выберите строку таблицы!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueAddEdit {
        //    let controller = segue.destination as! categoriesAdd
        //    controller.unit = sender as? Typecatalog
        }
    }
    //--------
    @IBAction func addTapped(_ sender: Any) {
       if searchController.isActive {
          searchController.isActive = false
          filterContent(searchText: "", selectedScope: 0)
        }
        performSegue(withIdentifier: self.segueAddEdit!, sender: nil)
    }
    
   //-------------
    @IBAction func choiceButtonTypped(_ sender: Any) {
        choiceTapped(sender)
    }
    //-------------------
    @IBAction func goToFirstRowMethod(_ sender: Any){
  //       if self.beginContentOffset == nil {
  //          tableView.setContentOffset(CGPoint(x: 0, y: 0) , animated: true)
  //       } else {
  //          tableView.setContentOffset(CGPoint(x: 0, y: self.beginContentOffset!) , animated: true)
  //      }
        
   //     let minimumOffset =  -tableView.frame.size.height
   //     tableView.setContentOffset(CGPoint(x: 0, y: 0) , animated: true)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
    //      tableView.reloadData()
    }
    
    //------
//    override func viewDidLayoutSubviews() {
//        let offsetY = tableView.contentOffset.y
//        print("offset = \(offsetY)")
//    }
    
    //-------------------
    @IBAction func goToLastRowMethod(_ sender: Any){
       let lastSectionIndex = tableView.numberOfSections - 1 // last section
       let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1 // last row
        tableView.scrollToRow(at: IndexPath(row: lastRowIndex, section: lastSectionIndex), at: UITableView.ScrollPosition.bottom, animated: true)
   //     print(tableView.contentOffset.y)
    //     let maximumOffset = tableView.contentSize.height - tableView.frame.size.height
   //     tableView.setContentOffset(CGPoint(x: 0, y: maximumOffset) , animated: true)
    }
    //-------------
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isEnabledGotoButton(scrollView)
    }
    
    //-----------------
    private func isEnabledGotoButton(_ scrollView: UIScrollView) {
        if self.goToFirstRowButton != nil {
            var isEnabled = true
            if let count = tableView.indexPathsForVisibleRows?.count {
                if count >= tableView.numberOfRows(inSection: 0) {
                   isEnabled = false
                } else {
                    if tableView.contentOffset.y < 0 {
                      isEnabled = false
                    } else {
                      let indexPath = tableView.indexPathsForVisibleRows![0]
                      if indexPath.row == 0 && indexPath.section == 0 {
                         isEnabled = false
                      }
                    }
                }
            } else {
                isEnabled = false
            }
            self.goToFirstRowButton.isEnabled = isEnabled
     //       print(scrollView.contentOffset.y)
        }
        
        if self.goToLastRowButton != nil {
            var isEnabled = true
            if let count = tableView.indexPathsForVisibleRows?.count {
//                print(count, tableView.numberOfRows(inSection: 0))
                if count >= tableView.numberOfRows(inSection: 0) {
                    isEnabled = false
                } else {
                    let currentOffset = tableView.contentOffset.y
                    let maximumOffset = tableView.contentSize.height - tableView.frame.size.height
                    let deltaOffset = maximumOffset - currentOffset

                    if deltaOffset < 0 {
                        isEnabled = false
                    } else {
                        let lastSectionIndex = tableView.numberOfSections - 1
                        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
                        
                        let indexPath = tableView.indexPathsForVisibleRows![tableView.indexPathsForVisibleRows!.count-1]
                        if indexPath.row == lastRowIndex && indexPath.section == lastSectionIndex {
                            isEnabled = false
                        }
                    }
                }
            } else {
                isEnabled = false
            }
            self.goToLastRowButton.isEnabled =  isEnabled
        }
        
    }
    //------------------------
    
    @IBOutlet weak var OpenSideout: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var choiceButton: UIBarButtonItem!
    @IBOutlet weak var goToFirstRowButton:  UIBarButtonItem!
    @IBOutlet weak var goToLastRowButton:  UIBarButtonItem!
    var beginContentOffset: CGFloat?
    
    //---------------
    public override func viewDidLoad() {
        super.viewDidLoad()
        initialCoreData()
        setSearchController()
        setButton()
        setColor()
       
        definesPresentationContext = true
        
        setOpenSideout ()
        setLongPressGestureRecognezer()
        fetcheDate()
        addButtononView()
        if multiSelect {
            cancelButtononView()
        }
  //      isEnabledGotoButton(tableView as UIScrollView)
    }
   
   
    
    //
    public func initialCoreData() {
        fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: self.entityName!, keyForSort: self.fieldForSort!, predicate: nil, ascending: ascending, localizedCaseInsensitiveCompare: localizedCaseInsensitiveCompare)
        fetchedResultsController.delegate = self as NSFetchedResultsControllerDelegate
    }
    
    //----------------
     public func fetcheDate() {
        do {
            try fetchedResultsController.performFetch()
            if  self.unit != nil {
                 if let indexPath =  getIndexPathUnit() {
                    self.indexPathSelect = indexPath
                }
            }
        } catch {
            print(error)
        }
    }
    //----------------
    public func getIndexPathUnit() -> IndexPath! {
 /*
        if let unit = self.unit {
            let arrayUnit = fetchedResultsController.fetchedObjects as! [Typecatalog]?
            if let index = arrayUnit?.firstIndex(of: unit) {
                return IndexPath(row: index, section: 0)
            }
        }
   */
        return nil
    }
 
    
    //---------------------
    private func setLongPressGestureRecognezer() {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 1.0
        lpgr.delaysTouchesBegan = true
        tableView.addGestureRecognizer(lpgr)
    }
    
    // ------------
    private func setOpenSideout () {
        if self.didSelect != nil {
            OpenSideout.image = UIImage(named: "icons8-отмена-22")
            OpenSideout.target = self
            OpenSideout.action = #selector(self.cancelTapped)
            let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
            tap.numberOfTapsRequired = 2
            tableView.addGestureRecognizer(tap)
        } else {
            self.navigationItem.rightBarButtonItems?.remove(at: 0)
            setupMenuGestureRecognizer()
            OpenSideout.target = self.revealViewController()
            OpenSideout.action = #selector(SWRevealViewController.revealToggle(_:))
        }

    }
    //-----------
    private func setSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self as? UISearchControllerDelegate
        searchController.searchResultsUpdater = self
    //    searchController.dimsBackgroundDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
    //    searchController.definesPresentationContext = false
        
        searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Поиск..."
        searchController.searchBar.scopeButtonTitles = ["Все","Избранные"]
        if multiSelect {
            searchController.searchBar.scopeButtonTitles = ["Все","Избранные","Выбранные"]
        }
    
        if #available(iOS 13.0, *) {
            
            searchController.automaticallyShowsScopeBar = true
            self.navigationItem.hidesSearchBarWhenScrolling = false
            self.navigationItem.searchController = searchController
        } else {
           searchController.searchBar.showsScopeBar = true
           tableView.tableHeaderView = searchController.searchBar
        }
        searchController.searchBar.delegate = self
   //     searchController.searchBar.tintColor = .candyGreen
        
        searchFooter = SearchFooter(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        searchFooter.searchBackgroundColor = .candyGreen
        tableView.tableFooterView = searchFooter
 
     //  searchController.searchBar.setTitleCancelButtonSearchBar(title: "Отмена")
    }
  //--------------------------------
    private func setButton() {
        if let button = addButton {
            button.target = self
            button.action = #selector(self.addTapped)
        }
        
        if let button = editButton {
            button.target = self
            button.action = #selector(self.editTapped)
        }
        
        if let button = choiceButton {
            button.target = self
            button.action = #selector(self.choiceTapped)
        }
        
        if let button = goToFirstRowButton{
            button.target = self
            button.action = #selector(self.goToFirstRowMethod)
        }
        
        if let button = goToLastRowButton{
            button.target = self
            button.action = #selector(self.goToLastRowMethod)
        }
    }
    
 //---------------------
    private func setColor() {
        if let color = colorNavigationBar {
            self.navigationController?.navigationBar.barTintColor = color
        }
        
        if let color = colorTableSeparator  {
            self.tableView.separatorColor = color
        }
    }
    
  //----------
    
    public override func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if #available(iOS 13.0, *) {
            let isUserInteractionEnabled = revealController.frontViewPosition == FrontViewPosition.right
            self.navigationItem.searchController!.searchBar.isUserInteractionEnabled = isUserInteractionEnabled
            //self.navigationItem.searchController!.isActive = isUserInteractionEnabled
        }
        else {
            if searchController.isActive {
                if revealController.frontViewPosition == FrontViewPosition.right {
                    self.searchController.searchBar.isUserInteractionEnabled = true
                } else if revealController.frontViewPosition == FrontViewPosition.left {
                    self.searchController.searchBar.isUserInteractionEnabled = false
                }
            } else {
                if revealController.frontViewPosition == FrontViewPosition.right {
                     isEnabledGotoButton(self.tableView as UIScrollView)
                } else if revealController.frontViewPosition == FrontViewPosition.left {
                    if let goToBut = self.goToFirstRowButton {
                        goToBut.isEnabled = false
                    }
                    if let goToBut = self.goToLastRowButton {
                        goToBut.isEnabled = false
                    }
                }
            }
        }
        if revealController.frontViewPosition == FrontViewPosition.right {
            self.tableView.isUserInteractionEnabled = true
        } else if revealController.frontViewPosition == FrontViewPosition.left {
            self.tableView.isUserInteractionEnabled = false
        }

        super.revealController(revealController, willMoveTo: position)
    }
    //------------
    @objc func handleLongPress(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let tappoint = sender.location(in: tableView)	        
            if let indexPath = tableView.indexPathForRow(at: tappoint) {
                indexPathSelect = indexPath
                editTapped(0)
            }
        }
    }
    //-------------
     @objc func doubleTapped(sender: UITapGestureRecognizer) {
        let tappoint = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: tappoint) {
            indexPathSelect = indexPath
            choiceTapped(0)
       }
    }
   //----------------
   public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let unit = fetchedResultsController.object(at: indexPath) as! Typecatalog
        let cell = UITableViewCell()
        cell.accessoryType = UITableViewCell.AccessoryType.detailDisclosureButton//disclosureIndicator
  
        fillCell(cell: cell, unit: unit)
        if arrayChoiceUnitsContainUnit(lastUnit: unit) {
            cell.backgroundColor = UIColor.backGray
        }

        return cell
    }
   //---------
    public func compareElementcatalog(unit1: Typecatalog, unit2: Typecatalog) -> Bool {
        return false
    }
   //-----
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    //-------------
    override public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.indexPathSelect = indexPath
        self.editTapped(self)

    }
 /*   override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unitsCatalogToUnit" {
            let controller = segue.destination as! UnitsAddAndEdit
            controller.unit = sender as? UnitCD
        }
    }
*/
    //-------------
    public func fillCell(cell: UITableViewCell, unit: Typecatalog) {
        /*        if unit.favourite {
         cell.textLabel?.textColor = .magenta
         }
         cell.textLabel?.text = unit.fullname
         */
    }
    //---------
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    //--------------
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert :
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
                self.indexPathSelect = indexPath
         //       tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            }
        case .update:
            if let indexPath = indexPath {
                let unit = fetchedResultsController.object(at: indexPath) as! Typecatalog
                if let cell = tableView.cellForRow(at: indexPath) {
                       fillCell(cell: cell, unit: unit)
                       self.indexPathSelect = indexPath
          //             tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
                }
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
        @unknown default:
            break
        }
    }
    //----------
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        let indexPath1 = self.indexPathSelect
        updateSearchResults(for: self.searchController)
        self.indexPathSelect = indexPath1
    }
    
    //-----------
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPathSelect = indexPath
    }
    
    //------------
    public func isFavourite(unit: Typecatalog) -> Bool {
        return false
    }
    //-----------
    func deleteunit(forRowAtIndexPath indexPath: IndexPath)  {
        let alert = UIAlertController(title: "Удаление элемента справочника", message: "Удалить?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler:{  (UIAlertAction) -> Void in
            let managedObject = self.fetchedResultsController.object(at: indexPath) as! NSManagedObject
            CoreDataManager.instance.managedObjectContext.delete(managedObject)
            CoreDataManager.instance.saveContext()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
   //-------
    override public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actionArray: [UIContextualAction] = []
        self.indexPathSelect = indexPath
        let deleteAction = self.contextualToggleAlltAction(forRowAtIndexPath: indexPath, title: "Удалить", image: UIImage(named: "icons8-удалить-22")!, сolor: UIColor.white, backgroundColor: UIColor.red, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.deleteunit(forRowAtIndexPath: indexPath)
            success(true)
        })
        actionArray.append(deleteAction)
        let editAction = self.contextualToggleAlltAction(forRowAtIndexPath: indexPath, title: "Изменить", image: UIImage(named: "icon edit pencil")!, сolor: UIColor.white, backgroundColor: UIColor.darkGray, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.indexPathSelect = indexPath
            self.editTapped(0)
            success(true)
        })
        actionArray.append(editAction)
/*
        let addAction = self.contextualToggleAlltAction(forRowAtIndexPath: indexPath, title: "Добавить", image: UIImage(named: "icons8-добавить-23")!, сolor: UIColor.white, backgroundColor: UIColor.brown, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.indexPathSelect = indexPath
            self.addTapped(0)
            success(true)
        })
*/
        let unit = fetchedResultsController.object(at: indexPathSelect!) as? Typecatalog
        var titleFavourite: String = "В избранное"
        var imageFavourite = UIImage(named:"icons8-сердце-30")
        if ( isFavourite(unit: unit!)) {
            titleFavourite = "Из избранного"
            imageFavourite = UIImage(named: "icons8-червы-30")
        }

        let favouriteAction = self.contextualToggleAlltAction(forRowAtIndexPath: indexPath, title: titleFavourite, image: imageFavourite!, сolor: UIColor.white, backgroundColor: UIColor.magenta, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.indexPathSelect = indexPath
            self.changeFavourite(unit: unit)
            success(true)
        })
        
        actionArray.append(favouriteAction)

        let swipeActionConfig = UISwipeActionsConfiguration(actions: actionArray)
        swipeActionConfig.performsFirstActionWithFullSwipe = true
        return swipeActionConfig
    }
    //------------
    public func changeFavourite(unit: Typecatalog!) {                              
      //      unit.favourite = !unit.favourite
      //      CoreDataManager.instance.saveContext()
    }
    //----------------
    override public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if self.didSelect != nil {
            self.indexPathSelect = indexPath
            var title = "В выбанные"
            var backgroundColorRightAction = UIColor.blue
            if let unit = fetchedResultsController.object(at: indexPath) as? Typecatalog {
                if arrayChoiceUnitsContainUnit(lastUnit: unit) {
                   title = "Из выбранных"
                   backgroundColorRightAction = UIColor.red                }
            }
            
            let choiceAction = self.contextualToggleAlltAction(forRowAtIndexPath: indexPath, title: title, image: UIImage(named: "icons8-единый-выбор-filled-22")!, сolor: UIColor.white, backgroundColor: backgroundColorRightAction, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                self.indexPathSelect = indexPath
                self.choiceTapped(0)
                success(true)
            })

            let swipeActionConfig = UISwipeActionsConfiguration(actions: [choiceAction])
            swipeActionConfig.performsFirstActionWithFullSwipe = true
            return swipeActionConfig
        } else {
          return nil
        }
    }
    //-----------------------
    func contextualToggleAlltAction(forRowAtIndexPath indexPath: IndexPath, title: String, image: UIImage, сolor: UIColor, backgroundColor: UIColor,  handler: @escaping UIKit.UIContextualAction.Handler) -> UIContextualAction {
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
    

    //-----------
    func imageWithImage(image: UIImage, scaledToSize newSize:CGSize)->UIImage{
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysTemplate)
    }
   
    
    //----------
    public override func viewDidAppear(_ animated: Bool) {
  //   if self.didSelect != nil {
        super.viewDidAppear(animated)
        if indexPathSelect != nil {
            tableView.selectRow(at: indexPathSelect!, animated: true, scrollPosition: .top)
        }
        isEnabledGotoButton(tableView as UIScrollView)
    //   }
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
        button
            .rightAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        
        button.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.centerYAnchor, constant: 20).isActive = true
        
        //      } else {
        //        button.rightAnchor.constraint(equalTo: productTable.layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
        //        button.bottomAnchor.constraint(equalTo: productTable.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        //  }
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
    }
    
    //----------------
    func cancelButtononView() {
        //create a button or any UIView and add to subview
         cancelBbutton = UIButton.init(type: .custom)
        //   button.setTitle("+", for: .normal)
        //   button.backgroundColor = .blue
        //   button.tintColor = .white
        cancelBbutton!.setBackgroundImage(UIImage(named: "icon8-cancel blue-75"), for: .normal)
        //   button.imageView?.image = UIImage(named: "icons8-добавить-23")
        cancelBbutton!.frame.size = CGSize(width: 100, height: 100)
        //  button.layer.cornerRadius = 0.5 * button.bounds.size.width
        
        //   button.layer.masksToBounds = true
        //    button.layer.borderWidth = 1
        //    button.layer.borderColor = UIColor.blue.cgColor
        self.view.addSubview(cancelBbutton!)
        
        //set constrains
        cancelBbutton!.translatesAutoresizingMaskIntoConstraints = false
        cancelBbutton!
            .rightAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.leftAnchor, constant: 100).isActive = true
        
        cancelBbutton!.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.centerYAnchor, constant: 20).isActive = true
        
        //      } else {
        //        button.rightAnchor.constraint(equalTo: productTable.layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
        //        button.bottomAnchor.constraint(equalTo: productTable.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        //  }
        cancelBbutton!.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
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
}
