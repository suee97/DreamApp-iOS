import UIKit
import Alamofire

class EnterInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Properties
    private let pickerView = UIPickerView()
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dream_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: TitleLabel = TitleLabel("이름")
    private let idLabel: TitleLabel = TitleLabel("학번")
    private let majorLabel: TitleLabel = TitleLabel("학과")
    
    private lazy var nameField: GreyTextField = {
        let textField = GreyTextField()
        textField.configurePlaceholder("이름을 입력하세요.")
        textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var idField: GreyTextField = {
        let textField = GreyTextField()
        textField.configurePlaceholder("학번 8자리를 입력하세요.")
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        return textField
    }()
    
    lazy var majorField: GreyTextField = {
        let textField = GreyTextField()
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 6, y: 10, width: 20, height: 20))

        imageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .primaryPurple
        
        container.addSubview(imageView)
        textField.rightView = container
        textField.rightViewMode = .always
        textField.text = "기계시스템디자인공학과"
        textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var nextButton: ActionButton = {
        let button = ActionButton(title: "다음")
        button.addTarget(self, action: #selector(onTapNextButton), for: .touchUpInside)
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
        
        self.navigationItem.title = "회원가입"
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        configurePickerView()
        nextButton.setActive(false)
        view.backgroundColor = .white
        
        view.addSubview(logo)
        view.addSubview(nameLabel)
        view.addSubview(nameField)
        view.addSubview(idLabel)
        view.addSubview(idField)
        view.addSubview(majorLabel)
        view.addSubview(majorField)
        view.addSubview(nextButton)
                
        logo.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameField.translatesAutoresizingMaskIntoConstraints = false
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idField.translatesAutoresizingMaskIntoConstraints = false
        majorLabel.translatesAutoresizingMaskIntoConstraints = false
        majorField.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 109),
            logo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 140),
            logo.heightAnchor.constraint(equalToConstant: 67),
            nextButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            nextButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            nextButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            majorField.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -50),
            majorField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            majorField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            idField.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -140),
            idField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            idField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            nameField.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -230),
            nameField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            nameField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            majorLabel.bottomAnchor.constraint(equalTo: majorField.topAnchor, constant: -11),
            majorLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            idLabel.bottomAnchor.constraint(equalTo: idField.topAnchor, constant: -11),
            idLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            nameLabel.bottomAnchor.constraint(equalTo: nameField.topAnchor, constant: -11),
            nameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
        ])
    }
    
    private func configurePickerView() {
        pickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 220)
        pickerView.delegate = self
        pickerView.dataSource = self
        majorField.inputView = pickerView
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
        let vc = PhoneAuthViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTextFieldChanged() {
        if nameField.text != "" && idField.text != "" && majorField.text != "" {
            nextButton.setActive(true)
        } else {
            nextButton.setActive(false)
        }
    }
    
    @objc func onTapDone() {
        majorField.resignFirstResponder()
    }
    
    @objc func onTapCancel() {
        majorField.resignFirstResponder()
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
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return majors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return majors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        majorField.text = majors[row]
    }
}
