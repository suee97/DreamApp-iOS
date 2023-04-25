import Foundation
import UIKit
import SnapKit

class FoodTruckCell: UICollectionViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textColor = .primaryPurple
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 15)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryPurple
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func configureUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(nameLabel)
        contentView.addSubview(divider)
        contentView.addSubview(descLabel)
        
        nameLabel.snp.makeConstraints({ m in
            m.top.equalTo(contentView)
            m.left.equalTo(contentView.snp.left).inset(16)
        })
        divider.snp.makeConstraints({ m in
            m.left.right.equalTo(contentView).inset(10)
            m.height.equalTo(1)
            m.bottom.equalTo(contentView)
        })
        descLabel.snp.makeConstraints({ m in
            m.top.equalTo(nameLabel.snp.bottom).offset(6)
            m.left.equalTo(contentView).inset(16)
        })
    }
}
