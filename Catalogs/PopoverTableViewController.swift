//
//  PopoverTableViewController.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 4/3/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//


import UIKit

class PopoverTableViewController: UITableViewController {
    
    var menuTitles: [String] = []
    var menuPictures: [String] = []
    var menuTitles2: [String] = []
    var menuPictures2: [String] = []
    var menuTitles1: [String] = []
    var menuPictures1: [String] = []
    var sizeSystemFont: CGFloat = 15.0
    var widthImage: CGFloat = 22.0
    var isUserEnable: [Bool]!
    
    var cellNum: Int = -1
    var choiceCellNum : ((Int) -> ())?
    var favorite: Bool = false
    
    public func setMenutitlesAndPictires(menuTitles1: [String], menuPictures1: [String], sizeSystemFont: CGFloat, widthImage: CGFloat, menuTitles2: [String]!, menuPictures2: [String]!)  {
        for title in menuTitles1 {
            self.menuTitles1.append(title)
        }
        
        for picture in menuPictures1 {
            self.menuPictures1.append(picture)
        }
        
        if let menuTitles = menuTitles2 {
            for title in menuTitles {
                self.menuTitles2.append(title)
            }
        }
        
        if let menuPictures = menuPictures2 {
            for picture in menuPictures {
                self.menuPictures2.append(picture)
            }
        }
        
        self.menuTitles = self.menuTitles1
        self.menuPictures = self.menuPictures1
        
        self.sizeSystemFont = sizeSystemFont
        self.widthImage = widthImage
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
        if favorite {
            self.menuTitles = self.menuTitles2
            self.menuPictures = self.menuPictures2
        } else {
            self.menuTitles = self.menuTitles1
            self.menuPictures = self.menuPictures1
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = menuTitles[indexPath.row]
        cell.textLabel?.textColor = .systemBlue
        cell.textLabel?.font = UIFont.systemFont(ofSize: self.sizeSystemFont)
        if !menuPictures[indexPath.row].isEmpty  {
          if let image = UIImage(named: menuPictures[indexPath.row])?.withRenderingMode(.alwaysTemplate) {
            let image2 = image.resizeWith(width: self.widthImage)
            cell.imageView?.image = image2
            cell.imageView?.tintColor = .systemBlue
          }
        }
        if let isUser = self.isUserEnable {
           cell.isUserInteractionEnabled = isUser[indexPath.row]
            if !isUser[indexPath.row] {
                cell.backgroundColor = .lightGray
            }
        }
        return cell
    }
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 240, height: tableView.contentSize.height)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cellNum = indexPath.row
        self.dismiss(animated: true)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        choiceCellNum?(self.cellNum)
    }
    
}



