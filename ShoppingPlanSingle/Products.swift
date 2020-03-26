//
//  Products.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 06.05.2018.
//  Copyright © 2018 Olexandr Baybuz. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class Products : UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }

    }
    
    func filterContent(for searchText: String){
        
        if searchText != "" {
            let predicate = NSPredicate(format: "%K CONTAINS[cd] %@", "name", searchText)
            fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "ProductsCD", keyForSort: "name", predicate: predicate)
            fetchedResultsController.delegate = self as NSFetchedResultsControllerDelegate
        } else {
            fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "ProductsCD", keyForSort: "name", predicate: nil)
            fetchedResultsController.delegate = self as NSFetchedResultsControllerDelegate
        }
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        
    }
   
    @IBAction func AddProduct(_ sender: Any) {
        performSegue(withIdentifier: "productsToProduct", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productsToProduct" {
            let controller = segue.destination as! ProductsUnitsAddAndEdit
            controller.product = sender as? ProductsCD
        }
    }
    
    @IBOutlet weak var OpenSideOut: UIBarButtonItem!
  
    var fetchedResultsController  = CoreDataManager.instance.fetchedResultsController(entityName: "ProductsCD", keyForSort: "name", predicate: nil)
    
    var searchController: UISearchController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        OpenSideOut.target = self.revealViewController()
        OpenSideOut.action = #selector(SWRevealViewController.revealToggle(_:))
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Поиск..."
//        searchController.searchBar.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        searchController.searchBar.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        tableView.tableHeaderView = searchController.searchBar
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
 //       tableView.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
 //       tableView.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())

        filterContent(for: "")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = fetchedResultsController.object(at: indexPath) as! ProductsCD
        let cell = UITableViewCell()
        cell.textLabel?.text = product.name
        if let imageProductData = product.image {
            cell.imageView?.image = UIImage(data: imageProductData as Data)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = fetchedResultsController.object(at: indexPath) as? ProductsCD
        performSegue(withIdentifier: "productsToProduct", sender: product)
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
                let product = fetchedResultsController.object(at: indexPath) as! ProductsCD
                let cell = tableView.cellForRow(at: indexPath)
                cell!.textLabel?.text = product.name
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
    
/*    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedObject = fetchedResultsController.object(at: indexPath) as! NSManagedObject
            CoreDataManager.instance.managedObjectContext.delete(managedObject)
            CoreDataManager.instance.saveContext()
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.revealViewController().frontViewPosition == FrontViewPosition.right {
            self.revealViewController().revealToggle(animated: true)
            return false
        } else {
            return true
        }
        
    }
 */
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
/*    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
*/
}
