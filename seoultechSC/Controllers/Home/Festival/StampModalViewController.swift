import UIKit
import Alamofire
import CoreLocation
import SnapKit

class StampModalViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Properties
    var stampName: String?
    private let circleRadius: CLLocationDistance = 50
    let locationManager = CLLocationManager()
    var curLocation: CLLocation?
    
    private lazy var backgroundButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .modalBackground
        button.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        return button
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .text_caption
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    private lazy var modalView: UIView = {
        let view = UIView()
        view.configureModalView()
        view.addSubview(indicator)
        indicator.snp.makeConstraints({ m in
            m.center.equalTo(view.snp.center)
        })
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "방문 도장 이벤트"
        label.textColor = .primaryPurple
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.sizeToFit()
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "도장 존에 들어오셨다면\n도장 찍기를 눌러주세요!"
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Regular", size: 15)
        label.sizeToFit()
        return label
    }()
    
    private lazy var stampImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "stamp_\(stampName!)_false_image")
        imageView.snp.makeConstraints({ m in
            m.width.height.equalTo(147)
        })
        return imageView
    }()
    
    private lazy var stampButton: ActionButton = {
        let button = ActionButton(title: "도장찍기!")
        button.snp.makeConstraints({ m in
            m.width.equalTo(250)
        })
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(onTapStampButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var stampView: UIView = {
        let view = UIView()
        view.configureModalView()
        
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
        view.addSubview(stampImageView)
        view.addSubview(stampButton)
        
        titleLabel.snp.makeConstraints({ m in
            m.centerX.equalTo(view.snp.centerX)
            m.top.equalTo(view.snp.top).offset(43)
        })
        contentLabel.snp.makeConstraints({ m in
            m.centerX.equalTo(view.snp.centerX)
            m.top.equalTo(titleLabel.snp.bottom).offset(10)
        })
        stampImageView.snp.makeConstraints({ m in
            m.centerX.equalTo(view.snp.centerX)
            m.top.equalTo(contentLabel.snp.bottom).offset(38)
        })
        stampButton.snp.makeConstraints({ m in
            m.centerX.equalTo(view.snp.centerX)
            m.top.equalTo(stampImageView.snp.bottom).offset(38)
        })
        
        return view
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        showStampStatus()
        configureLocationManager()
    }
    
    
    // MARK: - Helpers
    private func configureUI() {
        view.addSubview(backgroundButton)
        view.addSubview(modalView)
        
        backgroundButton.snp.makeConstraints({ m in
            m.left.right.top.bottom.equalTo(view)
        })
        modalView.snp.makeConstraints({ m in
            m.width.equalTo(320)
            m.height.equalTo(400)
            m.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
        })
    }
    
    private func showStampStatus() {
        let aToken = KeychainHelper.sharedKeychain.getAccessToken() ?? ""
        let url = "\(api_url)/stamp"
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(aToken)"
        ]
        
        AF.request(url, method: .get, headers: header).responseJSON { response in
            self.indicator.stopAnimating()
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(StampStatusResult.self, from: responseData)
                    if result.status == 200 {
                        let isStamp = self.getIsStampFromResult(result: result)
                        self.updateStampView(isStamp: isStamp)
                    } else if result.errorCode == "ST011" {
                        AuthHelper.shared.refreshAccessToken(completion: { result in
                            if result == .refreshed {
                                let aToken = KeychainHelper.sharedKeychain.getAccessToken() ?? ""
                                let url = "\(api_url)/stamp"
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
                                                let isStamp = self.getIsStampFromResult(result: result)
                                                self.updateStampView(isStamp: isStamp)
                                            } else {
                                                showToast(view: self.view, message: "오류가 발생했습니다.")
                                            }
                                        } catch {
                                            showToast(view: self.view, message: "오류가 발생했습니다.")
                                        }
                                    case .failure:
                                        showToast(view: self.view, message: "오류가 발생했습니다.")
                                    }
                                }
                            } else {
                                let vc = SelectLoginViewController()
                                showToast(view: vc.view, message: "로그인 세션이 만료되었습니다.")
                                self.navigationController?.setViewControllers([vc], animated: true)
                            }
                        })
                    } else {
                        showToast(view: self.view, message: "오류가 발생했습니다.")
                    }
                } catch {
                    showToast(view: self.view, message: "오류가 발생했습니다.")
                }
            case .failure:
                showToast(view: self.view, message: "오류가 발생했습니다.")
            }
        }
    }
    
    private func updateStampView(isStamp: Bool) {
        modalView.addSubview(stampView)
        stampView.snp.makeConstraints({ m in
            m.left.right.top.bottom.equalTo(modalView)
        })
        if isStamp {
            stampButton.setTitle("도장찍기 완료!", for: .normal)
            stampButton.setLoading(false)
            stampButton.setActive(true)
            stampButton.isEnabled = false
            stampImageView.image = UIImage(named: "stamp_\(stampName!)_true_image")
        }
    }
    
    @objc private func onTapStampButton() {
        stampButton.setLoading(true)
        
        let authStatus = locationManager.authorizationStatus
        switch authStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            break
        case .denied:
            showLocationPermissionDialog()
            stampButton.setLoading(false)
            return
        case .restricted, .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            stampButton.setLoading(false)
            return
        }
        
        let isCircleIn: Bool = checkIsInCircle()
        if isCircleIn == false {
            stampButton.setLoading(false)
            showToast(view: view, message: "원 안으로 들어와주세요!")
            return
        }
        
        postStamp(completion: { result in
            self.stampButton.setLoading(false)
            if result == .success {
                self.updateStampView(isStamp: true)
            } else if result == .expired {
                AuthHelper.shared.refreshAccessToken(completion: { result in
                    if result == .refreshed {
                        self.postStamp(completion: { result in
                            if result == .success {
                                self.updateStampView(isStamp: true)
                            } else {
                                showToast(view: self.view, message: "오류가 발생했습니다.")
                            }
                        })
                    } else {
                        showToast(view: self.view, message: "오류가 발생했습니다.")
                    }
                })
            } else {
                showToast(view: self.view, message: "오류가 발생했습니다.")
            }
        })
    }
    
    private func showLocationPermissionDialog() {
        let alert = UIAlertController(title: "위치에 대한 접근 권한이 없습니다.", message: "'설정 > 위치'에서 접근 권한을 활성화 해주세요.", preferredStyle: .alert)
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
    
    private func checkIsInCircle() -> Bool {
        var stampLatitude: CLLocationDegrees?
        var stampLongitude: CLLocationDegrees?
        for i in FestivalCommons.shared.stampList {
            if i.name == stampName {
                stampLatitude = i.location.latitude
                stampLongitude = i.location.longitude
                break
            }
        }
        let stampLocation = CLLocation(latitude: stampLatitude!, longitude: stampLongitude!)
        guard let distance = curLocation?.distance(from: stampLocation) else { return false }
        if distance <= circleRadius {
            return true
        } else {
            return false
        }
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        curLocation = CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    private func getIsStampFromResult(result: StampStatusResult) -> Bool {
        guard let data = result.data?[0] else { return false }
        guard let isStamp = stampName else { return false }
        switch isStamp {
        case "game":
            return data.game
        case "yard":
            return data.yard
        case "stage":
            return data.stage
        case "bungeobang":
            return data.bungeobang
        case "photo":
            return data.photo
        default:
            return false
        }
    }
    
    private func postStamp(completion: @escaping (PostStampResult) -> Void) {
        guard let stamp = stampName else { return }
        let url = "\(api_url)/stamp"
        let aToken = KeychainHelper.sharedKeychain.getAccessToken() ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(aToken)"
        ]
        let params = ["target" : stamp] as Dictionary
        
        AF.request(url, method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: header)
        .responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(PostStampStatus.self, from: responseData)
                    if result.status == 200 {
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

enum PostStampResult {
    case success
    case expired
    case fail
}
