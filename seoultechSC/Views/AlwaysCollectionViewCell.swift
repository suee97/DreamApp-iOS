import UIKit

class AlwaysCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AlwaysCollectionViewCell"
    
    let itemImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let itemTitle : UILabel = {
        var itemTitle = UILabel()
        itemTitle.font = UIFont(name: "Pretendard-Regular", size: 12)
        itemTitle.textColor = .navy
        itemTitle.textAlignment = .center
        itemTitle.backgroundColor = .secondaryPurple
        itemTitle.clipsToBounds = true
        itemTitle.layer.cornerRadius = 10
        itemTitle.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return itemTitle
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
        setConstraint()
    }
    
    private func setUI() {
        self.addSubview(itemImageView)
        self.addSubview(itemTitle)
    }
    
    private func setConstraint() {
        
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            itemTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            itemTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            itemTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            itemTitle.heightAnchor.constraint(equalToConstant: 26),
            itemImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            itemImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10)
        ])
    }
    
}
