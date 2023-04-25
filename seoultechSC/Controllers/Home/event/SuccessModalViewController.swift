import UIKit

class SuccessModalViewController: UIViewController {
    
    var delegate: SuccessDelegate?
    
    private let modalView: UIView = {
        let view = UIView()
        view.configureModalView()
        
        let label1 = UILabel()
        label1.text = "Mission Complete!"
        label1.textColor = .black
        label1.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        label1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label1)
        
        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            label1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "dream_charactor")
        image.contentMode = .scaleAspectFit
        
        return image
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
        modalView.addSubview(imageView)
        modalView.addSubview(confirmButton)
        
        modalView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            modalView.widthAnchor.constraint(equalToConstant: 285),
            modalView.heightAnchor.constraint(equalToConstant: 200),
            modalView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 55),
            imageView.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: modalView.centerYAnchor),
            
            confirmButton.widthAnchor.constraint(equalToConstant: 100),
            confirmButton.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            confirmButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 21)
        ])
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true)
    }
    
    @objc private func onTapConfirmButton() {
        dismissModal()
        delegate?.goEventList()
        
    }
    
}

protocol SuccessDelegate {
    func goEventList()
}
