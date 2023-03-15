import UIKit
import Alamofire

class PhoneAuthViewController: UIViewController {
    
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
    
    private let helpLabel: UILabel = {
        let label = UILabel()
        label.text = "인증이 완료되었습니다."
        label.textColor = UIColor(red: 255/255, green: 56/255, blue: 69/255, alpha: 1)
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        return label
    }()
    
    private let phoneLabel: TitleLabel = TitleLabel("휴대폰번호")
    private let authLabel: TitleLabel = TitleLabel("인증번호")
    
    private lazy var askAuthButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 66, height: 40))
        button.backgroundColor = .primaryPurple
        button.layer.cornerRadius = 10
        button.setTitle("인증요청", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 12)
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 66, height: 40))
        button.backgroundColor = .primaryPurple
        button.layer.cornerRadius = 10
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 12)
        return button
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "3:00"
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textColor = UIColor(red: 255/255, green: 56/255, blue: 69/255, alpha: 1)
        return label
    }()
    
    private lazy var phoneField: GreyTextField = {
        let textField = GreyTextField()
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 66, height: 40))
        
        textField.configurePlaceholder("-없이 번호 입력")
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        
        container.addSubview(askAuthButton)
        
        textField.rightView = container
        textField.rightViewMode = .always
        return textField
    }()
    
    private lazy var authField: GreyTextField = {
        let textField = GreyTextField()
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 112, height: 40))
        
        textField.configurePlaceholder("인증번호 입력")
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        
        container.addSubview(timerLabel)
        container.addSubview(confirmButton)
        
        timerLabel.frame = CGRect(x: 0, y: 10, width: 36, height: 19)
        confirmButton.frame = CGRect(x: 46, y: 0, width: 66, height: 40)
        
        textField.rightView = container
        textField.rightViewMode = .always
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
        configureGesture()
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
        
        self.navigationItem.title = "휴대폰 인증"
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(logo)
        view.addSubview(nextButton)
        view.addSubview(phoneLabel)
        view.addSubview(phoneField)
        view.addSubview(authField)
        view.addSubview(authLabel)
        view.addSubview(helpLabel)
                
        logo.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneField.translatesAutoresizingMaskIntoConstraints = false
        authLabel.translatesAutoresizingMaskIntoConstraints = false
        authField.translatesAutoresizingMaskIntoConstraints = false
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 109),
            logo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 140),
            logo.heightAnchor.constraint(equalToConstant: 67),
            nextButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            nextButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            nextButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            helpLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            helpLabel.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -104),
            authField.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -50),
            authField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            authField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            authLabel.bottomAnchor.constraint(equalTo: authField.topAnchor, constant: -11),
            authLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            phoneField.bottomAnchor.constraint(equalTo: authLabel.topAnchor, constant: -20),
            phoneField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            phoneField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            phoneLabel.bottomAnchor.constraint(equalTo: phoneField.topAnchor, constant: -11),
            phoneLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20)
        ])
    }
    
    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - Selectors
    @objc func onTapNextButton() {
//        guard let studentNo = idField.text else { return }
//        print(studentNo)
//        let url = "\(api_url)/member/duplicate?studentNo=\(studentNo)"
//        print(url)
//
//        let request = AF.request(url,
//                                 method: .get,
//                                 parameters: nil,
//                                 encoding: URLEncoding.default,
//                                 headers: nil
//        ).responseJSON { data in
//            print(data)
//        }
        let vc = SetPwViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTextFieldChanged() {
        print("text changed")
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.view.frame.origin.y = -keyboardHeight
        }
    }
    
    @objc private func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}
