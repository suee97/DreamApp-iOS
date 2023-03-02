import UIKit

class SelectLoginViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var loginButton: ActionButton = {
        let button = ActionButton(title: "로그인")
        button.addTarget(self, action: #selector(onTapLoginButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var withoutLoginButton: ActionButton = {
        let button = ActionButton(title: "로그인 없이 이용하기", backgroundColor: .secondaryPurple)
        button.addTarget(self, action: #selector(onTapWithoutLoginButton), for: .touchUpInside)
        return button
    }()
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dream_logo")
        return imageView
    }()
    
    
    // MARK: - LifeCycle
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
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(self.loginButton)
        view.addSubview(self.withoutLoginButton)
        view.addSubview(self.logo)
        
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.withoutLoginButton.translatesAutoresizingMaskIntoConstraints = false
        self.logo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -92),
            self.loginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            self.loginButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            self.loginButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            self.withoutLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.withoutLoginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            self.withoutLoginButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            self.withoutLoginButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            self.logo.widthAnchor.constraint(equalToConstant: 218),
            self.logo.heightAnchor.constraint(equalToConstant: 105),
            self.logo.bottomAnchor.constraint(equalTo: self.loginButton.topAnchor, constant: -253),
            self.logo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    
    // MARK: - Selectors
    @objc private func onTapLoginButton() {
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func onTapWithoutLoginButton() {
        // dialog -> home
    }
    
}
