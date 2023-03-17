import UIKit

class StudentCardAuthViewController: UIViewController {
    
    // MARK: - Properties
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dream_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var nextButton: ActionButton = {
        let button = ActionButton(title: "확인")
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
        button.layer.shadowRadius = 6
        
        button.addTarget(self, action: #selector(onTapUploadButton), for: .touchUpInside)

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
        
        view.addSubview(logo)
        view.addSubview(nextButton)
        view.addSubview(helpLabel)
        view.addSubview(uploadButton)
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
        
        // SubView
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
            symbolImageView.centerXAnchor.constraint(equalTo: innerView.centerXAnchor)
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
            uploadButton.heightAnchor.constraint(equalToConstant: 171)
        ])
    }
    
    
    // MARK: - Selectors
    @objc private func onTapNextButton() {
        let vc = SignUpEndViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func onTapUploadButton() {
        print("on tap upload button")
    }
    
}
