//
//  MyExtantions.swift
//  ShoppingPlanSingle
//
//  Created by Baibuz Oleksandr on 2/25/19.
//  Copyright © 2019 Olexandr Baybuz. All rights reserved.
//

import UIKit
import AVFoundation

extension UIColor {
    static let candyGreen = UIColor(red: 67.0/255.0, green: 205.0/255.0, blue: 135.0/255.0, alpha: 1.0)
    static let backGreen = UIColor(red: 187.0/255.0, green: 229.0/255.0, blue: 157.0/255.0, alpha: 1.0)
    static let backGray = UIColor(red: 249.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0)
    static let backNavigationBar = UIColor(red: 217.0/255.0, green: 249.0/255.0, blue: 198.0/255.0, alpha: 1.0)
    static let backScrollView = UIColor(red: 169.0/255.0, green: 243.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    static let backNavigationBarProduct = UIColor(red: 249.0/255.0, green: 245.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    static let backScrollViewProduct = UIColor(red: 231.0/255.0, green: 216.0/255.0, blue: 138.0/255.0, alpha: 1.0)
    static let barTinyColor = UIColor(red: 209.0/255.0, green: 212.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    static let selectedTableCell = UIColor(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1.0)
    static let backNavigationBarDocPurchase = UIColor(red: 220.0/255.0, green: 225.0/255.0, blue: 76.0/255.0, alpha: 1.0)
    static let backTableDocPurchase = UIColor(red: 187.0/255.0, green: 225.0/255.0, blue: 76.0/255.0, alpha: 1.0)
    static let systemBlue = UIColor(red: 0, green: 122.0/255.0, blue: 1, alpha: 1)
    static let backNavigationBarWishList = UIColor(red: 247.0/255.0, green: 212.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    static let backScrollViewWishList = UIColor(red: 233.0/255.0, green: 150.0/255.0, blue: 160.0/255.0, alpha: 1.0)

}

//-----------------
extension Date {
    var convertDateToString : String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.short
        dateformatter.timeStyle = .none
        dateformatter.locale = Locale(identifier: "uk_UA")
        let stringDate = dateformatter.string(from: self)
        return stringDate
    }
  
    var convertDateAndTimeToString : String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.short
        dateformatter.timeStyle = DateFormatter.Style.short
        dateformatter.locale = Locale(identifier: "uk_UA")
        let stringDate = dateformatter.string(from: self)
        return stringDate
    }

    func convertToString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
//-------------------
extension UIImage {
    
    func fixOrientation() -> UIImage? {
        
        if (imageOrientation == .up) { return self }
        
        var transform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0.0)
            transform = transform.rotated(by: .pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0.0, y: size.height)
            transform = transform.rotated(by: -.pi / 2.0)
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        default:
            break
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
        default:
            break
        }
        
        guard let cgImg = cgImage else { return nil }
        
        if let context = CGContext(data: nil,
                                   width: Int(size.width), height: Int(size.height),
                                   bitsPerComponent: cgImg.bitsPerComponent,
                                   bytesPerRow: 0, space: cgImg.colorSpace!,
                                   bitmapInfo: cgImg.bitmapInfo.rawValue) {
            
            context.concatenate(transform)
            
            if imageOrientation == .left || imageOrientation == .leftMirrored ||
                imageOrientation == .right || imageOrientation == .rightMirrored {
                context.draw(cgImg, in: CGRect(x: 0.0, y: 0.0, width: size.height, height: size.width))
            } else {
                context.draw(cgImg, in: CGRect(x: 0.0 , y: 0.0, width: size.width, height: size.height))
            }
            
            if let contextImage = context.makeImage() {
                return UIImage(cgImage: contextImage)
            }
            
        }
        
        return nil
    }
    
    func resizeImage(to maxSize: CGFloat) -> UIImage? {
        if (size.width <= maxSize) && (size.width <= maxSize) {
           return self
        }
        let aspectRatio: CGFloat = min(maxSize / size.width, maxSize / size.height)
        let newSize = CGSize(width: size.width * aspectRatio, height: size.height * aspectRatio)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { context in
            draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        }
    }

    func resizeWith(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }

    
}


//-------------
extension UISearchBar {
    
