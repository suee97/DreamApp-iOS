import UIKit
import SwiftUI

class EnterInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Properties
    private let pickerView = UIPickerView()
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dream_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        return label
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.text = "학번"
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        return label
    }()
    
    private let majorLabel: UILabel = {
        let label = UILabel()
        label.text = "학과"
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        return label
    }()
    
    private lazy var nameField: GreyTextField = {
        let textField = GreyTextField()
        textField.placeholder = "이름을 입력하세요."
        textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var idField: GreyTextField = {
        let textField = GreyTextField()
        textField.placeholder = "학번 8자리를 입력하세요."
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        return textField
    }()
    
    lazy var majorField: GreyTextField = {
        let textField = GreyTextField()
        textField.placeholder = "학과를 선택해주세요."
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
    }
    
    
    // MARK: - Selectors
    @objc func onTapNextButton() {
        print("next button clicked")
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
