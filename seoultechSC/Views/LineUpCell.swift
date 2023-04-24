import UIKit
import SnapKit

class LineUpCell: UICollectionViewCell {
    
    var lineUp: LineUp? {
        didSet {
            let arr = Array(lineUp!.lineUpTime)
            timeLabel.text = "\(arr[11])\(arr[12]):\(arr[14])\(arr[15])"
            descLabel.text = lineUp?.lineUpTitle
        }
    }
    var location: LineUpCellLocation? {
        didSet {
            if location == .start {
                lineTop.isHidden = false
                lineBottom.isHidden = true
            } else if location == .middle {
                lineTop.isHidden = false
                lineBottom.isHidden = false
            } else if location == .end {
                lineTop.isHidden = true
                lineBottom.isHidden = false
            }
        }
    }
    let rat: CGFloat = 254 / 320
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryPurple
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: "Pretendard-Regular", size: 15)
        return label
    }()
    
    private let descView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let circle: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryPurple
        view.layer.cornerRadius = 13/2
        return view
    }()
    
    private let lineTop: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryPurple
        view.isHidden = true
        return view
    }()
    
    private let lineBottom: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryPurple
        view.isHidden = true
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
        
        contentView.addSubview(descView)
        descView.addSubview(timeLabel)
        descView.addSubview(descLabel)
        contentView.addSubview(circle)
        contentView.addSubview(lineTop)
        contentView.addSubview(lineBottom)
        
        descView.snp.makeConstraints({ m in
            m.right.top.equalTo(contentView)
            m.bottom.equalTo(contentView).inset(10)
            m.width.equalTo(contentView).multipliedBy(rat)
        })
        timeLabel.snp.makeConstraints({ m in
            m.left.equalTo(descView).inset(14)
            m.top.equalTo(descView).inset(8)
        })
        descLabel.snp.makeConstraints({ m in
            m.left.equalTo(descView).inset(14)
            m.top.equalTo(timeLabel.snp.bottom).offset(6)
        })
        circle.snp.makeConstraints({ m in
            m.width.height.equalTo(13)
            m.centerY.equalTo(timeLabel.snp.centerY)
            m.left.equalTo(contentView).inset(getRatWidth(20))
        })
        lineTop.snp.makeConstraints({ m in
            m.width.equalTo(1)
            m.centerX.equalTo(circle)
            m.top.equalTo(circle.snp.centerY)
            m.bottom.equalTo(contentView)
        })
        lineBottom.snp.makeConstraints({ m in
            m.width.equalTo(1)
            m.centerX.equalTo(circle)
            m.top.equalTo(contentView)
            m.bottom.equalTo(circle.snp.centerY)
        })
    }
}

enum LineUpCellLocation {
    case start
    case middle
    case end
}
