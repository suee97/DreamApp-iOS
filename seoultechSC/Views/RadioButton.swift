import UIKit

class RadioButton: UIButton {
    
    private let symbolConfig = UIImage.SymbolConfiguration(scale: .medium)
    var checked: Bool = false
    
    init() {
        super.init(frame: .zero)
        self.setImage(getNormalRadioButtonImage(), for: .normal)
        self.tintColor = .primaryPurple
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeState() {
        if checked {
            self.setImage(getNormalRadioButtonImage(), for: .normal)
        } else {
            self.setImage(getCheckedRadioButtonImage(), for: .normal)
        }
        checked = !checked
    }
    
    private func getNormalRadioButtonImage() -> UIImage? {
        let image = UIImage(systemName: "circle", withConfiguration: symbolConfig)
        return image
    }
    
    private func getCheckedRadioButtonImage() -> UIImage? {
        let image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: symbolConfig)
        return image
    }

}
