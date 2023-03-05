import UIKit
import Alamofire

class LoginViewController: UIViewController {

    // MARK: - Properties
    private let idField: GreyTextField = {
        let textField = GreyTextField()
        textField.placeholder = "학번 8자리를 입력하세요."
        return textField
    }()
    
    private let pwField: GreyTextField = {
        let textField = GreyTextField()
        textField.placeholder = "비밀번호를 입력하세요."
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton: ActionButton = {
        let button = ActionButton(title: "로그인")
        button.addTarget(self, action: #selector(onTapLoginButton), for: .touchUpInside)
        return button
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.text = "학번"
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        return label
    }()
    
    private let pwLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        return label
    }()
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dream_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 재설정", for: .normal)
        button.setTitleColor(.text_caption, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        button.addTarget(self, action: #selector(onTapResetButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.text_caption, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        button.addTarget(self, action: #selector(onTapSignUpButton), for: .touchUpInside)
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
        
        self.navigationItem.title = "로그인"
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(self.idField)
        view.addSubview(self.pwField)
        view.addSubview(self.loginButton)
        view.addSubview(self.idLabel)
        view.addSubview(self.pwLabel)
        view.addSubview(self.logo)
        view.addSubview(self.resetButton)
        view.addSubview(self.signUpButton)
        
        self.idField.translatesAutoresizingMaskIntoConstraints = false
        self.pwField.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.idLabel.translatesAutoresizingMaskIntoConstraints = false
        self.pwLabel.translatesAutoresizingMaskIntoConstraints = false
        self.logo.translatesAutoresizingMaskIntoConstraints = false
        self.resetButton.translatesAutoresizingMaskIntoConstraints = false
        self.signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.idField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -267),
            self.idField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            self.idField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            self.idField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            self.pwField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -177),
            self.pwField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            self.pwField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            self.pwField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            self.loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -57),
            self.loginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            self.loginButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            self.loginButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            self.idLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -318),
            self.idLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            self.pwLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -228),
            self.pwLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            self.logo.bottomAnchor.constraint(equalTo: self.idLabel.topAnchor, constant: -106),
            self.logo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            self.logo.widthAnchor.constraint(equalToConstant: 140),
            self.logo.heightAnchor.constraint(equalToConstant: 67),
            self.resetButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 11),
            self.resetButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            self.signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 11),
            self.signUpButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20)
        ])
    }
    
    
    // MARK: - Selectors
    @objc private func onTapLoginButton() {
        let url = api_url + "/auth/login"
        let params = ["studentNo" : idField.text, "password" : pwField.text] as Dictionary
        let request = AF.request(url,
                                 method: .post,
                                 parameters: params,
                                 encoding: JSONEncoding(options: []),
                                 headers: nil
        ).responseJSON { data in
            print(data)
        }
        
    }
    
    @objc private func onTapResetButton() {
        print("reset button clicked")
    }
    
    @objc private func onTapSignUpButton() {
        print("sign up button clicked")
    }
    
}
