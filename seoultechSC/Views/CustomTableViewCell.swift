import UIKit

class CustomTableViewCell: UITableViewCell {
    
    public var radioButton: RadioButton = {
        let radioButton = RadioButton()
        return radioButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        
        contentView.addSubview(radioButton)
        
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            radioButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 20),
            radioButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            radioButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.backgroundColor = .white
        
        var config = UIButton.Configuration.plain()
        radioButton.setTitleColor(.black, for: .normal)
        radioButton.backgroundColor = .white
        config.attributedTitle?.font = UIFont(name: "Pretendard-Regular", size: 15)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.imagePadding = 7
        radioButton.contentHorizontalAlignment = .leading
        radioButton.isUserInteractionEnabled = false
        radioButton.configuration = config
    }

}
