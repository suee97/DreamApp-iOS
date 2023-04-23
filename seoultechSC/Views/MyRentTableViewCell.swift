import UIKit

class MyRentTableViewCell: UITableViewCell {
    
    static let identifier = "MyRentTableViewCell"
    
    let itemTitle : UILabel = {
        var itemTitle = UILabel()
        itemTitle.font = UIFont(name: "Pretendard-Bold", size: 16)
        itemTitle.textColor = .black
        
        return itemTitle
    }()
    
    let amountTitle : UILabel = {
        var title = UILabel()
        title.text = "수량"
        title.font = UIFont(name: "Pretendard-Regular", size: 15)
        title.textColor = .text_caption
        return title
    }()
    
    let amount: UILabel = {
        var amount = UILabel()
        amount.font = UIFont(name: "Pretendard-Regular", size: 15)
        amount.textColor = .text_caption
        return amount
    }()
    
    let rentRangeTitle : UILabel = {
        var title = UILabel()
        title.text = "대여기간"
        title.font = UIFont(name: "Pretendard-Regular", size: 15)
        title.textColor = .text_caption
        return title
    }()
    
    let range: UILabel = {
        var range = UILabel()
        range.font = UIFont(name: "Pretendard-Regular", size: 15)
        range.textColor = .text_caption
        return range
    }()
    
    let circleContainer : UIView = {
        
        let circle = UIView()
        circle.layer.cornerRadius = 35
        
        return circle
    }()
    
    let rentStatusLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textColor = .white
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(corder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0))
    }
    
    private func configureUI() {
        self.backgroundColor = .clear
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white
        
        let viewArr = [itemTitle, amountTitle, amount, rentRangeTitle, range, circleContainer, rentStatusLabel]
        
        for i in viewArr {
            contentView.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            itemTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
            itemTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            amountTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            amountTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            amount.centerYAnchor.constraint(equalTo: amountTitle.centerYAnchor),
            amount.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 78),
            
            rentRangeTitle.topAnchor.constraint(equalTo: amountTitle.bottomAnchor, constant: 9),
            rentRangeTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            range.centerYAnchor.constraint(equalTo: rentRangeTitle.centerYAnchor),
            range.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 78),
            
            circleContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            circleContainer.widthAnchor.constraint(equalToConstant: 70),
            circleContainer.heightAnchor.constraint(equalToConstant: 70),
            
            rentStatusLabel.centerXAnchor.constraint(equalTo: circleContainer.centerXAnchor),
            rentStatusLabel.centerYAnchor.constraint(equalTo: circleContainer.centerYAnchor),
            
            
        ])
    }
    
}
