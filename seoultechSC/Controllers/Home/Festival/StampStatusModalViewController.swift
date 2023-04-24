import UIKit
import SnapKit
import Alamofire

class StampStatusModalViewController: UIViewController {

    private var stampStatusList: [String : Bool] = [
        "game": false,
        "yard": false,
        "bungeobang": false,
        "photo": false,
        "stage": false
    ]
    
    private lazy var backgroundButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .modalBackground
        button.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        return button
    }()
    
    private let modalView: UIView = {
        let view = UIView()
        view.configureModalView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "방문 도장 이벤트 현황"
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "5개의 도장을 모두 모은 후\n상품 교환소에 가서 복권을\n받고 상품을 수령하세요!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Regular", size: 15)
        return label
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .text_caption
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    private let bungeobangImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints({ m in
            m.height.width.equalTo(80)
        })
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints({ m in
            m.height.width.equalTo(80)
        })
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints({ m in
            m.height.width.equalTo(80)
        })
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let yardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints({ m in
            m.height.width.equalTo(80)
        })
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let stageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints({ m in
            m.height.width.equalTo(80)
        })
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureModalView()
    }
    
    private func configureUI() {
        view.addSubview(backgroundButton)
        view.addSubview(modalView)
        modalView.addSubview(indicator)
        
        backgroundButton.snp.makeConstraints({ m in
            m.left.right.top.bottom.equalTo(view)
        })
        modalView.snp.makeConstraints({ m in
            m.centerX.centerY.equalTo(view)
            m.width.equalTo(320)
            m.height.equalTo(350)
        })
        indicator.snp.makeConstraints({ m in
            m.centerX.centerY.equalTo(modalView)
        })
    }
    
    private func configureModalView() {
        fetchStampStatus(completion: { result in
            if result == .success {
                self.indicator.stopAnimating()
                self.drawModalView()
            } else if result == .expired {
                AuthHelper.shared.refreshAccessToken(completion: { result in
                    if result == .refreshed {
                        self.fetchStampStatus(completion: { result in
                            if result == .success {
                                self.indicator.stopAnimating()
                                self.drawModalView()
                            } else {
                                showToast(view: self.view, message: "오류가 발생했습니다.")
                            }
                        })
                    } else {
                        showToast(view: self.view, message: "오류가 발생했습니다.")
                    }
                })
            } else { // result == .fail
                showToast(view: self.view, message: "오류가 발생했습니다.")
            }
        })
    }
    
    private func drawModalView() {
        bungeobangImageView.image = stampStatusList["bungeobang"]! ? UIImage(named: "stamp_bungeobang_true_image") : UIImage(named: "stamp_bungeobang_false_image")
        photoImageView.image = stampStatusList["photo"]! ? UIImage(named: "stamp_photo_true_image") : UIImage(named: "stamp_photo_false_image")
        gameImageView.image = stampStatusList["game"]! ? UIImage(named: "stamp_game_true_image") : UIImage(named: "stamp_game_false_image")
        yardImageView.image = stampStatusList["yard"]! ? UIImage(named: "stamp_yard_true_image") : UIImage(named: "stamp_yard_false_image")
        stageImageView.image = stampStatusList["stage"]! ? UIImage(named: "stamp_stage_true_image") : UIImage(named: "stamp_stage_false_image")
        
        modalView.addSubview(titleLabel)
        modalView.addSubview(contentLabel)
        modalView.addSubview(bungeobangImageView)
        modalView.addSubview(photoImageView)
        modalView.addSubview(gameImageView)
        modalView.addSubview(yardImageView)
        modalView.addSubview(stageImageView)
        
        titleLabel.snp.makeConstraints({ m in
            m.centerX.equalTo(modalView)
            m.top.equalTo(modalView.snp.top).inset(25)
        })
        bungeobangImageView.snp.makeConstraints({ m in
            m.left.equalTo(modalView.snp.left).inset(25)
            m.top.equalTo(titleLabel.snp.bottom).offset(36)
        })
        photoImageView.snp.makeConstraints({ m in
            m.left.equalTo(bungeobangImageView.snp.right).offset(15)
            m.top.equalTo(titleLabel.snp.bottom).offset(36)
        })
        gameImageView.snp.makeConstraints({ m in
            m.left.equalTo(photoImageView.snp.right).offset(15)
            m.top.equalTo(titleLabel.snp.bottom).offset(36)
        })
        yardImageView.snp.makeConstraints({ m in
            m.left.equalTo(modalView.snp.left).inset(72)
            m.top.equalTo(gameImageView.snp.bottom).offset(11)
        })
        stageImageView.snp.makeConstraints({ m in
            m.left.equalTo(yardImageView.snp.right).offset(15)
            m.top.equalTo(gameImageView.snp.bottom).offset(11)
        })
        contentLabel.snp.makeConstraints({ m in
            m.centerX.equalTo(modalView)
            m.bottom.equalTo(modalView.snp.bottom).inset(25)
        })
        
    }
    
    private func fetchStampStatus(completion: @escaping (PostStampResult) -> Void) {
        let url = "\(api_url)/stamp"
        let aToken = KeychainHelper.sharedKeychain.getAccessToken() ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(aToken)"
        ]
        
        AF.request(url, method: .get, headers: header).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(StampStatusResult.self, from: responseData)
                    if result.status == 200 {
                        self.stampStatusList["game"] = result.data![0].game
                        self.stampStatusList["yard"] = result.data![0].yard
                        self.stampStatusList["stage"] = result.data![0].stage
                        self.stampStatusList["bungeobang"] = result.data![0].bungeobang
                        self.stampStatusList["photo"] = result.data![0].photo
                        completion(.success)
                        return
                    }
                    if result.errorCode == "ST011" {
                        completion(.expired)
                        return
                    }
                    completion(.fail)
                } catch {
                    completion(.fail)
                }
            case .failure:
                completion(.fail)
            }
        }
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true)
    }
}

