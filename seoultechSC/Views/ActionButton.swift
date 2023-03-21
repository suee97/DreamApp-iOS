import UIKit

class ActionButton: UIButton {
    
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // 높이 기본값 : 50
    // 버튼 색상 기본값 : primaryPurple
    // 폰트 기본값 : Pretendard-Bold, 16
    init(title: String, backgroundColor: UIColor = .primaryPurple, height: CGFloat = 50) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
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
    
    func setActive(_ isActive: Bool) {
        if isActive {
            self.backgroundColor = .primaryPurple
            self.isEnabled = true
        } else {
            self.backgroundColor = .secondaryPurple
            self.isEnabled = false
        }
    }
    
    func setLoading(_ isLoading: Bool) {
        let w = self.bounds.size.width
        let h = self.bounds.size.height
        
        if isLoading {
            self.setActive(false)
            self.setTitleColor(.clear, for: .normal)
            self.indicator.center = CGPointMake(w / 2, h / 2)
            self.indicator.color = .lightGrey
            self.addSubview(indicator)
            self.indicator.startAnimating()
        } else {
            self.setActive(true)
            self.setTitleColor(.white, for: .normal)
            self.indicator.stopAnimating()
            
        }
    }
}
