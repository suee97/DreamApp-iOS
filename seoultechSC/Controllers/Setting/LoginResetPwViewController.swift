import UIKit
import Alamofire

class LoginResetPwViewController: UIViewController {
    
    // MARK: - Properties
    let pwRegex: String = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\\d$@$!%*#?~^<>,.&+=]{8,16}$"
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dream_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var confirmButton: ActionButton = {
        let button = ActionButton(title: "확인")
        button.addTarget(self, action: #selector(onTapNextButton), for: .touchUpInside)
        return button
    }()
    
    private let helpLabelView: UIView = {
        let container = UIView()
        let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
        label1.text = "비밀번호를 재설정해주세요."
        label1.font = UIFont(name: "Pretendard-Regular", size: 15)
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 20, width: 300, height: 20))
        label2.text = "(영어 대소문자, 숫자, 특수문자 포함하여 8자 이상 16자 이내)"
        label2.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        container.addSubview(label1)
        container.addSubview(label2)
        
        return container
    }()
    
    private let pwLabel: TitleLabel = TitleLabel("기존 비밀번호")
    private let pwCheckLabel: TitleLabel = TitleLabel("변경할 비밀번호")
    
    private let formCheckLabel1: UILabel = {
        let textField = UILabel()
        textField.font = UIFont(name: "Pretendard-Regular", size: 12)
        return textField
    }()
    
    private let formCheckLabel2: UILabel = {
        let textField = UILabel()
        textField.font = UIFont(name: "Pretendard-Regular", size: 12)
        return textField
    }()
    
    private lazy var currentPwField: GreyTextField = {
        let textField = GreyTextField()
        textField.configurePlaceholder("비밀번호를 입력하세요.")
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var newPwField: GreyTextField = {
        let textField = GreyTextField()
        textField.configurePlaceholder("비밀번호를 입력하세요.")
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
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
        
        self.navigationItem.title = "비밀번호 재설정"
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        confirmButton.setActive(false)
        
        view.addSubview(logo)
        view.addSubview(confirmButton)
        view.addSubview(helpLabelView)
        view.addSubview(pwLabel)
        view.addSubview(currentPwField)
        view.addSubview(newPwField)
        view.addSubview(pwCheckLabel)
        view.addSubview(formCheckLabel1)
        view.addSubview(formCheckLabel2)
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        helpLabelView.translatesAutoresizingMaskIntoConstraints = false
        pwLabel.translatesAutoresizingMaskIntoConstraints = false
        currentPwField.translatesAutoresizingMaskIntoConstraints = false
        pwCheckLabel.translatesAutoresizingMaskIntoConstraints = false
        newPwField.translatesAutoresizingMaskIntoConstraints = false
        formCheckLabel1.translatesAutoresizingMaskIntoConstraints = false
        formCheckLabel2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 62),
            logo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 140),
            logo.heightAnchor.constraint(equalToConstant: 67),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            confirmButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            confirmButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            newPwField.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -50),
            newPwField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            newPwField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            pwCheckLabel.bottomAnchor.constraint(equalTo: newPwField.topAnchor, constant: -11),
            pwCheckLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            currentPwField.bottomAnchor.constraint(equalTo: pwCheckLabel.topAnchor, constant: -20),
            currentPwField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            currentPwField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            pwLabel.bottomAnchor.constraint(equalTo: currentPwField.topAnchor, constant: -11),
            pwLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            helpLabelView.widthAnchor.constraint(equalToConstant: 300),
            helpLabelView.heightAnchor.constraint(equalToConstant: 40),
            helpLabelView.bottomAnchor.constraint(equalTo: pwLabel.topAnchor, constant: -50),
            helpLabelView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            formCheckLabel1.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            formCheckLabel1.bottomAnchor.constraint(equalTo: currentPwField.topAnchor, constant: -12),
            formCheckLabel2.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            formCheckLabel2.bottomAnchor.constraint(equalTo: newPwField.topAnchor, constant: -12),
        ])
    }
    
    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - Selectors
    @objc private func onTapNextButton() {
        setVcState(state: .loading)
        patchPw(completion: { result in
            if result == .success {
                self.setVcState(state: .normal)
                let vc = SelectLoginViewController()
                self.logout()
                showToast(view: vc.view, message: "비밀번호 변경이 완료되었습니다. 다시 로그인해주세요.")
                self.navigationController?.setViewControllers([vc], animated: true)
            } else if result == .expired {
                AuthHelper.shared.refreshAccessToken(completion: { result in
                    if result == .refreshed {
                        self.patchPw(completion: { result in
                            if result == .success {
                                self.setVcState(state: .normal)
                                let vc = SelectLoginViewController()
                                self.logout()
                                showToast(view: vc.view, message: "비밀번호 변경이 완료되었습니다. 다시 로그인해주세요.")
                                self.navigationController?.setViewControllers([vc], animated: true)
                            } else if result == .checkFail {
                                self.setVcState(state: .normal)
                                showToast(view: self.view, message: "비밀번호가 일치하지 않습니다.")
                            } else {
                                self.setVcState(state: .normal)
                                showToast(view: self.view, message: "오류가 발생했습니다.")
                            }
                        })
                    } else { // result is fail
                        self.setVcState(state: .normal)
                        showToast(view: self.view, message: "오류가 발생했습니다.")
                    }
                })
            } else if result == .checkFail {
                self.setVcState(state: .normal)
                showToast(view: self.view, message: "비밀번호가 일치하지 않습니다.")
            } else { // result is fail
                self.setVcState(state: .normal)
                showToast(view: self.view, message: "오류가 발생했습니다.")
            }
        })
    }
    
    private func logout() {
        KeychainHelper.sharedKeychain.resetAccessRefreshToken()
    }
    
    private func patchPw(completion: @escaping (PatchApiResult) -> Void) {
        let url = api_url + "/member/login/password"
        let params = ["currentPassword": currentPwField.text!, "newPassword" : newPwField.text!]
        let aToken: String = KeychainHelper.sharedKeychain.getAccessToken() ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(aToken)"
        ]
        
        let request = AF.request(url,
                                 method: .patch,
                                 parameters: params,
                                 encoding: JSONEncoding.default,
                                 headers: header
        ).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(AuthApiResult.self, from: responseData)
                    if result.status == 200 {
                        completion(.success)
                        return
                    }
                    if result.errorCode == "ST011" {
                        completion(.expired)
                        return
                    }
                    if result.errorCode == "ST050" {
                        completion(.checkFail)
                        return
                    }
                    completion(.fail)
                } catch {
                    completion(.fail)
                }
            case .failure:
                completion(.fail)
            }
        }
    }
    
    @objc private func didTextFieldChanged() {
        let isCurrentPwFieldMatchRegex: Bool = NSPredicate(format: "SELF MATCHES %@", pwRegex).evaluate(with: currentPwField.text)
        let isNewPwFieldMatchRegex: Bool = NSPredicate(format: "SELF MATCHES %@", pwRegex).evaluate(with: newPwField.text)
        
        if !isCurrentPwFieldMatchRegex {
            formCheckLabel1.text = "비밀번호 형식이 올바르지 않습니다."
            formCheckLabel1.textColor = UIColor(red: 255/255, green: 56/255, blue: 69/255, alpha: 1)
        } else {
            formCheckLabel1.text = "올바른 형식의 비밀번호가 입력되었습니다."
            formCheckLabel1.textColor = .primaryPurple
        }
        
        if !isNewPwFieldMatchRegex {
            formCheckLabel2.text = "비밀번호 형식이 올바르지 않습니다."
            formCheckLabel2.textColor = UIColor(red: 255/255, green: 56/255, blue: 69/255, alpha: 1)
        } else {
            formCheckLabel2.text = "올바른 형식의 비밀번호가 입력되었습니다."
            formCheckLabel2.textColor = .primaryPurple
        }
        
        if isCurrentPwFieldMatchRegex && isNewPwFieldMatchRegex && currentPwField.text != "" && newPwField.text != "" {
            confirmButton.setActive(true)
        } else {
            confirmButton.setActive(false)
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.view.frame.origin.y = -keyboardHeight + 40
        }
    }
    
    @objc private func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    private func setVcState(state: vcState) {
        if state == .normal {
            currentPwField.isEnabled = true
            newPwField.isEnabled = true
            currentPwField.textColor = .black
            newPwField.textColor = .black
            confirmButton.setLoading(false)
            return
        }
        if state == .loading {
            currentPwField.isEnabled = false
            newPwField.isEnabled = false
            currentPwField.textColor = .text_caption
            newPwField.textColor = .text_caption
            confirmButton.setLoading(true)
            return
        }
    }
}

private enum vcState {
    case normal
    case loading
}

private enum PatchApiResult {
    case success
    case expired
    case checkFail
    case fail
}

