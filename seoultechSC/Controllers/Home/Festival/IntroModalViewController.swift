import UIKit

class IntroModalViewController: UIViewController {

    // MARK: - Properties
    private lazy var transparentButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    private let charactorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dream_charactor")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "message_container")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "축제 장소를 찾아가\n도장을 모아보세요!"
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textColor = .navy
        return label
    }()
    
    private let div1: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGrey
        return view
    }()
    
    private let div2: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGrey
        return view
    }()
    
    private let div3: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGrey
        return view
    }()
    
    private let element1: FestivalInfoElementView = {
        let view = FestivalInfoElementView(image: UIImage(named: "festival_pin")!, title: "축제 정보", subTitle: "위치 / 요금 / 축제일정")
        return view
    }()
    
    private let element2: FestivalInfoElementView = {
        let view = FestivalInfoElementView(image: UIImage(named: "festival_stamp")!, title: "도장 현황", subTitle: "지도에 표시된 5개의 장소에 방문하여\n마커를 클릭해보세요")
        return view
    }()
    
    private let element3: FestivalInfoElementView = {
        let view = FestivalInfoElementView(image: UIImage(named: "festival_food")!, title: "푸드트럭", subTitle: "푸드트럭 위치 / 업체")
        return view
    }()
    
    private let element4: FestivalInfoElementView = {
        let view = FestivalInfoElementView(image: UIImage(named: "festival_photo")!, title: "포토존", subTitle: "포토존 위치")
        return view
    }()
    
    private let modalView: UIView = {
        let view = UIView()
        view.configureModalView()
        return view
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        configureUI()
    }
    
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .clear
        
        view.addSubview(transparentButton)
        view.addSubview(modalView)
        modalView.addSubview(charactorImageView)
        modalView.addSubview(messageImageView)
        messageImageView.addSubview(messageLabel)
        modalView.addSubview(div1)
        modalView.addSubview(div2)
        modalView.addSubview(div3)
        modalView.addSubview(element1)
        modalView.addSubview(element2)
        modalView.addSubview(element3)
        modalView.addSubview(element4)
        
        modalView.translatesAutoresizingMaskIntoConstraints = false
        transparentButton.translatesAutoresizingMaskIntoConstraints = false
        charactorImageView.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        div1.translatesAutoresizingMaskIntoConstraints = false
        div2.translatesAutoresizingMaskIntoConstraints = false
        div3.translatesAutoresizingMaskIntoConstraints = false
        element1.translatesAutoresizingMaskIntoConstraints = false
        element2.translatesAutoresizingMaskIntoConstraints = false
        element3.translatesAutoresizingMaskIntoConstraints = false
        element4.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            transparentButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            transparentButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            transparentButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            transparentButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            modalView.widthAnchor.constraint(equalToConstant: 320),
            modalView.heightAnchor.constraint(equalToConstant: 444),
            modalView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            charactorImageView.widthAnchor.constraint(equalToConstant: 55),
            charactorImageView.heightAnchor.constraint(equalToConstant: 67),
            charactorImageView.leftAnchor.constraint(equalTo: modalView.leftAnchor, constant: 36),
            charactorImageView.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 25),
            messageImageView.widthAnchor.constraint(equalToConstant: 192),
            messageImageView.heightAnchor.constraint(equalToConstant: 58),
            messageImageView.leftAnchor.constraint(equalTo: charactorImageView.rightAnchor, constant: 0),
            messageImageView.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 23),
            messageLabel.centerXAnchor.constraint(equalTo: messageImageView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: messageImageView.centerYAnchor),
            element1.leftAnchor.constraint(equalTo: modalView.leftAnchor, constant: 21),
            element1.topAnchor.constraint(equalTo: charactorImageView.bottomAnchor, constant: 24),
            div1.heightAnchor.constraint(equalToConstant: 1),
            div1.leftAnchor.constraint(equalTo: modalView.leftAnchor, constant: 14),
            div1.rightAnchor.constraint(equalTo: modalView.rightAnchor, constant: -14),
            div1.topAnchor.constraint(equalTo: element1.bottomAnchor, constant: 10),
            element2.leftAnchor.constraint(equalTo: modalView.leftAnchor, constant: 21),
            element2.topAnchor.constraint(equalTo: div1.bottomAnchor, constant: 10),
            div2.heightAnchor.constraint(equalToConstant: 1),
            div2.leftAnchor.constraint(equalTo: modalView.leftAnchor, constant: 14),
            div2.rightAnchor.constraint(equalTo: modalView.rightAnchor, constant: -14),
            div2.topAnchor.constraint(equalTo: element2.bottomAnchor, constant: 10),
            element3.leftAnchor.constraint(equalTo: modalView.leftAnchor, constant: 21),
            element3.topAnchor.constraint(equalTo: div2.bottomAnchor, constant: 10),
            div3.heightAnchor.constraint(equalToConstant: 1),
            div3.leftAnchor.constraint(equalTo: modalView.leftAnchor, constant: 14),
            div3.rightAnchor.constraint(equalTo: modalView.rightAnchor, constant: -14),
            div3.topAnchor.constraint(equalTo: element3.bottomAnchor, constant: 10),
            element4.leftAnchor.constraint(equalTo: modalView.leftAnchor, constant: 21),
            element4.topAnchor.constraint(equalTo: div3.bottomAnchor, constant: 10),
        ])
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
}


