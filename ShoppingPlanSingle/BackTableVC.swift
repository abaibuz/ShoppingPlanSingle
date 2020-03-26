//
//  BackTableVC.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 04.05.2018.
//  Copyright © 2018 Olexandr Baybuz. All rights reserved.
//

import UIKit

class BackTableVC: UITableViewController {
    
    var tableArray = [[String]]()
    var previousSelect: IndexPath?
    
    override func viewDidLoad() {
        tableArray = [ ["Documents","Документы"], ["MyPurchases","Мои покупки"], ["Catalogs","Справочники"], ["Products","Товары"],
                       ["Units","Единицы измерения"],["Categories", "Категории"],["WishList", "Список желаемого"],
                       ["Settings", "Настройки"], ["About", "О программе"],["License", "Лиц.соглашение"],["Support", "Тех.поддержка"],["Version", "Версия"]]
        previousSelect = IndexPath(row: 1, section: 0)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return tableArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableArray[indexPath.row][0])
        cell?.textLabel?.text = tableArray[indexPath.row][1]
        if tableArray[indexPath.row][0] != "Documents" && tableArray[indexPath.row][0] != "Catalogs" &&
            tableArray[indexPath.row][0] != "Settings" {
            if self.previousSelect == indexPath {
                cell?.isUserInteractionEnabled = false
     //           cell?.backgroundColor = .selectedTableCell
                let textColor = cell?.textLabel?.textColor
                cell?.textLabel?.textColor = textColor?.withAlphaComponent(0.3)
                //cell?.textLabel?.isOpaque = false
            } else {
                cell?.isUserInteractionEnabled = true
       //         cell?.backgroundColor = UITableViewCell.appearance().backgroundColor
                let textColor = cell?.textLabel?.textColor
                cell?.textLabel?.textColor = textColor?.withAlphaComponent(1)
                //cell?.textLabel?.isOpaque = true
           }
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableArray[indexPath.row][0] != "Documents" && tableArray[indexPath.row][0] != "Catalogs" &&
            tableArray[indexPath.row][0] != "Settings" {
            previousSelect = indexPath
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //    print("\(sender)")
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        if indexPath?.row == 8 || indexPath?.row == 9 || indexPath?.row == 10 || indexPath?.row == 11 {
            let controller = segue.destination.children[0] as! TextFileViewController
            controller.indexFile = indexPath!.row - 8
        }
    }
}
