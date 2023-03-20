import UIKit

class SignUpEndViewController: UIViewController {
    
    // MARK: - Properties
    private let checkLogo: UILabel = {
        let label = UILabel()
        label.text = "✔️"
        label.font = UIFont(name: "Pretendard-Bold", size: 25)
        label.textColor = .black
        return label
    }()
    
    private let completeLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입 요청 완료"
        label.font = UIFont(name: "Pretendard-Bold", size: 25)
        label.textColor = .black
        return label
    }()
    
    private lazy var confirmButton: ActionButton = {
        let button = ActionButton(title: "확인")
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
    }
    
    
    // MARK: - Helpers
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func configureUI() {
        view.backgroundColor = .backgroundPurple
        
        view.addSubview(confirmButton)
        view.addSubview(checkLogo)
        view.addSubview(completeLabel)
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        checkLogo.translatesAutoresizingMaskIntoConstraints = false
        completeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            confirmButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            confirmButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            checkLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 207),
            checkLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completeLabel.topAnchor.constraint(equalTo: checkLogo.bottomAnchor, constant: 15),
            completeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    // MARK: - Selectors
    @objc private func onTapNextButton() {
        print("on tap next button")
    }
    
    @objc private func onTapUploadButton() {
        print("on tap upload button")
    }
    
}
