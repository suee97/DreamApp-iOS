import UIKit
import GoogleMaps
import CoreLocation

class FestivalViewController: UIViewController, GMSMapViewDelegate {
    
    // MARK: - Properties
    let locationManager = CLLocationManager()
    private var mapView: GMSMapView!
    private let zoomLevel: Float = 16
    
    private lazy var pinFloatingButton: festivalFloatingButton = {
        let button = festivalFloatingButton(image: UIImage(named: "festival_pin")!)
        button.addTarget(self, action: #selector(onTapPinFloatingButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var stampFloatingButton: festivalFloatingButton = {
        let button = festivalFloatingButton(image: UIImage(named: "festival_stamp")!)
        button.addTarget(self, action: #selector(onTapStampFloatingButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var foodFloatingButton: festivalFloatingButton = {
        let button = festivalFloatingButton(image: UIImage(named: "festival_food")!)
        button.addTarget(self, action: #selector(onTapFoodFloatingButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var photoFloatingButton: festivalFloatingButton = {
        let button = festivalFloatingButton(image: UIImage(named: "festival_photo")!)
        button.addTarget(self, action: #selector(onTapPhotoFloatingButton), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    override func loadView() {
        configureMap()
        setUpMarkers()
        setUpCircles()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        openInfoModal()
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
        
        self.navigationItem.title = "어의대동제"
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(pinFloatingButton)
        view.addSubview(stampFloatingButton)
        view.addSubview(foodFloatingButton)
        view.addSubview(photoFloatingButton)
        
        pinFloatingButton.translatesAutoresizingMaskIntoConstraints = false
        stampFloatingButton.translatesAutoresizingMaskIntoConstraints = false
        foodFloatingButton.translatesAutoresizingMaskIntoConstraints = false
        photoFloatingButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pinFloatingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            pinFloatingButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            stampFloatingButton.topAnchor.constraint(equalTo: pinFloatingButton.bottomAnchor, constant: 10),
            stampFloatingButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            foodFloatingButton.topAnchor.constraint(equalTo: stampFloatingButton.bottomAnchor, constant: 10),
            foodFloatingButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            photoFloatingButton.topAnchor.constraint(equalTo: foodFloatingButton.bottomAnchor, constant: 10),
            photoFloatingButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
        ])
    }
    
    private func openInfoModal() {
        let vc = IntroModalViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    private func configureMap() {
        let camera:GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 37.6316684, longitude: 127.0774813, zoom: zoomLevel)
        mapView = GMSMapView(frame: .zero, camera: camera)

        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
        self.view = mapView
        mapView.delegate = self
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        checkLocationPermissionAndOpenDialog()
        return false
    }
    
    private func setUpMarkers() {
        for i in FestivalCommons.shared.stampList {
            let marker = GMSMarker(position: i.location)
            marker.title = i.name
            marker.icon = UIImage(named: "stamp_marker")
            marker.map = mapView
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let currentZoomLevel = mapView.camera.zoom
        let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: currentZoomLevel)
        mapView.animate(to: camera)
        
        if getLoginState() == false {
            showToast(view: view, message: "로그인이 필요한 기능입니다. '홈 > 설정'에서 로그인해주세요.")
            return true
        }
        
        let vc = StampModalViewController()
        vc.stampName = marker.title
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        
        return true
    }
    
    private func setUpCircles() {
        let strokeColor = UIColor(red: 39/255, green: 205/255, blue: 123/255, alpha: 1)
        
        for i in FestivalCommons.shared.stampList {
            let circle = GMSCircle(position: i.location, radius: 50)
            circle.strokeColor = strokeColor
            circle.strokeWidth = 1
            circle.fillColor = strokeColor.withAlphaComponent(0.2)
            circle.map = mapView
        }
    }

    private func checkLocationPermissionAndOpenDialog() {
        let authStatus = locationManager.authorizationStatus
        switch authStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            break
        case .denied:
            showLocationPermissionDialog()
        case .restricted, .notDetermined:
            print("restriced, notdeT~")
            locationManager.requestWhenInUseAuthorization()
        }
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
    
    @objc func onTapPinFloatingButton() {
        let vc = FestivalInfoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func onTapStampFloatingButton() {
        if getLoginState() == false {
            showToast(view: view, message: "로그인이 필요한 기능입니다. '홈 > 설정'에서 로그인해주세요.")
            return
        }
        
        let vc = StampStatusModalViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func onTapFoodFloatingButton() {
        let vc = FoodTruckModalViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func onTapPhotoFloatingButton() {
        let vc = PhotoZoneModalViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
}

class festivalFloatingButton: UIButton {
    init(image: UIImage) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3
        self.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let imageView = UIImageView(image: image)
        imageView.widthAnchor.constraint(equalToConstant: 21).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 21).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
