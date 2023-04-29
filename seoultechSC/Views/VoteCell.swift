import UIKit
import SnapKit

class VoteCell: UICollectionViewCell {
    
    var vote: Vote? {
        didSet {
            titleLabel.text = vote?.title
            startContentLabel.text = getDate(string: vote!.displayStartDate)
            endContentLabel.text = getDate(string: vote!.displayEndDate)
            if vote?.status == "START" && vote?.userSelectedOptionIds.count != 0 {
                configureStatusLabel(status: .Done)
            } else if vote?.status == "START" {
                configureStatusLabel(status: .Start)
            } else if vote?.status == "BEFORE" {
                configureStatusLabel(status: .Before)
            } else if vote?.status == "END" {
                configureStatusLabel(status: .End)
            }
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textColor = .primaryPurple
        label.numberOfLines = 0
        return label
    }()
    
    let startTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "시작"
        label.font = UIFont(name: "Pretendard-Bold", size: 12)
        label.textColor = .navy
        return label
    }()
    
    let endTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "종료"
        label.font = UIFont(name: "Pretendard-Bold", size: 12)
        label.textColor = .navy
        return label
    }()
    
    let startContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = .navy
        return label
    }()
    
    let endContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = .navy
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.layer.cornerRadius = getRatWidth(15)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    private func configureUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(startTitleLabel)
        contentView.addSubview(endTitleLabel)
        contentView.addSubview(startContentLabel)
        contentView.addSubview(endContentLabel)
        contentView.addSubview(statusLabel)
        
        titleLabel.snp.makeConstraints({ m in
            m.left.equalTo(contentView).inset(getRatWidth(18))
            m.top.equalTo(contentView).inset(getRatHeight(12))
            m.right.equalTo(contentView).inset(getRatWidth(13))
            m.height.equalTo(getRatHeight(38))
        })
        startTitleLabel.snp.makeConstraints({ m in
            m.left.equalTo(contentView).inset(getRatWidth(18))
            m.top.equalTo(titleLabel.snp.bottom).offset(getRatHeight(7))
        })
        endTitleLabel.snp.makeConstraints({ m in
            m.left.equalTo(contentView).inset(getRatWidth(18))
            m.top.equalTo(startTitleLabel.snp.bottom).offset(getRatHeight(5))
        })
        startContentLabel.snp.makeConstraints({ m in
            m.left.equalTo(startTitleLabel.snp.right).offset(getRatWidth(13))
            m.top.equalTo(titleLabel.snp.bottom).offset(getRatHeight(7))
        })
        endContentLabel.snp.makeConstraints({ m in
            m.left.equalTo(endTitleLabel.snp.right).offset(getRatWidth(13))
            m.top.equalTo(startContentLabel.snp.bottom).offset(getRatHeight(5))
        })
        statusLabel.snp.makeConstraints({ m in
            m.width.equalTo(getRatWidth(67))
            m.height.equalTo(getRatHeight(30))
            m.right.equalTo(contentView).inset(getRatWidth(7))
            m.bottom.equalTo(contentView).inset(getRatHeight(7))
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getDate(string: String) -> String {
        let arr = Array(string)
        return "\(arr[5])\(arr[6])/\(arr[8])\(arr[9]) \(arr[11])\(arr[12]):\(arr[14])\(arr[15])"
    }
    
    private func configureStatusLabel(status: Status) {
        switch status {
        case .Before:
            statusLabel.backgroundColor = .secondaryPurple
            statusLabel.text = "투표 예정"
        case .Start:
            statusLabel.backgroundColor = UIColor(red: 39/255, green: 205/255, blue: 123/255, alpha: 1)
            statusLabel.text = "투표 가능"
        case .End:
            statusLabel.backgroundColor = .text_caption
            statusLabel.text = "투표 마감"
        case .Done:
            statusLabel.backgroundColor = .primaryPurple
            statusLabel.text = "투표 완료"
        }
    }
    
    private enum Status {
        case Before
        case Start
        case End
        case Done
    }
}
