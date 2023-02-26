import UIKit

class ActionButton: UIButton {
    
    // width, height 기본값 : 320, 50
    // 버튼 색상 기본값 : primaryPurple
    init(title: String, width: CGFloat = 320, height: CGFloat = 50, backgroundColor: UIColor = .primaryPurple) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.layer.cornerRadius = 5
        self.backgroundColor = backgroundColor
        self.setTitleColor(.white, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
