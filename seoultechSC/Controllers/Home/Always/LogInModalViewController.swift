import UIKit
import Alamofire

class LogInModalViewController: UIViewController {
    
    var delegate: LogInDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        return label
    }()
    
    private let modalView: UIView = {
        let view = UIView()
        view.configureModalView()
        
        let label1 = UILabel()
        label1.text = "로그인 하시겠습니까?"
        label1.textColor = .text_caption
        label1.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        label1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label1)
        
        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: view.topAnchor, constant: 58),
            label1.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        return view
    }()
    
    private lazy var cancelButton: ActionButton = {
        let button = ActionButton(title: "취소", backgroundColor: .secondaryPurple, height: 34)
        button.addTarget(self, action: #selector(onTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton: ActionButton = {
        let button = ActionButton(title: "확인", height: 34)
        button.addTarget(self, action: #selector(onTapConfirmButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .modalBackground
        
        view.addSubview(modalView)
        modalView.addSubview(titleLabel)
        modalView.addSubview(cancelButton)
        modalView.addSubview(confirmButton)
        
        modalView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            modalView.widthAnchor.constraint(equalToConstant: 285),
            modalView.heightAnchor.constraint(equalToConstant: 160),
            modalView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 19),
            titleLabel.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 121),
            confirmButton.widthAnchor.constraint(equalToConstant: 121),
            cancelButton.bottomAnchor.constraint(equalTo: modalView.bottomAnchor, constant: -15),
            confirmButton.bottomAnchor.constraint(equalTo: modalView.bottomAnchor, constant: -15),
            cancelButton.leftAnchor.constraint(equalTo: modalView.leftAnchor, constant: 17),
            confirmButton.rightAnchor.constraint(equalTo: modalView.rightAnchor, constant: -17)
        ])
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true)
    }
    
    @objc private func onTapCancelButton() {
        dismissModal()
    }
    
    @objc private func onTapConfirmButton() {
        dismissModal()
        delegate?.updateLogIn(isLogIn: true)
    }
    
}

protocol LogInDelegate {
    func updateLogIn(isLogIn: Bool)
}
