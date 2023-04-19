import UIKit
import GoogleMaps

class FestivalViewController: UIViewController, GMSMapViewDelegate {
    
    // MARK: - Properties
    private var mapView: GMSMapView!
    
    
    // MARK: - Lifecycle
    override func loadView() {
        configureMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
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
        
        let vc = IntroModalViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    private func configureMap() {
        // Load the map at set latitude/longitude and zoom level
        let camera:GMSCameraPosition = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 11)
        
        mapView = GMSMapView(frame: .zero, camera: camera)
        self.view = mapView
        mapView.delegate = self
    }
}