    // Cancel button to change the title.
    public func setTitleCancelButtonSearchBar(title: String) {
         //   self.setValue(title, forKey: "_cancelButtonText")
    }
    
}

//----------------------------
public struct convertingData {
    
    public func returnFloatToString(floatIn:Float?, fractionDigits: Int?) -> String {
        if let floatNotNil = floatIn {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            if let fD = fractionDigits {
                numberFormatter.minimumFractionDigits = fD
                numberFormatter.maximumFractionDigits = fD
            } else {
                numberFormatter.minimumFractionDigits = 2
                numberFormatter.maximumFractionDigits = 2
            }
            let nsNumber = NSNumber(value: floatNotNil)
            if let stringNumber = numberFormatter.string(from: nsNumber) {
                return stringNumber
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    
    public func returtSringToFloat(stringIn: String?, fractionDigits: Int?) -> Float {
        let numberFormatter = NumberFormatter()
        let decimalSeparetor = numberFormatter.decimalSeparator
        if (stringIn?.isEmpty)!  || (stringIn == decimalSeparetor) {
            return 0.00
        }
        if let stringNotNil  = stringIn {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            if let fD = fractionDigits {
                numberFormatter.minimumFractionDigits = fD
                numberFormatter.maximumFractionDigits = fD
            } else {
                numberFormatter.minimumFractionDigits = 2
                numberFormatter.maximumFractionDigits = 2
            }
            let number = numberFormatter.number(from: stringNotNil)
            return (number?.floatValue)!
        } else {
            return 0.00
        }
    }
}

//---------------- Add Done & Cancel Button to keyboard UITextField
extension UITextField {
    func addDoneCancelToolbar(isCancel: Bool = false, onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.barTintColor = .barTinyColor
        if isCancel {
            toolbar.items = [
                UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
            ]
        } else {
            toolbar.items = [
                
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
            ]

        }
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
    
}
//------------
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
    
    func fixAction(title: String, image:UIImage, сolor: UIColor, rowHeight: CGFloat) -> UIImage! {
        // make sure the image is a mask that we can color with the passed color
        let mask = image.withRenderingMode(.alwaysTemplate)
        // compute the anticipated width of that non empty string
        let titleAction = NSString(string: title)
        let stockSize = titleAction.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white])
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
        
        let attributes = [NSAttributedString.Key.foregroundColor: сolor, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 12), NSAttributedString.Key.paragraphStyle: paragraphStyle]
        //      title.size(withAttributes: [NSAttributedStringKey : Any]?)
        let textSize = title.size(withAttributes: attributes as [NSAttributedString.Key : Any] )
        // implementation of `half` extension left up to the student
        let textPoint = CGPoint(x: (width - textSize.width)/2, y: (height - (textSize.height * 3))/2 + (textSize.height * 2))
        title.draw(at: textPoint, withAttributes: attributes as [NSAttributedString.Key : Any] )
        let maskHeight = textSize.height * 2
        let maskRect = CGRect(x: (width - maskHeight)/2, y: textPoint.y - maskHeight, width: maskHeight, height: maskHeight)
        mask.draw(in: maskRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}
//
enum WishListActs {
    case add
    case remove
}

enum ImageChangeAct {
    case edit
    case clear
    case none
}


public extension Bundle {

    var shortVersion: String {
        if let result = infoDictionary?["CFBundleShortVersionString"] as? String {
            return result
        } else {
         //   assert(false)
            return ""
        }
    }

    var buildVersion: String {
        if let result = infoDictionary?["CFBundleVersion"] as? String {
            return result
        } else {
      //      assert(false)
            return ""
        }
    }

    var displayName: String? {
        if let result = infoDictionary?["CFBundleDisplayName"] as? String {
            return result
        } else {
            return ""
        }
    }

    
    var fullVersion: String {
        return "\(shortVersion)(\(buildVersion))"
    }
}

extension String
{
    mutating func replaceSelf(target: String, withString newString:String)
    {
        let replacedString = self.replacingOccurrences(of: target, with: newString, options: NSString.CompareOptions.literal, range: nil)
        self = replacedString
    }
}
