import UIKit

class SelectLoginViewController: UIViewController {
    
    // MARK: - Properties
    
    let loginButton: ActionButton = {
        let button = ActionButton(title: "로그인")
        button.addTarget(self, action: #selector(onTapLoginButton), for: .touchUpInside)
        return button
    }()
    let withoutLoginButton: ActionButton = {
        let button = ActionButton(title: "로그인 없이 이용하기", backgroundColor: .secondaryPurple)
        button.addTarget(self, action: #selector(onTapWithoutLoginButton), for: .touchUpInside)
        return button
    }()
    let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dream_logo")
        return imageView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(loginButton)
        view.addSubview(withoutLoginButton)
        view.addSubview(logo)
        
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.withoutLoginButton.translatesAutoresizingMaskIntoConstraints = false
        self.logo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -92),
            self.loginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            self.withoutLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.withoutLoginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            self.logo.widthAnchor.constraint(equalToConstant: 218),
            self.logo.heightAnchor.constraint(equalToConstant: 105),
            self.logo.bottomAnchor.constraint(equalTo: self.loginButton.topAnchor, constant: -253),
            self.logo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
    }
    
    // MARK: - Selectors
    @objc func onTapLoginButton() {
        print("onTapLoginButton() clicked")
    }
    
    @objc func onTapWithoutLoginButton() {
        print("onTapWithoutLoginButton() clicked")
    }
    
    
    // MARK: - Functions
    
}
