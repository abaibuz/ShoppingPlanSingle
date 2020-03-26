//
//  extDocPurchaseAdd.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 5/14/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//

import Foundation

extension docPurchaseAdd : UIPopoverPresentationControllerDelegate {
    //--------
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //-----------
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    //----------
    func editPriceSumPopover(indexPath: IndexPath) {
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "editPricePopover") else {
            return
        }
        if let tline = self.fetchedResultsController.object(at: indexPath) as? TLine {
        
            popVC.modalPresentationStyle = .popover
            let popOverVC = popVC.popoverPresentationController
            popOverVC?.delegate = self
            popOverVC?.sourceView = quantitylabeloutlet
            
            let xx: Double = Double(self.menuButtonOutlet.bounds.maxX)
            let yy: Double = Double(self.menuButtonOutlet.bounds.maxY)
            popOverVC?.sourceRect = CGRect(x: xx, y: yy, width: 0, height: 0)
            popVC.preferredContentSize = CGSize(width: 300, height: 140)
            let popOverVCClass = popVC as! editSumViewController
            popOverVCClass.tline = tline
            popOverVCClass.changeField = { [unowned self] bool in
                if bool {
                    //popVC.dismiss(animated: true)
            //        self.productTable.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                    self.repainTableCell(indexPath: indexPath)
                    self.calcTotalSum()
               }
            }
      
            self.present(popVC, animated: true)
        }
    }
    
    
    //-----------------
    func reloadData() {
        self.playFile(forResource: "Sound_windows restore", withExtension: "wav")
        CoreDataManager.instance.saveContext()
        self.fetchData()
        self.productTable.reloadData()
    }
    
    //-----------
}
