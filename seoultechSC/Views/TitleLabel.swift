import UIKit

class TitleLabel: UILabel {
    
    init(_ title: String) {
        super.init(frame: .zero)
        self.text = title
        self.font = UIFont(name: "Pretendard-Bold", size: 16)
        self.textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
