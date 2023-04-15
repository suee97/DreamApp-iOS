import UIKit

class RentViewController: UIViewController {
    
    let container: UIView = {
        let container = UIView()
        container.layer.cornerRadius = 10
        
        return container
    }()
    
    var itemTitle: UILabel = {
        let title = UILabel()
        title.text = "품목 이름"
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        return title
    }()
    
    var line: UILabel = {
        let line = UILabel()
        line.text = "  "
        line.font = UIFont(name: "Pretendard-Bold", size: 1)
        line.textColor = .white
        
        line.layer.borderWidth = 1
        line.layer.borderColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1).cgColor
        
        return line
    }()
    
    var rentRangeTitle: UILabel = {
        let title = UILabel()
        title.text = "기간"
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        return title
    }()
    
    private lazy var rentRange: GreyTextField = {
        let textField = GreyTextField()
        textField.configurePlaceholder("2000.00.00 - 00.00")
        textField.isSecureTextEntry = true
        textField.isUserInteractionEnabled = false
        
        return textField
    }()
    
    var rentPurposeTitle: UILabel = {
        let title = UILabel()
        title.text = "목적"
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        return title
    }()
    
    private lazy var rentPurpose: GreyTextField = {
        let textField = GreyTextField()
        textField.configurePlaceholder("물품 대여 목적을 적어주세요.")
        
        return textField
    }()
    
    var rentAmountTitle: UILabel = {
        let title = UILabel()
        title.text = "수량"
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        return title
    }()
    
    private lazy var rentAmount: GreyTextField = {
        let textField = GreyTextField()
        textField.configurePlaceholder("0")
        textField.isUserInteractionEnabled = false
        
        textField.frame = CGRect(x: 0, y: 0, width: 123, height: 40)
        
        return textField
    }()
    
    var rentNoticeTitle: UILabel = {
        let title = UILabel()
        title.text = "주의사항"
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        return title
    }()
    
    private lazy var rentNotice: GreyTextField = {
        let textField = GreyTextField()
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    private lazy var confirmButton: RadioButton = {
        let button = RadioButton()
        var config = UIButton.Configuration.plain()
        config.title = "동의합니다"
        config.attributedTitle?.font = UIFont(name: "Pretendard-Regular", size: 12)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.imagePadding = 7
        button.configuration = config
        button.titleLabel?.tintColor = .black
//        button.addTarget(self, action: #selector(onTapAllCheckButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var rentButton : ActionButton = {
        let button = ActionButton(title: "신청하기")
        
        return button
    }()

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    // MARK: - Helpers
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        let na = customNavBarAppearance()
        self.navigationController?.navigationBar.scrollEdgeAppearance = na
        self.navigationController?.navigationBar.compactAppearance = na
        self.navigationController?.navigationBar.standardAppearance = na
        if #available(iOS 15.0, *) {
            navigationController?.navigationBar.compactScrollEdgeAppearance = na
        }
        
        self.navigationItem.title = "상시사업 예약"
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .backgroundPurple
        container.backgroundColor = .white
        
        let ViewArr = [container, itemTitle, line, rentRangeTitle, rentRange, rentPurposeTitle, rentPurpose, rentAmountTitle, rentAmount, rentNoticeTitle, rentNotice, confirmButton, rentButton]
        
        for i in ViewArr {
            view.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            container.bottomAnchor.constraint(equalTo: rentButton.topAnchor, constant: -17),

            itemTitle.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            itemTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: 11),

            line.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            line.topAnchor.constraint(equalTo: itemTitle.bottomAnchor, constant: 13),
            line.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            line.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),

            rentRangeTitle.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 19),
            rentRangeTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 21),

            rentRange.topAnchor.constraint(equalTo: rentRangeTitle.bottomAnchor, constant: 10),
            rentRange.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            rentRange.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
//
//            rentPurposeTitle.topAnchor.constraint(equalTo: rentRange.bottomAnchor, constant: 20),
//            rentPurposeTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 21),
//
//            rentPurpose.centerXAnchor.constraint(equalTo: container.centerXAnchor),
//            rentPurpose.topAnchor.constraint(equalTo: rentPurposeTitle.bottomAnchor, constant: 10),
//            rentPurpose.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
//            rentPurpose.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
//
//            rentAmountTitle.topAnchor.constraint(equalTo: rentPurpose.bottomAnchor, constant: 20),
//            rentAmountTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 21),
//
//            rentAmount.centerXAnchor.constraint(equalTo: container.centerXAnchor),
//            rentAmount.topAnchor.constraint(equalTo: rentAmountTitle.bottomAnchor, constant: 10),
//            rentAmount.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
//            rentAmount.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
//
//            rentNoticeTitle.topAnchor.constraint(equalTo: rentAmount.bottomAnchor, constant: 20),
//            rentNoticeTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 21),
//
//            rentNotice.centerXAnchor.constraint(equalTo: container.centerXAnchor),
//            rentNotice.topAnchor.constraint(equalTo: rentNoticeTitle.bottomAnchor, constant: 10),
//            rentNotice.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
//            rentNotice.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
//
//            confirmButton.topAnchor.constraint(equalTo: rentNotice.bottomAnchor, constant: 14),
//            confirmButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 21),
            
            rentButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            rentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -38),
            rentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            rentRange.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        
        
        
    }
    
}
