import UIKit
import Alamofire

class EnterInfoViewController: UIViewController {
    
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
    private let collegeLabel: TitleLabel = TitleLabel("단과대학")
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
    
    lazy var collegeFieldContainer: UIView = {
        let container = UIView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapCollegeField))
        container.addGestureRecognizer(gesture)
        container.backgroundColor = .clear
        return container
    }()
    
    lazy var collegeField: GreyTextField = {
        let textField = GreyTextField()
        textField.configurePlaceholder("단과대학을 선택하세요.")
        textField.isUserInteractionEnabled = false
        textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        return textField
    }()
    
    lazy var majorFieldContainer: UIView = {
        let container = UIView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapMajorField))
        container.addGestureRecognizer(gesture)
        container.backgroundColor = .clear
        return container
    }()
    
    lazy var majorField: GreyTextField = {
        let textField = GreyTextField()
        textField.configurePlaceholder("학과를 선택하세요.")
        textField.isUserInteractionEnabled = false
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
        
        self.navigationItem.title = "학적 정보 입력"
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(logo)
        view.addSubview(nameLabel)
        view.addSubview(nameField)
        view.addSubview(idLabel)
        view.addSubview(idField)
        view.addSubview(collegeFieldContainer)
        view.addSubview(majorFieldContainer)
        view.addSubview(collegeLabel)
        view.addSubview(majorLabel)
        view.addSubview(nextButton)
        collegeFieldContainer.addSubview(collegeField)
        majorFieldContainer.addSubview(majorField)
                
        logo.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameField.translatesAutoresizingMaskIntoConstraints = false
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idField.translatesAutoresizingMaskIntoConstraints = false
        majorLabel.translatesAutoresizingMaskIntoConstraints = false
        majorField.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        collegeLabel.translatesAutoresizingMaskIntoConstraints = false
        collegeField.translatesAutoresizingMaskIntoConstraints = false
        collegeFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        majorFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // SubView
        NSLayoutConstraint.activate([
            collegeField.leftAnchor.constraint(equalTo: collegeFieldContainer.leftAnchor, constant: 0),
            collegeField.rightAnchor.constraint(equalTo: collegeFieldContainer.rightAnchor, constant: 0),
            majorField.leftAnchor.constraint(equalTo: majorFieldContainer.leftAnchor, constant: 0),
            majorField.rightAnchor.constraint(equalTo: majorFieldContainer.rightAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 109),
            logo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 140),
            logo.heightAnchor.constraint(equalToConstant: 67),
            nextButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            nextButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            nextButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            majorFieldContainer.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -50),
            majorFieldContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            majorFieldContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            majorFieldContainer.heightAnchor.constraint(equalToConstant: 40),
            idField.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -20),
            idField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            idField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            nameField.bottomAnchor.constraint(equalTo: collegeLabel.topAnchor, constant: -20),
            nameField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            nameField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            majorLabel.bottomAnchor.constraint(equalTo: majorFieldContainer.topAnchor, constant: -11),
            majorLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            idLabel.bottomAnchor.constraint(equalTo: idField.topAnchor, constant: -11),
            idLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            nameLabel.bottomAnchor.constraint(equalTo: nameField.topAnchor, constant: -11),
            nameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            collegeFieldContainer.bottomAnchor.constraint(equalTo: majorLabel.topAnchor, constant: -20),
            collegeFieldContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            collegeFieldContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            collegeFieldContainer.heightAnchor.constraint(equalToConstant: 40),
            collegeLabel.bottomAnchor.constraint(equalTo: collegeFieldContainer.topAnchor, constant: -11),
            collegeLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
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
        let vc = PhoneAuthViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTextFieldChanged() {
        
    }
    
    @objc func onTapCollegeField() {
        print("college field cilcked")
    }
    
    @objc func onTapMajorField() {
        print("major field cilcked")
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
