import Foundation
import UIKit

// Custom Colors
extension UIColor {
    static var primaryPurple: UIColor {
        return UIColor(red: 124/255, green: 135/255, blue: 242/255, alpha: 1)
    }
    static var secondaryPurple: UIColor {
        return UIColor(red: 190/255, green: 197/255, blue: 255/255, alpha: 1)
    }
    static var backgroundPurple: UIColor {
        return UIColor(red: 233/255, green: 239/255, blue: 255/255, alpha: 1)
    }
    static var navy: UIColor {
        return UIColor(red: 75/255, green: 82/255, blue: 136/255, alpha: 1)
    }
    static var lightGrey: UIColor {
        return UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)
    }
    static var text_caption: UIColor {
        return UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
    }
    static var modalBackground: UIColor {
        return UIColor.black.withAlphaComponent(0.3)
    }
}

// Configure Modal View
extension UIView {
    func configureModalView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3
    }
}

// Bold Some words
extension UILabel {
    func asFontBold(targetStringList: [String], font: UIFont?, color: UIColor?) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)

        targetStringList.forEach {
            let range = (fullText as NSString).range(of: $0)
            attributedString.addAttributes([.font: font as Any, .foregroundColor: color as Any], range: range)
        }
        attributedText = attributedString
    }
}

extension Bundle {
    var api_url: String {
        guard let file = self.path(forResource: "Keys", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["API_BASE_URL"] as? String else { fatalError("api base url 설정 안됨") }
        return key
    }
    
    var dev_api_url: String {
        guard let file = self.path(forResource: "Keys", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["DEV_API_BASE_URL"] as? String else { fatalError("dev api base url 설정 안됨") }
        return key
    }
    
    var maps_api_key: String {
        guard let file = self.path(forResource: "Keys", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["MAPS_API_KEY"] as? String else { fatalError("dev api base url 설정 안됨") }
        return key
    }
}

extension CALayer {
    func clickedBorder() {
        let border = CALayer()
        border.frame = CGRect.init(x: 0, y: frame.height - 5, width: frame.width, height: 5)
        border.backgroundColor = UIColor.primaryPurple.cgColor
        
        self.addSublayer(border)
    }
    
    func nonClickedBorder() {
        let border = CALayer()
        border.frame = CGRect.init(x: 0, y: frame.height - 3, width: frame.width, height: 3)
        border.backgroundColor = UIColor.secondaryPurple.cgColor
        
        let border2 = CALayer()
        border2.frame = CGRect.init(x: 0, y: frame.height - 5, width: frame.width, height: 5)
        border2.backgroundColor = UIColor.white.cgColor
        
        self.addSublayer(border2)
        self.addSublayer(border)
    }
}
