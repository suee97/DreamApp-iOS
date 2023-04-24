import UIKit
import Alamofire

class LogInModalViewController: UIViewController {
    
    var delegate: LogInDelegate?
    
    private let modalView: UIView = {
        let view = UIView()
        view.configureModalView()
        
        let label1 = UILabel()
        label1.text = "로그인 화면으로 이동합니다."
        label1.textColor = .black
        label1.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        label1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label1)
        
        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            label1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
        modalView.addSubview(cancelButton)
        modalView.addSubview(confirmButton)
        
        modalView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            modalView.widthAnchor.constraint(equalToConstant: 285),
            modalView.heightAnchor.constraint(equalToConstant: 160),
            modalView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 80),
            confirmButton.widthAnchor.constraint(equalToConstant: 162),
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
