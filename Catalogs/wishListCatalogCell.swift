//
//  wishListCatalogCell.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 5/22/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//

import UIKit
import AVFoundation

class wishListCatalogCell: UITableViewCell, AVAudioPlayerDelegate {

    var audioPlayer: AVAudioPlayer?
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var quntityText: UITextField!{
        didSet {
            quntityText.addDoneCancelToolbar(isCancel: false, onDone: (target: self, action: #selector(onDoneKeyboardTappedQuantity)))
            quntityText.addTarget(self, action: #selector(editingChangedQuatity), for: .editingChanged)
            quntityText.clearsOnBeginEditing = true
        }
    }
    @IBOutlet weak var imageProduct: UIImageView!
    //-----------------------------
    @objc func onDoneKeyboardTappedQuantity() {
        validateNumberTextField(sender: self.quntityText, fractionDigits: 3)
    }
    
    //------------------------
    @objc func editingChangedQuatity(_ sender: Any) {
        deletePoint(textField: self.quntityText)
    }
    
    //----------------------------
    func deletePoint(textField: UITextField) {
        let decimalSeparetor = NumberFormatter().decimalSeparator.first

        var str = textField.text
        if let str1 = str {
            if str1.last == decimalSeparetor {
                let substring = String(str1.dropLast())
                if substring.contains(decimalSeparetor!) {
                    self.playFile(forResource: "Sound_windows error", withExtension: "wav")
                    str = substring
                }
            }
        }
        textField.text = str
    }

    
    //----------------
    func playFile(forResource: String, withExtension: String) {
        DispatchQueue.main.async {
            guard let url = Bundle.main.url(forResource: forResource, withExtension: withExtension) else { return }
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                try AVAudioSession.sharedInstance().setActive(true)
                self.audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                guard let player = self.audioPlayer else { return }
                
                player.play()
            } catch let error{
                print(error.localizedDescription)
            }
        }
    }

   //------------
    private func validateNumberTextField(sender: UITextField, fractionDigits: Int) {
        let num = convertingData().returtSringToFloat(stringIn: sender.text, fractionDigits: fractionDigits)
        sender.text = convertingData().returnFloatToString(floatIn: num, fractionDigits: fractionDigits)
        sender.resignFirstResponder()
    }
    //----------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //--------------------------
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
