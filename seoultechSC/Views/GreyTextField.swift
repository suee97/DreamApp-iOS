import UIKit

class GreyTextField: UITextField {
    
    private let padding = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    
    // default height : 40
    init() {
        super.init(frame: .zero)
        self.layer.cornerRadius = 10
        self.backgroundColor = .lightGrey
        self.tintColor = .text_caption
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.font = UIFont(name: "Pretendard-Regular", size: 16)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
