import UIKit

class PolicyAgreeViewController: UIViewController {
    
    // MARK: - Properties
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dream_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let helpLabel: UILabel = {
        let label = UILabel()
        label.text = "어플리케이션 사용을 위한 약관 동의가 필요해요."
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Regular", size: 15)
        return label
    }()
    
    private lazy var allCheckButton: RadioButton = {
        let button = RadioButton()
        var config = UIButton.Configuration.plain()
        config.title = "전체 동의하기"
        config.attributedTitle?.font = UIFont(name: "Pretendard-Bold", size: 16)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.imagePadding = 7
        button.configuration = config
        button.titleLabel?.tintColor = .black
        button.addTarget(self, action: #selector(onTapAllCheckButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var privacyCheckButton: RadioButton = {
        let button = RadioButton()
        var config = UIButton.Configuration.plain()
        config.title = "개인정보처리방침"
        config.attributedTitle?.font = UIFont(name: "Pretendard-Regular", size: 15)
        config.attributedTitle?.foregroundColor = .black
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.imagePadding = 7
        button.configuration = config
        button.titleLabel?.tintColor = .black
        button.addTarget(self, action: #selector(onTapPrivacyCheckButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var serviceCheckButton: RadioButton = {
        let button = RadioButton()
        var config = UIButton.Configuration.plain()
        config.title = "서비스 이용약관"
        config.attributedTitle?.font = UIFont(name: "Pretendard-Regular", size: 15)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.imagePadding = 7
        button.configuration = config
        button.titleLabel?.tintColor = .black
        button.addTarget(self, action: #selector(onTapServiceCheckButton), for: .touchUpInside)
        return button
    }()
    
    private let divideLine: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGrey
        return line
    }()
    
    private lazy var nextButton: ActionButton = {
        let button = ActionButton(title: "다음")
        button.setActive(false)
        button.addTarget(self, action: #selector(onTapNextButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var privacyContentButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = "자세히 보기 >"
        config.attributedTitle?.font = UIFont(name: "Pretendard-Regular", size: 12)
        config.attributedTitle?.foregroundColor = .text_caption
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration = config
        button.addTarget(self, action: #selector(onTapPrivacyContentButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var serviceContentButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = "자세히 보기 >"
        config.attributedTitle?.font = UIFont(name: "Pretendard-Regular", size: 12)
        config.attributedTitle?.foregroundColor = .text_caption
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration = config
        button.addTarget(self, action: #selector(onTapServiceContentButton), for: .touchUpInside)
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
        
        self.navigationItem.title = "약관동의"
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(logo)
        view.addSubview(helpLabel)
        view.addSubview(allCheckButton)
        view.addSubview(privacyCheckButton)
        view.addSubview(serviceCheckButton)
        view.addSubview(divideLine)
        view.addSubview(nextButton)
        view.addSubview(privacyContentButton)
        view.addSubview(serviceContentButton)
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        allCheckButton.translatesAutoresizingMaskIntoConstraints = false
        privacyCheckButton.translatesAutoresizingMaskIntoConstraints = false
        serviceCheckButton.translatesAutoresizingMaskIntoConstraints = false
        divideLine.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        privacyContentButton.translatesAutoresizingMaskIntoConstraints = false
        serviceContentButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 109),
            logo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 140),
            logo.heightAnchor.constraint(equalToConstant: 67),
            helpLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -360),
            helpLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            allCheckButton.topAnchor.constraint(equalTo: helpLabel.bottomAnchor, constant: 22),
            allCheckButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            privacyCheckButton.topAnchor.constraint(equalTo: helpLabel.bottomAnchor, constant: 73),
            privacyCheckButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            serviceCheckButton.topAnchor.constraint(equalTo: helpLabel.bottomAnchor, constant: 111),
            serviceCheckButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            divideLine.topAnchor.constraint(equalTo: allCheckButton.bottomAnchor, constant: 12),
            divideLine.heightAnchor.constraint(equalToConstant: 1),
            divideLine.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            divideLine.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            nextButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            nextButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            privacyContentButton.topAnchor.constraint(equalTo: helpLabel.bottomAnchor, constant: 73),
            privacyContentButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -19),
            serviceContentButton.topAnchor.constraint(equalTo: helpLabel.bottomAnchor, constant: 111),
            serviceContentButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -19),
        ])
    }
    
    
    // MARK: - Selectors
    @objc private func onTapAllCheckButton() {
        if allCheckButton.checked {
            if privacyCheckButton.checked {
                privacyCheckButton.changeState()
            }
            if serviceCheckButton.checked {
                serviceCheckButton.changeState()
            }
            allCheckButton.changeState()
        } else {
            if !privacyCheckButton.checked {
                privacyCheckButton.changeState()
            }
            if !serviceCheckButton.checked {
                serviceCheckButton.changeState()
            }
            allCheckButton.changeState()
        }
        checkCanNext()
    }
    
    @objc private func onTapPrivacyCheckButton() {
        privacyCheckButton.changeState()
        if (!privacyCheckButton.checked || !serviceCheckButton.checked) && allCheckButton.checked {
            allCheckButton.changeState()
        }
        if privacyCheckButton.checked && serviceCheckButton.checked && !allCheckButton.checked {
            allCheckButton.changeState()
        }
        checkCanNext()
    }
    
    @objc private func onTapServiceCheckButton() {
        serviceCheckButton.changeState()
        if privacyCheckButton.checked && serviceCheckButton.checked && !allCheckButton.checked {
            allCheckButton.changeState()
        }
        checkCanNext()
    }
    
    @objc private func onTapNextButton() {
        let vc = EnterInfoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func onTapPrivacyContentButton() {
        let vc = PrivacyViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func onTapServiceContentButton() {
        let vc = ServiceViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Functions
    private func checkCanNext() {
        if privacyCheckButton.checked && serviceCheckButton.checked {
            nextButton.setActive(true)
        } else {
            nextButton.setActive(false)
        }
    }
    
}
