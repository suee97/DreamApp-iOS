import UIKit
import SnapKit

class ContentsTableViewCell: UITableViewCell {

    let boothImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryPurple
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        return label
    }()
    
    let congestionLabel: UILabel = {
        let label = UILabel()
        label.text = "혼잡도"
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Bold", size: 12)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "운영시간"
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Bold", size: 12)
        return label
    }()
    
    let otLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "설명"
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Bold", size: 12)
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        return label
    }()
    
    var content: Contents? {
        didSet {
            boothImageView.image = content?.image
            titleLabel.text = content?.title
            descLabel.text = content?.desc
            otLabel.text = content?.time
            let congestionView: CongestionView = {
                let view = CongestionView(level: content!.congestion)
                return view
            }()
            contentView.addSubview(congestionView)
            congestionView.snp.makeConstraints({ m in
                m.left.equalTo(otLabel.snp.left)
                m.centerY.equalTo(congestionLabel)
            })
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
        
    private func configureUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        
        contentView.addSubview(boothImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(congestionLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(otLabel)
        
        boothImageView.snp.makeConstraints({ m in
            m.left.top.bottom.equalTo(contentView)
            m.width.equalTo(contentView).multipliedBy(0.5)
        })
        titleLabel.snp.makeConstraints({ m in
            m.left.equalTo(boothImageView.snp.right).offset(getRatWidth(13))
            m.top.equalTo(contentView).inset(getRatHeight(15))
        })
        congestionLabel.snp.makeConstraints({ m in
            m.left.equalTo(boothImageView.snp.right).offset(getRatWidth(13))
            m.top.equalTo(titleLabel.snp.bottom).offset(getRatHeight(9))
        })
        timeLabel.snp.makeConstraints({ m in
            m.left.equalTo(boothImageView.snp.right).offset(getRatWidth(13))
            m.top.equalTo(congestionLabel.snp.bottom).offset(getRatHeight(10))
        })
        infoLabel.snp.makeConstraints({ m in
            m.left.equalTo(boothImageView.snp.right).offset(getRatWidth(13))
            m.top.equalTo(timeLabel.snp.bottom).offset(getRatHeight(10))
        })
        descLabel.snp.makeConstraints({ m in
            m.width.equalTo(getRatWidth(140))
            m.left.equalTo(boothImageView.snp.right).offset(getRatWidth(13))
            m.top.equalTo(infoLabel.snp.bottom).offset(getRatHeight(5))
        })
        otLabel.snp.makeConstraints({ m in
            m.left.equalTo(timeLabel.snp.right).offset(getRatWidth(13))
            m.centerY.equalTo(timeLabel.snp.centerY)
        })
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

class CongestionView: UIView {
    // level 0~4
    init(level: Int) {
        super.init(frame: .zero)
        
        let left: UIView = {
            let view = UIView()
            view.backgroundColor = .lightGrey
            view.layer.cornerRadius = 4.5
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            return view
        }()
        
        let middle: UIView = {
            let view = UIView()
            view.backgroundColor = .lightGrey
            return view
        }()
        
        let right: UIView = {
            let view = UIView()
            view.backgroundColor = .lightGrey
            view.layer.cornerRadius = 4.5
            view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            return view
        }()
        
        self.addSubview(left)
        self.addSubview(middle)
        self.addSubview(right)

        left.snp.makeConstraints({ m in
            m.width.equalTo(getRatWidth(25.53))
            m.left.top.bottom.equalTo(self)
        })
        middle.snp.makeConstraints({ m in
            m.width.equalTo(getRatWidth(25.53))
            m.top.bottom.centerX.equalTo(self)
        })
        right.snp.makeConstraints({ m in
            m.width.equalTo(getRatWidth(25.53))
            m.right.top.bottom.equalTo(self)
        })
        self.snp.makeConstraints({ m in
            m.width.equalTo(getRatWidth(80))
            m.height.equalTo(getRatHeight(10))
        })
        
        if level == 1 {
            left.backgroundColor = UIColor(red: 39/255, green: 205/255, blue: 123/255, alpha: 1)
        } else if level == 2 {
            left.backgroundColor = UIColor(red: 255/255, green: 173/255, blue: 0/255, alpha: 1)
            middle.backgroundColor = UIColor(red: 255/255, green: 173/255, blue: 0/255, alpha: 1)
        } else if level == 3 {
            left.backgroundColor = UIColor(red: 255/255, green: 56/255, blue: 69/255, alpha: 1)
            middle.backgroundColor = UIColor(red: 255/255, green: 56/255, blue: 69/255, alpha: 1)
            right.backgroundColor = UIColor(red: 255/255, green: 56/255, blue: 69/255, alpha: 1)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
