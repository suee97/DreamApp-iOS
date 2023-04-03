import UIKit
import Alamofire
import AVFoundation
import Photos

class StudentCardAuthViewController: UIViewController, UpdateImageDelegate {
    
    // MARK: - Properties
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dream_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nextButton: ActionButton = {
        let button = ActionButton(title: "가입 요청하기")
        button.addTarget(self, action: #selector(onTapNextButton), for: .touchUpInside)
        return button
    }()
    
    private let helpLabel: UIView = {
        let label = UILabel()
        label.text = "학생증을 촬영하여 업로드해주세요."
        label.font = UIFont(name: "Pretendard-Regular", size: 15)
        return label
    }()
    
    private let uploadLabel: UILabel = {
        let label = UILabel()
        label.text = "학생증 촬영 및 업로드"
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textColor = .text_caption
        return label
    }()
    
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "plus.circle"))
        imageView.tintColor = .text_caption
        return imageView
    }()
    
    private lazy var innerView: UIView = {
        let innerView = UIView()
        innerView.isUserInteractionEnabled = false
        return innerView
    }()
    
    private lazy var uploadButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 30
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 3
        
        button.addTarget(self, action: #selector(onTapUploadButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 30
        imageView.contentMode = .scaleToFill
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapUploadButton))
        imageView.addGestureRecognizer(gesture)
        return imageView
    }()
    
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
        
        self.navigationItem.title = "학생증 인증"
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        nextButton.setActive(false)
        cardImageView.isHidden = true
        
        view.addSubview(logo)
        view.addSubview(nextButton)
        view.addSubview(helpLabel)
        view.addSubview(uploadButton)
        view.addSubview(cardImageView)
        uploadButton.addSubview(innerView)
        innerView.addSubview(symbolImageView)
        innerView.addSubview(uploadLabel)
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        uploadLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        innerView.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            innerView.heightAnchor.constraint(equalToConstant: 63),
            innerView.widthAnchor.constraint(equalToConstant: 136),
            innerView.centerXAnchor.constraint(equalTo: uploadButton.centerXAnchor),
            innerView.centerYAnchor.constraint(equalTo: uploadButton.centerYAnchor),
            innerView.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 0),
            innerView.centerXAnchor.constraint(equalTo: innerView.centerXAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 29),
            symbolImageView.heightAnchor.constraint(equalToConstant: 29),
            symbolImageView.topAnchor.constraint(equalTo: uploadLabel.bottomAnchor, constant: 15),
            symbolImageView.centerXAnchor.constraint(equalTo: innerView.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 109),
            logo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 140),
            logo.heightAnchor.constraint(equalToConstant: 67),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            nextButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            nextButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            helpLabel.bottomAnchor.constraint(equalTo: uploadButton.topAnchor, constant: -42),
            helpLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            uploadButton.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -69),
            uploadButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 38),
            uploadButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -38),
            uploadButton.heightAnchor.constraint(equalToConstant: 171),
            cardImageView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -69),
            cardImageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 38),
            cardImageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -38),
            cardImageView.heightAnchor.constraint(equalToConstant: 171)
        ])
    }
    
    
    // MARK: - Selectors
    @objc private func onTapNextButton() {
        nextButton.setLoading(true)
        signUpUser.file = cardImageView.image?.jpegData(compressionQuality: 0.1)
        
        let url = api_url + "/member"
        let header: HTTPHeaders = ["Content-type" : "multipart/form-data"]
        let params = [
            "studentNo": signUpUser.studentNo ?? "",
            "appPassword": signUpUser.appPassword ?? "",
            "name": signUpUser.name ?? "",
            "department": signUpUser.department ?? "",
            "fcmToken": "none",
            "phoneNo": signUpUser.phoneNo ?? ""
        ]
        
        // TODO: 예외처리
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key, mimeType: "text/plain")
            }
            
            multipartFormData.append(signUpUser.file!, withName: "file", fileName: "tmp_file.jpeg", mimeType: "image/jpeg")
            
        }, to: url, method: .post, headers: header)
        .responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(AuthApiResult.self, from: responseData)
                    if result.status == 201 {
                        self.nextButton.setLoading(false)
                        let vc = SelectLoginViewController()
                        self.navigationController?.setViewControllers([vc], animated: true)
                        showToast(view: vc.view, message: "회원가입 요청을 완료했습니다.")
                    } else if result.errorCode == "ST053" {
                        self.nextButton.setLoading(false)
                        let vc = SelectLoginViewController()
                        self.navigationController?.setViewControllers([vc], animated: true)
                        showToast(view: vc.view, message: "이미 가입된 회원입니다. 로그인해주세요.")
                    } else if result.errorCode == "ST058" {
                        self.nextButton.setLoading(false)
                        let vc = SelectLoginViewController()
                        self.navigationController?.setViewControllers([vc], animated: true)
                        showToast(view: vc.view, message: "탈퇴한 회원입니다. 02-970-7012로 문의해주세요.")
                    } else if result.errorCode == "ST066" {
                        self.nextButton.setLoading(false)
                        let vc = SelectLoginViewController()
                        self.navigationController?.setViewControllers([vc], animated: true)
                        showToast(view: vc.view, message: "휴대폰 인증정보가 일치하지 않습니다. 다시 시도해주세요.")
                    } else {
                        self.nextButton.setLoading(false)
                        showToast(view: self.view, message: "오류가 발생했습니다.")
                    }
                    
                } catch {
                    self.nextButton.setLoading(false)
                    showToast(view: self.view, message: "오류가 발생했습니다.")
                }
            case .failure:
                self.nextButton.setLoading(false)
                showToast(view: self.view, message: "오류가 발생했습니다.")
            }
        }
    }
    
    @objc private func onTapUploadButton() {
        let vc = ChooseModalViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - Functions
    func sendUpdateImage(_ image: UIImage) {
        cardImageView.image = image
        cardImageView.isHidden = false
        cardImageView.isUserInteractionEnabled = true
        uploadButton.isHidden = true
        nextButton.setActive(true)
    }
}

class ChooseModalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: UpdateImageDelegate?
    
    private let modalView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 3
        
        return view
    }()
    
    private lazy var pickImageButton: UIButton = {
        let imageView = UIImageView(image: UIImage(named: "photo_image.svg"))
        imageView.contentMode = .scaleAspectFit
        
        let textLabel = UILabel()
        textLabel.text = "사진첩에서 선택"
        textLabel.textColor = .text_caption
        textLabel.font = UIFont(name: "Pretendard-Regular", size: 15)
        
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(onTapPickImage), for: .touchUpInside)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(imageView)
        button.addSubview(textLabel)
        imageView.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 11.67).isActive = true
        imageView.topAnchor.constraint(equalTo: button.topAnchor, constant: 21).isActive = true
        textLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 13).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        return button
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGrey
        return view
    }()
    
    private lazy var takePictureButton: UIButton = {
        let imageView = UIImageView(image: UIImage(named: "camera_image.svg"))
        imageView.contentMode = .scaleAspectFit
        
        let textLabel = UILabel()
        textLabel.text = "직접 촬영"
        textLabel.textColor = .text_caption
        textLabel.font = UIFont(name: "Pretendard-Regular", size: 15)
        
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(onTapTakePicture), for: .touchUpInside)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(imageView)
        button.addSubview(textLabel)
        imageView.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 11.67).isActive = true
        imageView.topAnchor.constraint(equalTo: button.topAnchor, constant: 21).isActive = true
        textLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 13).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        view.addGestureRecognizer(gesture)
    }
    
    private func configureUI() {
        view.backgroundColor = .modalBackground
        
        view.addSubview(modalView)
        modalView.addSubview(pickImageButton)
        modalView.addSubview(divider)
        modalView.addSubview(takePictureButton)
        
        modalView.translatesAutoresizingMaskIntoConstraints = false
        pickImageButton.translatesAutoresizingMaskIntoConstraints = false
        divider.translatesAutoresizingMaskIntoConstraints = false
        takePictureButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            modalView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modalView.widthAnchor.constraint(equalToConstant: 285),
            modalView.heightAnchor.constraint(equalToConstant: 100),
            pickImageButton.heightAnchor.constraint(equalToConstant: 49),
            pickImageButton.leftAnchor.constraint(equalTo: modalView.leftAnchor, constant: 0),
            pickImageButton.rightAnchor.constraint(equalTo: modalView.rightAnchor, constant: 0),
            pickImageButton.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 0),
            takePictureButton.heightAnchor.constraint(equalToConstant: 49),
            takePictureButton.leftAnchor.constraint(equalTo: modalView.leftAnchor, constant: 0),
            takePictureButton.rightAnchor.constraint(equalTo: modalView.rightAnchor, constant: 0),
            takePictureButton.topAnchor.constraint(equalTo: pickImageButton.bottomAnchor, constant: 2),
            divider.leftAnchor.constraint(equalTo: modalView.leftAnchor, constant: 16),
            divider.rightAnchor.constraint(equalTo: modalView.rightAnchor, constant: -16),
            divider.heightAnchor.constraint(equalToConstant: 2),
            divider.centerYAnchor.constraint(equalTo: modalView.centerYAnchor)
        ])
        
    }
    
    @objc private func onTapPickImage() {
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
    
    @objc private func onTapTakePicture() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { authStatus in
            if authStatus == true {
                self.openCamera()
            } else {
                self.showRequestPermissionSettingDialog(title: "카메라에 대한 접근 권한이 없습니다.", message: "'설정 > 카메라'에서 접근 권한을 활성화 해주세요.")
            }
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image: UIImage = info[.originalImage] as? UIImage else { return }
        delegate?.sendUpdateImage(image)
        picker.dismiss(animated: true)
        dismissModal()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        dismissModal()
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
    
    private func openCamera() {
        DispatchQueue.main.async {
            let pickerController = UIImagePickerController()
            pickerController.sourceType = .camera
            pickerController.delegate = self
            pickerController.allowsEditing = false
            pickerController.mediaTypes = ["public.image"]
            self.present(pickerController, animated: true)
        }
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
}

protocol UpdateImageDelegate {
    func sendUpdateImage(_ image: UIImage)
}
