//
//  ViewController.swift
//  ShoppingPlanSingle
//
//  Created by Olexandr Baybuz on 27.11.2017.
//  Copyright © 2017 Olexandr Baybuz. All rights reserved.
//

import UIKit

class ShoppingPlanViewController: UIViewController, UITableViewDataSource, DataControllerdelegate, UITableViewDelegate{
 
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "EditSegue", sender: nil)
    }
    

    @IBOutlet weak var OpenSideOut: UIBarButtonItem!
    
    
    var documents = [DocumentPurchase]()
        
    let dataController = DataController()
    
 //   @IBOutlet var namePurchase: [UILabel]!
    
    @IBOutlet weak var docTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataController.delegate = self
//        dataController.coreDataManager = coreDataManager
        dataController.getDocuments()
        // Do any additional setup after loading the view, typically from a nib.
        OpenSideOut.target = self.revealViewController()
        OpenSideOut.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func DataSourceChanged(dataSource: [DocumentPurchase]?, error: Error?) {
        if let documents = dataSource {
            self.documents = documents.sorted(by: {$0.DateDoc>$1.DateDoc})
            DispatchQueue.main.async {
                self.docTable.reloadData()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let composeVC = segue.destination as? AddAndEditDokViewController {
            if segue.identifier == "EditSegue" {
                composeVC.dataController = dataController
                if let index = sender as? Int {
                    composeVC.document = documents[index]
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let DocCount = documents.count
        return DocCount
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.revealViewController().frontViewPosition == FrontViewPosition.right {
            self.revealViewController().revealToggle(animated: true)
        }
        else {
            performSegue(withIdentifier: "EditSegue", sender: indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseCell")! as! TableViewCellForDocPurchase
        let doc = documents[indexPath.row]
        cell.nameLabel.text = doc.NameDoc
        cell.dateLabel.text = doc.returnDateDocString(dateIn: nil)
        cell.commentLabel.text = doc.CommentDoc
        let tableDoc = doc.TableDoc
        if (tableDoc?.tableLines.count)! > 0 {
            let countChecked = tableDoc!.countChecked()
            let countUnchecked = tableDoc!.countUnchecked()
            let totalRow = countChecked + countUnchecked
            cell.quantityLabel.text = "\(countChecked)/\(totalRow)"
            let sumChecked = tableDoc!.sumChecked()
            let sumTotal = sumChecked + tableDoc!.sumUnchecked()
            cell.sumLabel.text = "\(sumChecked)/\(sumTotal)"
        } else {
            cell.quantityLabel.text = "0/0"
            cell.sumLabel.text = "0.00/0.00"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataController.modify(doc: documents[indexPath.row], task: .delete)
        }
    }
    
    /*
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15.0
    }
 */
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

}


