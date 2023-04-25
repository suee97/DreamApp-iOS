import UIKit
import Alamofire

class WithdrawalModalViewController: UIViewController {
    
    var delegate: WithdrawalDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원탈퇴"
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        return label
    }()
    
    private let modalView: UIView = {
        let view = UIView()
        view.configureModalView()
        
        let label1 = UILabel()
        label1.text = "회원탈퇴 시 재가입이 어려울 수 있습니다."
        label1.textColor = .text_caption
        label1.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        let label2 = UILabel()
        label2.text = "(문의: 02-970-7012)"
        label2.textColor = .text_caption
        label2.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        let label3 = UILabel()
        label3.text = "탈퇴하시려면 '탈퇴' 버튼을 눌러주세요"
        label3.textColor = .text_caption
        label3.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        label3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        
        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: view.topAnchor, constant: 48),
            label1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 3),
            label2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 3),
            label3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        return view
    }()
    
    private lazy var withdrawalButton: ActionButton = {
        let button = ActionButton(title: "탈퇴", backgroundColor: .secondaryPurple, height: 34)
        button.addTarget(self, action: #selector(onTapWithdrawalButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: ActionButton = {
        let button = ActionButton(title: "취소", height: 34)
        button.addTarget(self, action: #selector(onTapCancelButton), for: .touchUpInside)
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
        modalView.addSubview(withdrawalButton)
        modalView.addSubview(cancelButton)
        
        modalView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        withdrawalButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            modalView.widthAnchor.constraint(equalToConstant: 285),
            modalView.heightAnchor.constraint(equalToConstant: 160),
            modalView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 19),
            titleLabel.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            withdrawalButton.widthAnchor.constraint(equalToConstant: 121),
            cancelButton.widthAnchor.constraint(equalToConstant: 121),
            withdrawalButton.bottomAnchor.constraint(equalTo: modalView.bottomAnchor, constant: -15),
            cancelButton.bottomAnchor.constraint(equalTo: modalView.bottomAnchor, constant: -15),
            withdrawalButton.leftAnchor.constraint(equalTo: modalView.leftAnchor, constant: 17),
            cancelButton.rightAnchor.constraint(equalTo: modalView.rightAnchor, constant: -17)
        ])
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true)
    }
    
    @objc private func onTapWithdrawalButton() {
        dismissModal()
        delegate?.withdrawal(isLogout: true)
    }
    
    @objc private func onTapCancelButton() {
        dismissModal()
    }
    
}

protocol WithdrawalDelegate {
    func withdrawal(isLogout: Bool)
}
