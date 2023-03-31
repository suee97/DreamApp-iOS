import UIKit
import Alamofire

class EnterInfoViewController: UIViewController, UpdateCollegeDelegate, UpdateMajorDelegate, UITextFieldDelegate {
    
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
        configureTextDelegate()
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
        nextButton.setActive(false)
        
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
    
    private func configureTextDelegate() {
        nameField.delegate = self
        idField.delegate = self
    }
    
    func sendUpdateCollege(_ collegeText: String) {
        collegeField.text = collegeText
        majorField.text = ""
        didTextFieldChanged()
    }
    
    func sendUpdateMajor(_ majorText: String) {
        majorField.text = majorText
        didTextFieldChanged()
    }
    
    
    // MARK: - Selectors
    @objc func onTapNextButton() {
        nextButton.setLoading(true)

        guard let studentNo = idField.text else { return }
        let url = "\(api_url)/member/duplicate?studentNo=\(studentNo)"

        let request = AF.request(url,
                                 method: .get,
                                 parameters: nil,
                                 encoding: URLEncoding.default,
                                 headers: nil
        ).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    // TODO: 예외처리 UI
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(AuthApiResult.self, from: responseData)
                    if result.status == 200 {
                        self.nextButton.setLoading(false)
                        self.view.endEditing(true)
                        let vc = PhoneAuthViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    if result.errorCode == "ST053" {
                        // 가입된 학번 존재
                        self.nextButton.setLoading(false)
                    } else {
                        self.nextButton.setLoading(false)
                    }
                } catch {
                    self.nextButton.setLoading(false)
                }
            case .failure:
                self.nextButton.setLoading(false)
            }
        }
    }
    
    @objc func didTextFieldChanged() {
        if idField.text?.count == 8 && nameField.text != "" && collegeField.text != "" && majorField.text != "" {
            nextButton.setActive(true)
        } else {
            nextButton.setActive(false)
        }
    }
    
    @objc func onTapCollegeField() {
        let vc = CollegeSelectViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func onTapMajorField() {
        if collegeField.text != "" {
            let vc = MajorSelectViewController()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = self
            vc.college = collegeField.text!
            self.present(vc, animated: true, completion: nil)
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - Functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.isEqual(idField) {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }

}


class CollegeSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    var delegate: UpdateCollegeDelegate?
    var selectedCollege: String = ""
    
    var tableView = UITableView()
    
    private lazy var confirmButton: ActionButton = {
        let button = ActionButton(title: "확인", height: 34)
        button.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "단과대학 선택"
        label.font = UIFont(name: "Pretendard-Bold", size: 15)
        label.backgroundColor = .navy
        label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        label.clipsToBounds = true
        label.textColor = .white
        return label
    }()
    
    let modal: UIView = {
        let view = UIView()
        view.configureModalView()
        return view
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        tableView.allowsSelection = true
        
        view.addSubview(modal)
        view.addSubview(tableView)
        modal.addSubview(confirmButton)
        modal.addSubview(titleLabel)
        
        modal.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            modal.widthAnchor.constraint(equalToConstant: 285),
            modal.heightAnchor.constraint(equalToConstant: 400),
            modal.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            modal.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            confirmButton.centerXAnchor.constraint(equalTo: modal.centerXAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: modal.bottomAnchor, constant: -14),
            confirmButton.leftAnchor.constraint(equalTo: modal.leftAnchor, constant: 18),
            confirmButton.rightAnchor.constraint(equalTo: modal.rightAnchor, constant: -18),
            titleLabel.centerXAnchor.constraint(equalTo: modal.centerXAnchor),
            titleLabel.leftAnchor.constraint(equalTo: modal.leftAnchor, constant: 0),
            titleLabel.rightAnchor.constraint(equalTo: modal.rightAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: modal.topAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 45),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -25),
            tableView.leftAnchor.constraint(equalTo: modal.leftAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: modal.rightAnchor, constant: 0)
        ])
    }
    
    @objc private func dismissModal() {
        delegate?.sendUpdateCollege(selectedCollege)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collegeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        cell.radioButton.setTitle(collegeList[indexPath.row], for: .normal)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 34
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0...collegeList.count-1 {
            if i == indexPath.row {
                continue
            }
            let ip = IndexPath(row: i, section: 0)
            let tmpCell = tableView.cellForRow(at: ip) as? CustomTableViewCell
            tmpCell?.radioButton.setState(false)
        }
        let cell: CustomTableViewCell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
        cell.radioButton.setState(true)
        selectedCollege = collegeList[indexPath.row]
    }

}


class MajorSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    var delegate: UpdateMajorDelegate?
    var majorIndex: Int = 0
    var selectedMajor: String = ""
    var tableView = UITableView()
    var college: String = "" {
        willSet {
            majorIndex = collegeList.firstIndex { $0 == newValue}!
        }
    }
    
    private lazy var confirmButton: ActionButton = {
        let button = ActionButton(title: "확인", height: 34)
        button.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "단과대학 선택"
        label.font = UIFont(name: "Pretendard-Bold", size: 15)
        label.backgroundColor = .navy
        label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        label.clipsToBounds = true
        label.textColor = .white
        return label
    }()
    
    let modal: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 6
        return view
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        tableView.allowsSelection = true
        
        view.addSubview(modal)
        view.addSubview(tableView)
        modal.addSubview(confirmButton)
        modal.addSubview(titleLabel)
        
        modal.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            modal.widthAnchor.constraint(equalToConstant: 285),
            modal.heightAnchor.constraint(equalToConstant: 400),
            modal.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            modal.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            confirmButton.centerXAnchor.constraint(equalTo: modal.centerXAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: modal.bottomAnchor, constant: -14),
            confirmButton.leftAnchor.constraint(equalTo: modal.leftAnchor, constant: 18),
            confirmButton.rightAnchor.constraint(equalTo: modal.rightAnchor, constant: -18),
            titleLabel.centerXAnchor.constraint(equalTo: modal.centerXAnchor),
            titleLabel.leftAnchor.constraint(equalTo: modal.leftAnchor, constant: 0),
            titleLabel.rightAnchor.constraint(equalTo: modal.rightAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: modal.topAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 45),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -25),
            tableView.leftAnchor.constraint(equalTo: modal.leftAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: modal.rightAnchor, constant: 0)
        ])
    }
    
    @objc private func dismissModal() {
        delegate?.sendUpdateMajor(selectedMajor)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return majorList[majorIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        cell.radioButton.setTitle(majorList[majorIndex][indexPath.row], for: .normal)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 34
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0...collegeList.count-1 {
            if i == indexPath.row {
                continue
            }
            let ip = IndexPath(row: i, section: 0)
            let tmpCell = tableView.cellForRow(at: ip) as? CustomTableViewCell
            tmpCell?.radioButton.setState(false)
        }
        let cell: CustomTableViewCell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
        cell.radioButton.setState(true)
        selectedMajor = majorList[majorIndex][indexPath.row]
    }

}

protocol UpdateCollegeDelegate {
    func sendUpdateCollege(_ collegeText: String)
}

protocol UpdateMajorDelegate {
    func sendUpdateMajor(_ majorText: String)
}
