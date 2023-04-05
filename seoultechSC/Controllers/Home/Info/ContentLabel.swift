import UIKit

class DescLabel: UILabel {

    init(isTitle: Bool) {
        super.init(frame: .zero)
        if isTitle {
            self.font = UIFont(name: "Pretendard-Bold", size: 16)
        } else {
            self.font = UIFont(name: "Pretendard-Regular", size: 12)
        }
        self.numberOfLines = 0
        self.sizeToFit()
        self.textColor = .black
        self.textAlignment = .left
        self.lineBreakMode = .byCharWrapping
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