class FestivalInfoElementView: UIView {
    
    init(image: UIImage, title: String, subTitle: String) {
        super.init(frame: .zero)
        self.widthAnchor.constraint(equalToConstant: 270).isActive = true
        self.heightAnchor.constraint(equalToConstant: 62).isActive = true
        
        let logoImage: UIImageView = {
            let imageView = UIImageView()
            imageView.image = image
            imageView.backgroundColor = .white
            imageView.contentMode = .scaleAspectFit
            imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            imageView.layer.cornerRadius = 15
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        let logo: UIView = {
            let logo = UIView()
            logo.widthAnchor.constraint(equalToConstant: 62).isActive = true
            logo.heightAnchor.constraint(equalToConstant: 62).isActive = true
            logo.backgroundColor = .white
            logo.layer.cornerRadius = 31
            logo.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            logo.layer.shadowOpacity = 1
            logo.layer.shadowOffset = CGSize.zero
            logo.layer.shadowRadius = 6
            logo.addSubview(logoImage)
            logoImage.centerXAnchor.constraint(equalTo: logo.centerXAnchor).isActive = true
            logoImage.centerYAnchor.constraint(equalTo: logo.centerYAnchor).isActive = true
            return logo
        }()
        
        let largeTitle: UILabel = {
            let label = UILabel()
            label.backgroundColor = .clear
            label.numberOfLines = 1
            label.text = title
            label.font = UIFont(name: "Pretendard-Bold", size: 16)
            label.textColor = .primaryPurple
            return label
        }()
        
        let desc: UILabel = {
            let label = UILabel()
            label.backgroundColor = .clear
            label.numberOfLines = 0
            label.text = subTitle
            label.font = UIFont(name: "Pretendard-Regular", size: 12)
            label.textColor = .black
            return label
        }()
        
        self.addSubview(logo)
        self.addSubview(largeTitle)
        self.addSubview(desc)
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        largeTitle.translatesAutoresizingMaskIntoConstraints = false
        desc.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logo.leftAnchor.constraint(equalTo: self.leftAnchor),
            logo.topAnchor.constraint(equalTo: self.topAnchor),
            largeTitle.leftAnchor.constraint(equalTo: logo.rightAnchor, constant: 15),
            largeTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            desc.leftAnchor.constraint(equalTo: logo.rightAnchor, constant: 15),
            desc.topAnchor.constraint(equalTo: largeTitle.bottomAnchor, constant: 6)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
