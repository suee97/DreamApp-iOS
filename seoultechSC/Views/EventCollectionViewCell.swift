import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    let cellWidth: CGFloat = screenWidth * (155/360)
    let cellHeight: CGFloat = screenWidth * (155/360) * (220/155)
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.numberOfLines = 2
        return label
    }()
    
    let startTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = .black
        return label
    }()
    
    let endTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = .black
        return label
    }()
    
    let tiltLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = .black
        label.text = " ~ "
        return label
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
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(startTimeLabel)
        contentView.addSubview(tiltLabel)
        contentView.addSubview(endTimeLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        tiltLabel.translatesAutoresizingMaskIntoConstraints = false
        endTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalToConstant: cellWidth),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: screenWidth * (155/360) * (5/155)),
            titleLabel.heightAnchor.constraint(equalToConstant: screenWidth * (155/360) * (38/155)),
            startTimeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            startTimeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: screenWidth * (155/360) * (2/155)),
            tiltLabel.leftAnchor.constraint(equalTo: startTimeLabel.rightAnchor, constant: 0),
            tiltLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: screenWidth * (155/360) * (2/155)),
            endTimeLabel.leftAnchor.constraint(equalTo: tiltLabel.rightAnchor, constant: 0),
            endTimeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: screenWidth * (155/360) * (2/155))
        ])
    }
}
