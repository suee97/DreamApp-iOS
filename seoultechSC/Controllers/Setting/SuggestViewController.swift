import UIKit

class SuggestViewController: UIViewController, UITextFieldDelegate,  UITextViewDelegate {
    
    // MARK: Properties
    var appBarTitle: String?
    var suggestCase: SuggestCase?
    
    private let contentTextViewPlaceHolder = "문의내용을 입력하세요."
    
    private let titleField: titleTextField = {
        let tf = titleTextField()
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 10
        tf.textColor = .black
        tf.backgroundColor = .white
        tf.attributedPlaceholder = NSAttributedString(string: "제목을 입력하세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.text_caption])
        tf.clipsToBounds = true
        tf.borderStyle = .none
        tf.font = UIFont(name: "Pretendard-Regular", size: 15)
        return tf
    }()
    
    private let contentTextView: UITextView = {
        let tv = UITextView()
        tv.layer.cornerRadius = 10
        tv.backgroundColor = .white
        tv.textColor = .text_caption
        tv.textContainerInset = UIEdgeInsets(top: 11.0, left: 11.0, bottom: 11.0, right: 11.0)
        tv.font = UIFont(name: "Pretendard-Regular", size: 15)
        tv.text = "문의내용을 입력하세요."
        return tv
    }()
    
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(onTapAddPhotoButton), for: .touchUpInside)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "photo_image")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .text_caption
        imageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.text = "사진 추가"
        label.font = UIFont(name: "Pretendard-Bold", size: 12)
        label.textColor = .text_caption
        
        button.addSubview(imageView)
        button.addSubview(label)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 18),
            imageView.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 10),
            imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8)
        ])
        
        return button
    }()
    
    let helpContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.sizeToFit()
        
        let label1 = UILabel()
        label1.text = "주의사항"
        label1.textColor = UIColor(red: 255/255, green: 56/255, blue: 69/255, alpha: 1)
        label1.font = UIFont(name: "Pretendard-Bold", size: 12)
        
        let label2 = UILabel()
        label2.text = "1. 모든 문의는 익명입니다.\n2. 답변을 받으시려면 연락처(이메일, 휴대전화)를 남겨주세요."
        label2.numberOfLines = 0
        label2.textColor = .text_caption
        label2.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        view.addSubview(label1)
        view.addSubview(label2)
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label1.leftAnchor.constraint(equalTo: view.leftAnchor),
            label1.topAnchor.constraint(equalTo: view.topAnchor),
            label2.leftAnchor.constraint(equalTo: view.leftAnchor),
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 8)
        ])
        
        return view
    }()
    
    private lazy var cancelButton: ActionButton = {
        let button = ActionButton(title: "취소")
        button.backgroundColor = .secondaryPurple
        button.addTarget(self, action: #selector(onTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var sendButton: ActionButton = {
        let button = ActionButton(title: "보내기")
        button.addTarget(self, action: #selector(onTapSendButton), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureUI()
        configureDelegate()
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
        
        self.navigationItem.title = appBarTitle
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .backgroundPurple
        
        view.addSubview(titleField)
        view.addSubview(contentTextView)
        view.addSubview(addPhotoButton)
        view.addSubview(helpContainer)
        view.addSubview(cancelButton)
        view.addSubview(sendButton)
        
        titleField.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        helpContainer.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleField.heightAnchor.constraint(equalToConstant: 45),
            titleField.widthAnchor.constraint(equalToConstant: getRatWidth(320)),
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: getRatHeight(19)),
            contentTextView.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 15),
            contentTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentTextView.widthAnchor.constraint(equalToConstant: getRatWidth(320)),
            contentTextView.heightAnchor.constraint(equalToConstant: getRatHeight(261)),
            addPhotoButton.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 9),
            addPhotoButton.leftAnchor.constraint(equalTo: contentTextView.leftAnchor),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 96),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 25),
            helpContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -127),
            helpContainer.leftAnchor.constraint(equalTo: addPhotoButton.leftAnchor),
            cancelButton.leftAnchor.constraint(equalTo: helpContainer.leftAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: getRatWidth(100)),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            sendButton.rightAnchor.constraint(equalTo: contentTextView.rightAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: getRatWidth(210)),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func configureDelegate() {
        contentTextView.delegate = self
        titleField.delegate = self
    }
    
    @objc private func onTapAddPhotoButton() {
        print("add photo button clicked")
    }
    
    @objc private func onTapRemovePhotoButton() {
        print("remove photo button clicked")
    }
    
    @objc private func onTapCancelButton() {
        print("cancel button clicked")
    }
    
    @objc private func onTapSendButton() {
        print("send button clicked")
    }
    
    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == contentTextViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = contentTextViewPlaceHolder
            textView.textColor = .text_caption
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)
        
        let characterCount = newString.count
        guard characterCount <= 500 else { return false }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText.count > 20 {
            return false
        } else {
            return true
        }
    }
    
    @objc func didTapBackground() {
        view.endEditing(true)
    }
}

enum SuggestCase {
    case feature
    case error
    case etc
}

class titleTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 19, bottom: 0, right: 19)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

