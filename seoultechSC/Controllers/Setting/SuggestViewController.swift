import UIKit
import Photos
import Alamofire

class SuggestViewController: UIViewController, UITextFieldDelegate,  UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    var appBarTitle: String?
    var suggestCase: SuggestCase?
    private var suggestImage: UIImage?
    private let noImageImageData = UIImage(named: "no_image_image")?.jpegData(compressionQuality: 0.01)
    
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
    
    private lazy var removePhotoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.primaryPurple.cgColor
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "photo_image")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .primaryPurple
        imageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.text = "사진 추가됨"
        label.font = UIFont(name: "Pretendard-Bold", size: 12)
        label.textColor = .text_caption
        label.textColor = .primaryPurple
        
        let removeView = UIView()
        removeView.backgroundColor = .white
        removeView.layer.cornerRadius = 12
        
        let cancelImageView = UIImageView()
        cancelImageView.image = UIImage(named: "remove_photo")
        cancelImageView.contentMode = .scaleAspectFit
        
        button.addSubview(imageView)
        button.addSubview(label)
        button.addSubview(removeView)
        removeView.addSubview(cancelImageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        removeView.translatesAutoresizingMaskIntoConstraints = false
        cancelImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 18),
            imageView.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 10),
            imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8),
            removeView.widthAnchor.constraint(equalToConstant: 27),
            removeView.rightAnchor.constraint(equalTo: button.rightAnchor),
            removeView.heightAnchor.constraint(equalToConstant: 25),
            removeView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            cancelImageView.widthAnchor.constraint(equalToConstant: 13),
            cancelImageView.heightAnchor.constraint(equalToConstant: 13),
            cancelImageView.centerXAnchor.constraint(equalTo: removeView.centerXAnchor),
            cancelImageView.centerYAnchor.constraint(equalTo: removeView.centerYAnchor)
        ])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapRemovePhotoButton))
        removeView.addGestureRecognizer(gesture)
        
        button.isHidden = true
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
        view.addSubview(removePhotoButton)
        view.addSubview(helpContainer)
        view.addSubview(cancelButton)
        view.addSubview(sendButton)
        
        titleField.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        removePhotoButton.translatesAutoresizingMaskIntoConstraints = false
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
            removePhotoButton.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 9),
            removePhotoButton.leftAnchor.constraint(equalTo: contentTextView.leftAnchor),
            removePhotoButton.widthAnchor.constraint(equalToConstant: 123),
            removePhotoButton.heightAnchor.constraint(equalToConstant: 25),
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
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .authorized:
            openPhotoLibrary()
        case .denied:
            showRequestPermissionSettingDialog(title: "사진에 대한 접근 권한이 없습니다.", message: "'설정 > 사진'에서 접근 권한을 활성화 해주세요.")
        case .notDetermined, .restricted:
            PHPhotoLibrary.requestAuthorization({ newStatus in
                if newStatus == PHAuthorizationStatus.authorized {
                    self.openPhotoLibrary()
                    print("new status granted")
                } else {
                    print("new status not granted")
                }
            })
        case .limited: print("limited")
        default: print("default")
        }
    }
    
    @objc private func
    onTapRemovePhotoButton() {
        if !removePhotoButton.isHidden {
            removePhotoButton.isHidden = true
        }
        if addPhotoButton.isHidden {
            addPhotoButton.isHidden = false
        }
        suggestImage = nil
    }
    
    @objc private func onTapCancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func onTapSendButton() {
        if titleField.text == "" || contentTextView.text == contentTextViewPlaceHolder {
            showToast(view: view, message: "내용을 입력해주세요.")
            return
        }
        
        let file = suggestImage?.jpegData(compressionQuality: 0.01) ?? noImageImageData
        
        var suggestCategory: String?
        let url = api_url + "/suggestion"
        
        switch suggestCase {
        case .feature:
            suggestCategory = "FEATURE"
        case .error:
            suggestCategory = "ERROR"
        case .etc:
            suggestCategory = "ETC"
        case .none:
            suggestCategory = "ETC"
        }
        
        let header: HTTPHeaders = ["Content-type" : "multipart/form-data"]
        let params : [String: String] = [
            "title": titleField.text!,
            "content": contentTextView.text,
            "category": suggestCategory!,
        ]
        
        sendButton.setLoading(true)
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key, mimeType: "text/plain")
            }
            
            multipartFormData.append(file!, withName: "file", fileName: "suggest_image.jpeg", mimeType: "image/jpeg")
        }, to: url, method: .post, headers: header).responseJSON { response in
            switch response.result {
            case .success:
                print(response)
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(SuggestApiResult.self, from: responseData)
                    if result.status == 201 {
                        self.sendButton.setLoading(false)
                        self.sendButton.setActive(true)
                        self.navigationController?.popViewController(animated: true)
                        showToast(view: (self.navigationController?.topViewController?.view)!, message: "요청이 완료되었습니다.")
                    }
                } catch {
                    self.sendButton.setLoading(false)
                    self.sendButton.setActive(true)
                    self.navigationController?.popViewController(animated: true)
                    showToast(view: (self.navigationController?.topViewController?.view)!, message: "오류가 발생했습니다.")
                }
            case .failure:
                self.sendButton.setLoading(false)
                self.sendButton.setActive(true)
                self.navigationController?.popViewController(animated: true)
                showToast(view: (self.navigationController?.topViewController?.view)!, message: "오류가 발생했습니다.")
            }
            
            self.sendButton.setLoading(false)
            self.sendButton.setActive(true)
        }
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
    
    private func showRequestPermissionSettingDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelaction = UIAlertAction(title: "취소", style: .default)
        let settingaction = UIAlertAction(title: "설정", style: UIAlertAction.Style.default) { UIAlertAction in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in })
            }
        }
        alert.addAction(cancelaction)
        alert.addAction(settingaction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func openPhotoLibrary() {
        DispatchQueue.main.async {
            let pickerController = UIImagePickerController()
            pickerController.sourceType = .photoLibrary
            pickerController.delegate = self
            pickerController.allowsEditing = false
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image: UIImage = info[.originalImage] as? UIImage else { return }
        suggestImage = image
        addPhotoButton.isHidden = true
        removePhotoButton.isHidden = false
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
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

private struct SuggestApiResult: Codable {
    let status: Int
    let message: String
    let data: [String]?
    let errorCode: String?
}
