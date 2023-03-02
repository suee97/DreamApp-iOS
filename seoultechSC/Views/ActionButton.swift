import UIKit

class ActionButton: UIButton {
    
    // 높이 기본값 : 50
    // 버튼 색상 기본값 : primaryPurple
    // 폰트 기본값 : Pretendard-Bold, 16
    init(title: String, backgroundColor: UIColor = .primaryPurple) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.layer.cornerRadius = 5
        self.backgroundColor = backgroundColor
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
