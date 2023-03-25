import UIKit

class SelectLoginViewController: UIViewController, UpdateAfterModalDelegate {
    
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
            self.logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 119),
            self.logo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    
    // MARK: - Selectors
    @objc private func onTapLoginButton() {
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func onTapWithoutLoginButton() {
        let vc = WithoutLoginModal()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Functions
    func pushHome(withoutLogin: Bool) {
        if withoutLogin {
            let vc = HomeViewController()
            navigationController?.pushViewController(vc, animated: true)
            // TODO: pop all view
        }
    }
}

class WithoutLoginModal: UIViewController {
    
    var delegate: UpdateAfterModalDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인 없이 이용하기"
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        return label
    }()
    
    private let modalView: UIView = {
        let view = UIView()
        view.configureModalView()
        
        let label1 = UILabel()
        let label2 = UILabel()
        let label3 = UILabel()
        let label4 = UILabel()
        
        label1.text = "로그인을 하지 않을 시"
        label2.text = "어플 사용에 제한이 있을 수 있습니다."
        label3.text = "· 주 사업 이벤트"
        label4.text = "· 상시사업 예약 확인"
        
        label1.textColor = .text_caption
        label2.textColor = .text_caption
        label3.textColor = .text_caption
        label4.textColor = .text_caption
        
        label1.font = UIFont(name: "Pretendard-Regular", size: 15)
        label2.font = UIFont(name: "Pretendard-Regular", size: 15)
        label3.font = UIFont(name: "Pretendard-Regular", size: 12)
        label4.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        let labelArr: [UILabel] = [label1, label2, label3, label4]
        
        for i in labelArr {
            view.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
            i.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: view.topAnchor, constant: 58),
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 0),
            label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 10),
            label4.topAnchor.constraint(equalTo: label3.bottomAnchor, constant: 0)
        ])
        
        return view
    }()
    
    private lazy var cancelButton: ActionButton = {
        let button = ActionButton(title: "취소", backgroundColor: .secondaryPurple, height: 34)
        button.addTarget(self, action: #selector(onTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton: ActionButton = {
        let button = ActionButton(title: "확인", height: 34)
        button.addTarget(self, action: #selector(onTapConfirmButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
        
        view.addSubview(modalView)
        modalView.addSubview(titleLabel)
        modalView.addSubview(cancelButton)
        modalView.addSubview(confirmButton)
        
        modalView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            modalView.widthAnchor.constraint(equalToConstant: 285),
            modalView.heightAnchor.constraint(equalToConstant: 215),
            modalView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 19),
            titleLabel.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 121),
            confirmButton.widthAnchor.constraint(equalToConstant: 121),
            cancelButton.bottomAnchor.constraint(equalTo: modalView.bottomAnchor, constant: -15),
            confirmButton.bottomAnchor.constraint(equalTo: modalView.bottomAnchor, constant: -15),
            cancelButton.leftAnchor.constraint(equalTo: modalView.leftAnchor, constant: 17),
            confirmButton.rightAnchor.constraint(equalTo: modalView.rightAnchor, constant: -17)
        ])
    }

    @objc private func dismissModal() {
        self.dismiss(animated: true)
    }
    
    @objc private func onTapCancelButton() {
        dismissModal()
    }
    
    @objc private func onTapConfirmButton() {
        delegate?.pushHome(withoutLogin: true)
        dismissModal()
    }
}

protocol UpdateAfterModalDelegate {
    func pushHome(withoutLogin: Bool)
}
