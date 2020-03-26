//
//  TextFileViewController.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 8/26/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//

import UIKit

class TextFileViewController: UIViewController {

    @IBOutlet weak var sideOutlet: UIBarButtonItem!
    
    @IBOutlet weak var textView: UITextView!
    var indexFile: Int = 0
    var fileArray:  [[String]] = [["Описание программы","manual"],["Лицензионное соглашение","lic"],["Техническая поддержка","support"],["Версия","version"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        setOpenSideout()
        loadTextFile()
        
    }
    
    // ------------
    private func setOpenSideout() {
        setupMenuGestureRecognizer()
        sideOutlet.target = self.revealViewController()
        sideOutlet.action = #selector(SWRevealViewController.revealToggle(_:))
    }
    //----------------
    private func loadTextFile() {
        self.title = fileArray[indexFile][0]
        if let path = Bundle.main.url(forResource: fileArray[indexFile][1], withExtension: "rtf") {
            do {
                var attributedStringWithRtf: NSAttributedString = try NSAttributedString(url: path, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                if fileArray[indexFile][1] == "version" {
                    
                  let fullVersionString = Bundle.main.fullVersion
    //            let displayName = Bundle.main.displayName
                  var textFile = attributedStringWithRtf.string
                  textFile.replaceSelf(target: "{version}", withString: fullVersionString)
    //            textFile.replaceSelf(target: "{displayName}", withString: displayName!)
                  attributedStringWithRtf = NSAttributedString(string: textFile)
                }
                textView.attributedText = attributedStringWithRtf
                textView.isEditable = false
                
            } catch let error {
                print("Got an error \(error)")
            }
        }
        
    }
    

}
