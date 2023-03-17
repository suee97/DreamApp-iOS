import UIKit

class SetPwViewController: UIViewController {
    
    // MARK: - Properties
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dream_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var nextButton: ActionButton = {
        let button = ActionButton(title: "다음")
        button.addTarget(self, action: #selector(onTapNextButton), for: .touchUpInside)
        return button
    }()
    
    private let helpLabelView: UIView = {
        let container = UIView()
        let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
        label1.text = "비밀번호를 설정해주세요."
        label1.font = UIFont(name: "Pretendard-Regular", size: 15)
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 20, width: 300, height: 20))
        label2.text = "(영어 대소문자, 숫자, 특수문자 각 1개 이상 사용)"
        label2.font = UIFont(name: "Pretendard-Regular", size: 15)
        
        container.addSubview(label1)
        container.addSubview(label2)
        
        return container
    }()

    private let pwLabel: TitleLabel = TitleLabel("비밀번호")
    private let pwCheckLabel: TitleLabel = TitleLabel("비밀번호 확인")
    
    private lazy var pwField: GreyTextField = {
        let textField = GreyTextField()
        return textField
    }()
    
    private lazy var pwCheckField: GreyTextField = {
        let textField = GreyTextField()
        return textField
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
        
        self.navigationItem.title = "비밀번호"
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(logo)
        view.addSubview(nextButton)
        view.addSubview(helpLabelView)
        view.addSubview(pwLabel)
        view.addSubview(pwField)
        view.addSubview(pwCheckField)
        view.addSubview(pwCheckLabel)
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        helpLabelView.translatesAutoresizingMaskIntoConstraints = false
        pwLabel.translatesAutoresizingMaskIntoConstraints = false
        pwField.translatesAutoresizingMaskIntoConstraints = false
        pwCheckLabel.translatesAutoresizingMaskIntoConstraints = false
        pwCheckField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 109),
            logo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 140),
            logo.heightAnchor.constraint(equalToConstant: 67),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            nextButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            nextButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            pwCheckField.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -50),
            pwCheckField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            pwCheckField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            pwCheckLabel.bottomAnchor.constraint(equalTo: pwCheckField.topAnchor, constant: -11),
            pwCheckLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            pwField.bottomAnchor.constraint(equalTo: pwCheckLabel.topAnchor, constant: -20),
            pwField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            pwField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            pwLabel.bottomAnchor.constraint(equalTo: pwField.topAnchor, constant: -11),
            pwLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            helpLabelView.widthAnchor.constraint(equalToConstant: 300),
            helpLabelView.heightAnchor.constraint(equalToConstant: 40),
            helpLabelView.bottomAnchor.constraint(equalTo: pwLabel.topAnchor, constant: -50),
            helpLabelView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
        ])
    }
    
    
    // MARK: - Selectors
    @objc private func onTapNextButton() {
        let vc = StudentCardAuthViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
