import UIKit
import Alamofire

class ResetPwPhoneAuthViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    private var timer: Timer?
    private var timerCount: Int = 0
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dream_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let contentLabelFirst: UILabel = {
        let label = UILabel()
        label.text = "가입된 계정의 학번을 입력해주세요."
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Regular", size: 15)
        return label
    }()
    
    private let contentLabelSecond: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "인증요청을 누르면 학번으로 가입된 계정의 휴대폰번호로 인증코드가 발송됩니다. 인증코드는 3분 내로 입력해주세요."
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        return label
    }()
    
    private lazy var nextButton: ActionButton = {
        let button = ActionButton(title: "다음")
        button.addTarget(self, action: #selector(onTapNextButton), for: .touchUpInside)
        return button
    }()
    
    private let helpLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(red: 255/255, green: 56/255, blue: 69/255, alpha: 1)
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        return label
    }()
    
    private let phoneLabel: TitleLabel = TitleLabel("학번")
    private let authLabel: TitleLabel = TitleLabel("인증번호")
    
    private lazy var askAuthButton: ActionButton = {
        let button = ActionButton(frame: CGRect(x: 0, y: 0, width: 66, height: 40))
        button.backgroundColor = .primaryPurple
        button.layer.cornerRadius = 10
        button.setTitle("인증요청", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 12)
        button.addTarget(self, action: #selector(onTapAskAuthButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton: ActionButton = {
        let button = ActionButton(frame: CGRect(x: 0, y: 0, width: 66, height: 40))
        button.backgroundColor = .primaryPurple
        button.layer.cornerRadius = 10
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 12)
        button.addTarget(self, action: #selector(onTapConfirmButton), for: .touchUpInside)
        return button
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "03:00"
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textColor = UIColor(red: 255/255, green: 56/255, blue: 69/255, alpha: 0.5)
        return label
    }()
    
    private lazy var idField: GreyTextField = {
        let textField = GreyTextField()
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 66, height: 40))
        
        textField.configurePlaceholder("학번 8자리를 입력하세요.")
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
        
        timerLabel.frame = CGRect(x: -10, y: 10, width: 48, height: 19)
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
        
        self.navigationItem.title = "비밀번호 재설정"
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureTextDelegate()
        
        nextButton.setActive(false)
        askAuthButton.setActive(false)
        confirmButton.setActive(false)
        authField.isEnabled = false
        
        view.addSubview(logo)
        view.addSubview(nextButton)
        view.addSubview(phoneLabel)
        view.addSubview(idField)
        view.addSubview(authField)
        view.addSubview(authLabel)
        view.addSubview(helpLabel)
        view.addSubview(contentLabelFirst)
        view.addSubview(contentLabelSecond)
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        idField.translatesAutoresizingMaskIntoConstraints = false
        authLabel.translatesAutoresizingMaskIntoConstraints = false
        authField.translatesAutoresizingMaskIntoConstraints = false
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabelFirst.translatesAutoresizingMaskIntoConstraints = false
        contentLabelSecond.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 62),
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
            idField.bottomAnchor.constraint(equalTo: authLabel.topAnchor, constant: -20),
            idField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            idField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            phoneLabel.bottomAnchor.constraint(equalTo: idField.topAnchor, constant: -11),
            phoneLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            contentLabelSecond.bottomAnchor.constraint(equalTo: phoneLabel.topAnchor, constant: -36),
            contentLabelSecond.widthAnchor.constraint(equalToConstant: 320),
            contentLabelSecond.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            contentLabelFirst.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            contentLabelFirst.bottomAnchor.constraint(equalTo: contentLabelSecond.topAnchor)
        ])
    }
    
    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureTextDelegate() {
        idField.delegate = self
        authField.delegate = self
    }
    
    
    // MARK: - Selectors
    @objc func onTapNextButton() {
        let vc = ResetPwViewController()
        vc.studentNo = idField.text!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTextFieldChanged() {
        if idField.isEnabled && idField.text?.count == 8 {
            askAuthButton.setActive(true)
        } else {
            askAuthButton.setActive(false)
        }
        
        if authField.isEnabled && authField.text?.count == 6 {
            confirmButton.setActive(true)
        } else {
            confirmButton.setActive(false)
        }
    }
    
    @objc private func onTapAskAuthButton() {
        askAuthButton.setLoading(true)
        idField.isEnabled = false
        idField.textColor = .text_caption
        
        let url = api_url + "/auth/sms/password"
        let params = ["studentNo" : idField.text] as Dictionary
        
        let request = AF.request(url,
                                 method: .post,
                                 parameters: params,
                                 encoding: JSONEncoding(options: []),
                                 headers: nil
        ).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(AuthApiResult.self, from: responseData)
                    
                    if result.status == 200 {
                        self.askAuthButton.setLoading(false)
                        self.setHelpLabel("인증번호 6자리를 입력해주세요.")
                        
                        self.timerLabel.textColor = UIColor(red: 255/255, green: 56/255, blue: 69/255, alpha: 1)
                        self.timerCount = 180
                        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerCallBack), userInfo: nil, repeats: true)
                        
                        self.authField.isEnabled = true
                        self.idField.textColor = .text_caption
                        self.idField.isEnabled = false
                        self.askAuthButton.setLoading(false)
                        self.askAuthButton.setActive(false)
                        return
                    }
                    if result.errorCode == "ST041" {
                        self.setHelpLabel("해당 학번으로 가입된 계정이 존재하지 않습니다.")
                        self.idField.isEnabled = true
                        self.askAuthButton.setLoading(false)
                        self.idField.textColor = .black
                        return
                    }
                    if result.errorCode == "ST057" {
                        self.setHelpLabel("학생증 인증 중인 계정입니다.")
                        self.idField.isEnabled = true
                        self.askAuthButton.setLoading(false)
                        self.idField.textColor = .black
                        return
                    }
                    if result.errorCode == "ST058" {
                        self.setHelpLabel("탈퇴한 계정입니다.")
                        self.idField.isEnabled = true
                        self.askAuthButton.setLoading(false)
                        self.idField.textColor = .black
                        return
                    }
                    if result.errorCode == "ST065" {
                        self.setHelpLabel("너무 많은 요청을 보냈습니다. 10분 뒤 다시 시도해주세요.")
                        self.idField.isEnabled = true
                        self.askAuthButton.setLoading(false)
                        self.idField.textColor = .black
                        return
                    }
                    self.setHelpLabel("오류가 발생했습니다.")
                    self.idField.isEnabled = true
                    self.askAuthButton.setLoading(false)
                    self.idField.textColor = .black
                } catch {
                    self.setHelpLabel("오류가 발생했습니다.")
                    self.idField.isEnabled = true
                    self.askAuthButton.setLoading(false)
                    self.idField.textColor = .black
                }
            case .failure:
                self.setHelpLabel("오류가 발생했습니다.")
                self.idField.isEnabled = true
                self.askAuthButton.setLoading(false)
                self.idField.textColor = .black
            }
        }
    }
    
    @objc private func onTapConfirmButton() {
        confirmButton.setLoading(true)
        authField.isEnabled = false
        authField.textColor = .text_caption
        
        let url = api_url + "/auth/sms/password/check"
        let params = ["studentNo" : idField.text!, "code" : authField.text!]
        
        let request = AF.request(url,
                                 method: .post,
                                 parameters: params,
                                 encoding: JSONEncoding.default,
                                 headers: nil
        ).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(AuthApiResult.self, from: responseData)
                    
                    if result.status == 200 {
                        self.timer?.invalidate()
                        self.timer = nil
                        self.timerLabel.textColor = UIColor(red: 255/255, green: 56/255, blue: 69/255, alpha: 0.5)
                        
                        self.confirmButton.setLoading(false)
                        self.confirmButton.setActive(false)
                        
                        self.authField.textColor = .text_caption
                        self.authField.isEnabled = false
                        
                        self.setHelpLabel("인증이 완료되었습니다.")
                        self.nextButton.setActive(true)
                        return
                    }
                    if result.errorCode == "ST066" {
                        self.setHelpLabel("인증정보가 일치하지 않습니다.")
                        self.authField.isEnabled = true
                        self.confirmButton.setLoading(false)
                        self.authField.textColor = .black
                        return
                    }
                    if result.errorCode == "ST067" {
                        self.setHelpLabel("인증시간이 만료되었습니다.")
                        self.authField.isEnabled = true
                        self.confirmButton.setLoading(false)
                        self.authField.textColor = .black
                        return
                    }
                    self.setHelpLabel("오류가 발생했습니다.")
                    self.authField.isEnabled = true
                    self.confirmButton.setLoading(false)
                    self.authField.textColor = .black
                } catch {
                    self.setHelpLabel("오류가 발생했습니다.")
                    self.authField.isEnabled = true
                    self.confirmButton.setLoading(false)
                    self.authField.textColor = .black
                }
            case .failure:
                self.setHelpLabel("오류가 발생했습니다.")
                self.authField.isEnabled = true
                self.confirmButton.setLoading(false)
                self.authField.textColor = .black
            }
        }
    }
    
    @objc private func timerCallBack() {
        timerCount -= 1
        
        let str: String?
        let min: Int = timerCount / 60
        let sec: Int = timerCount % 60
        if sec < 10 {
            str = "0\(min):0\(sec)"
        } else {
            str = "0\(min):\(sec)"
        }
        
        timerLabel.text = str
        
        if timerCount == 0 {
            timer?.invalidate()
            timer = nil
            
            setHelpLabel("인증시간이 만료되었습니다.")
            idField.isEnabled = true
            authField.isEnabled = false
            askAuthButton.setLoading(false)
            confirmButton.setActive(false)
            idField.textColor = .black
        }
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
    
    
    // MARK: - Functions
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        if textField.isEqual(idField) {
            let phoneString = idField.text ?? ""
            guard let phoneStringRange = Range(range, in: phoneString) else { return false }
            let updatedPhoneString = phoneString.replacingCharacters(in: phoneStringRange, with: string)
            return updatedPhoneString.count <= 8 && allowedCharacters.isSuperset(of: characterSet)
        }
        if textField.isEqual(authField) {
            let authString = authField.text ?? ""
            guard let authStringRange = Range(range, in: authString) else { return false }
            let updatedAuthString = authString.replacingCharacters(in: authStringRange, with: string)
            return updatedAuthString.count <= 6 && allowedCharacters.isSuperset(of: characterSet)
        }
        
        return false
    }
    
    private func setHelpLabel(_ text: String) {
        helpLabel.text = text
    }
}
