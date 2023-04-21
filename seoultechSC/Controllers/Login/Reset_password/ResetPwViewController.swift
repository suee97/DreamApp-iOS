import UIKit
import Alamofire

class ResetPwViewController: UIViewController {
    
    // MARK: - Properties
    lazy var studentNo = ""
    
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
    
    private let pwLabel: TitleLabel = TitleLabel("비밀번호")
    private let pwCheckLabel: TitleLabel = TitleLabel("비밀번호 확인")
    
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
    
    private lazy var pwField: GreyTextField = {
        let textField = GreyTextField()
        textField.configurePlaceholder("비밀번호를 입력하세요.")
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var pwCheckField: GreyTextField = {
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
        view.addSubview(pwField)
        view.addSubview(pwCheckField)
        view.addSubview(pwCheckLabel)
        view.addSubview(formCheckLabel1)
        view.addSubview(formCheckLabel2)
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        helpLabelView.translatesAutoresizingMaskIntoConstraints = false
        pwLabel.translatesAutoresizingMaskIntoConstraints = false
        pwField.translatesAutoresizingMaskIntoConstraints = false
        pwCheckLabel.translatesAutoresizingMaskIntoConstraints = false
        pwCheckField.translatesAutoresizingMaskIntoConstraints = false
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
            pwCheckField.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -50),
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
            formCheckLabel1.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            formCheckLabel1.bottomAnchor.constraint(equalTo: pwField.topAnchor, constant: -12),
            formCheckLabel2.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            formCheckLabel2.bottomAnchor.constraint(equalTo: pwCheckField.topAnchor, constant: -12),
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
        let url = api_url + "/member/password"
        let params = ["password" : pwField.text!, "studentNo" : studentNo]
        let request = AF.request(url,
                                 method: .patch,
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
                        self.setVcState(state: .normal)
                        let vc = SelectLoginViewController()
                        showToast(view: vc.view, message: "비밀번호 변경이 완료되었습니다.")
                        self.navigationController?.setViewControllers([vc], animated: true)
                        return
                    }
                    self.setVcState(state: .normal)
                    showToast(view: self.view, message: "오류가 발생했습니다.")
                    print("1111")
                } catch {
                    self.setVcState(state: .normal)
                    showToast(view: self.view, message: "오류가 발생했습니다.")
                    print("2222")
                }
            case .failure:
                self.setVcState(state: .normal)
                showToast(view: self.view, message: "오류가 발생했습니다.")
                print("3333")
            }
        }
        
    }
    
    @objc private func didTextFieldChanged() {
        let isMatchRegex: Bool = NSPredicate(format: "SELF MATCHES %@", pwRegex).evaluate(with: pwField.text)
        
        if !isMatchRegex {
            formCheckLabel1.text = "비밀번호 형식이 올바르지 않습니다."
            formCheckLabel1.textColor = UIColor(red: 255/255, green: 56/255, blue: 69/255, alpha: 1)
        } else {
            formCheckLabel1.text = "올바른 형식의 비밀번호가 입력되었습니다."
            formCheckLabel1.textColor = .primaryPurple
        }
        
        if pwCheckField.text != "" && isMatchRegex && pwField.text == pwCheckField.text {
            formCheckLabel2.text = "동일한 비밀번호가 입력되었습니다."
            formCheckLabel2.textColor = .primaryPurple
        } else {
            formCheckLabel2.text = "동일한 비밀번호를 입력해주세요."
            formCheckLabel2.textColor = UIColor(red: 255/255, green: 56/255, blue: 69/255, alpha: 1)
        }
        
        if isMatchRegex && pwField.text == pwCheckField.text {
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
            pwField.isEnabled = true
            pwCheckField.isEnabled = true
            pwField.textColor = .black
            pwCheckField.textColor = .black
            confirmButton.setLoading(false)
            return
        }
        if state == .loading {
            pwField.isEnabled = false
            pwCheckField.isEnabled = false
            pwField.textColor = .text_caption
            pwCheckField.textColor = .text_caption
            confirmButton.setLoading(true)
            return
        }
    }
}

private enum vcState {
    case normal
    case loading
}

import SwiftUI
#if DEBUG
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    @available(iOS 13.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        ResetPwViewController()
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
}

#endif
