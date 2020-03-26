//
//  Units.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 06.05.2018.
//  Copyright © 2018 Olexandr Baybuz. All rights reserved.
//
import UIKit
import CoreData
import Foundation

class Units : UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
   
    typealias Select = (UnitCD?) -> ()
    var didSelect: Select?
    
    func updateSearchResults(for searchController: UISearchController) {
        if self.revealViewController().frontViewPosition == FrontViewPosition.right {
            self.revealViewController().revealToggle(animated: true)
        } else {
            if let searchText = searchController.searchBar.text {
                    filterContent(for: searchText)
                    tableView.reloadData()
            }
        }
    }
    
    
    @IBOutlet weak var OpenSideOut: UIBarButtonItem!
    
    @IBAction func AddUnit(_ sender: Any) {
        performSegue(withIdentifier: "unitsToUnit", sender: nil)
    }
       
    
//    var fetchedResultsController:  NSFetchedResultsController<NSFetchRequestResult>!
    var fetchedResultsController  = CoreDataManager.instance.fetchedResultsController(entityName: "UnitCD", keyForSort: "fullname", predicate: nil)
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Поиск..."
        tableView.tableHeaderView = searchController.searchBar
        
        if self.didSelect != nil {
        } else {
            OpenSideOut.target = self.revealViewController()
            OpenSideOut.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
  //          tableView.tableHeaderView?.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
  //          tableView.tableHeaderView?.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        fetchedResultsController.delegate = self as NSFetchedResultsControllerDelegate
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
     }
    
    func filterContent(for searchText: String){
      
       if searchText != "" {
          let predicate = NSPredicate(format: "%K CONTAINS[cd] %@", "fullname", searchText)
          fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "UnitCD", keyForSort: "fullname", predicate: predicate)
          fetchedResultsController.delegate = self as NSFetchedResultsControllerDelegate
       } else {
            fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "UnitCD", keyForSort: "fullname", predicate: nil)
            fetchedResultsController.delegate = self as NSFetchedResultsControllerDelegate
       }
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let unit = /*(searchController.isActive) ? seachUnitCD[indexPath.row] :*/ fetchedResultsController.object(at: indexPath) as! UnitCD
        let cell = UITableViewCell()
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


    /*    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
        
    }
*/
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let unit = fetchedResultsController.object(at: indexPath) as? UnitCD
        if let dSelect = self.didSelect {
            dSelect(unit)
            dismiss(animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "unitsToUnit", sender: unit)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unitsToUnit" {
            let controller = segue.destination as! unitsAdd
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
            }
        case .update:
            if let indexPath = indexPath {
                let unit = fetchedResultsController.object(at: indexPath) as! UnitCD
                let cell = tableView.cellForRow(at: indexPath)
                cell!.textLabel?.text = unit.fullname
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
                }
        }
     }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedObject = fetchedResultsController.object(at: indexPath) as! NSManagedObject
            CoreDataManager.instance.managedObjectContext.delete(managedObject)
            CoreDataManager.instance.saveContext()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
/*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            let position = touch.location(in: view)
            print(position)
        }
    }
 */
}

