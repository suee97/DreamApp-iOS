import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private let imageScrollViewWidth: CGFloat = screenWidth * (254/360)
    private let tabWidth: CGFloat = screenWidth * (100/360)
    private let tabHeight: CGFloat = screenHeight * (100/640)
    private let tabWidthSpacing: CGFloat = screenWidth * (10/360)
    private let tabHeightSpacing: CGFloat = screenHeight * (10/640)
    
    private lazy var settingButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "carbon_settings"), style: .plain, target: self, action: #selector(onTapSettingButton))
        return button
    }()
    
    private let imageScrollViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .clear
        scrollView.delegate = self
        return scrollView
    }()
    
    private let imagePageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.backgroundColor = .clear
        pageControl.pageIndicatorTintColor = .secondaryPurple
        pageControl.currentPageIndicatorTintColor = .primaryPurple
        pageControl.hidesForSinglePage = false
        return pageControl
    }()

    private let tabContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var infoTab: HomeTabButton = {
        let button = HomeTabButton(icon: "🏫", title: "총학생회 설명")
        button.layer.maskedCorners = [.layerMinXMinYCorner]
        button.addTarget(self, action: #selector(onTapInfoTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var allianceTab: HomeTabButton = {
        let button = HomeTabButton(icon: "🤝🏻", title: "제휴사업")
        button.addTarget(self, action: #selector(onTapAllianceTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var duesTab: UIButton = {
        let button = UIButton()
        button.layer.maskedCorners = [.layerMaxXMinYCorner]
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 4
        button.layer.cornerRadius = 20
        
        let iconLabel = UILabel()
        let label1 = UILabel()
        let label2 = UILabel()
        
        iconLabel.text = "💳"
        label1.text = "자치회비"
        label2.text = "납부 확인"
        
        iconLabel.font = UIFont(name: "Pretendard-Bold", size: 25)
        label1.font = UIFont(name: "Pretendard-Regular", size: 12)
        label1.textColor = .black
        label2.font = UIFont(name: "Pretendard-Regular", size: 12)
        label2.textColor = .black
        
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(iconLabel)
        button.addSubview(label1)
        button.addSubview(label2)
        
        NSLayoutConstraint.activate([
            iconLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            label1.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            label2.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            iconLabel.topAnchor.constraint(equalTo: button.topAnchor, constant: screenHeight * (26/640)),
            label1.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: screenHeight * (9/640)),
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 0)
        ])
        
        button.addTarget(self, action: #selector(onTapDuesTap), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var alwaysTab: HomeTabButton = {
        let button = HomeTabButton(icon: "📌", title: "상시사업 예약")
        button.layer.maskedCorners = [.layerMinXMaxYCorner]
        button.addTarget(self, action: #selector(onTapAlwaysTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var festivalTab: HomeTabButton = {
        let button = HomeTabButton(icon: "🎟️", title: "어의대동제")
        button.addTarget(self, action: #selector(onTapFestivalTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var eventTab: HomeTabButton = {
        let button = HomeTabButton(icon: "🎁", title: "이벤트 참여")
        button.layer.maskedCorners = [.layerMaxXMaxYCorner]
        button.addTarget(self, action: #selector(onTapEventTap), for: .touchUpInside)
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
        self.navigationController?.navigationBar.isHidden = false
        let na = customNavBarAppearance()
        self.navigationController?.navigationBar.scrollEdgeAppearance = na
        self.navigationController?.navigationBar.compactAppearance = na
        self.navigationController?.navigationBar.standardAppearance = na
        if #available(iOS 15.0, *) {
            navigationController?.navigationBar.compactScrollEdgeAppearance = na
        }
        
        self.navigationItem.title = "서울과학기술대학교 총학생회"
        self.navigationItem.setRightBarButton(settingButton, animated: true)
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        setUpInitImageScrollView()
        configureImageScrollView()
        
        view.backgroundColor = .white
        
        view.addSubview(imageScrollViewContainer)
        view.addSubview(tabContainer)
        imageScrollViewContainer.addSubview(imageScrollView)
        imageScrollViewContainer.addSubview(imagePageControl)
        tabContainer.addSubview(infoTab)
        tabContainer.addSubview(allianceTab)
        tabContainer.addSubview(duesTab)
        tabContainer.addSubview(alwaysTab)
        tabContainer.addSubview(festivalTab)
        tabContainer.addSubview(eventTab)
        
        imageScrollViewContainer.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        tabContainer.translatesAutoresizingMaskIntoConstraints = false
        imagePageControl.translatesAutoresizingMaskIntoConstraints = false
        infoTab.translatesAutoresizingMaskIntoConstraints = false
        allianceTab.translatesAutoresizingMaskIntoConstraints = false
        duesTab.translatesAutoresizingMaskIntoConstraints = false
        alwaysTab.translatesAutoresizingMaskIntoConstraints = false
        festivalTab.translatesAutoresizingMaskIntoConstraints = false
        eventTab.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageScrollViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight * (22/640)),
            imageScrollViewContainer.widthAnchor.constraint(equalToConstant: imageScrollViewWidth),
            imageScrollViewContainer.heightAnchor.constraint(equalToConstant: screenHeight * (254/640) + 22),
            imageScrollViewContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabContainer.topAnchor.constraint(equalTo: imageScrollViewContainer.bottomAnchor, constant: screenHeight * (31/640)),
            tabContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabContainer.widthAnchor.constraint(equalToConstant: screenWidth * (320/360)),
            tabContainer.heightAnchor.constraint(equalToConstant: screenHeight * (210/640)),
            imageScrollView.leftAnchor.constraint(equalTo: imageScrollViewContainer.leftAnchor, constant: 0),
            imageScrollView.rightAnchor.constraint(equalTo: imageScrollViewContainer.rightAnchor, constant: 0),
            imageScrollView.topAnchor.constraint(equalTo: imageScrollViewContainer.topAnchor, constant: 0),
            imageScrollView.bottomAnchor.constraint(equalTo: imageScrollViewContainer.bottomAnchor, constant: 0),
            imagePageControl.centerXAnchor.constraint(equalTo: imageScrollView.centerXAnchor),
            imagePageControl.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: 0),
            infoTab.widthAnchor.constraint(equalToConstant: tabWidth),
            infoTab.heightAnchor.constraint(equalToConstant: tabHeight),
            infoTab.leftAnchor.constraint(equalTo: tabContainer.leftAnchor, constant: 0),
            infoTab.topAnchor.constraint(equalTo: tabContainer.topAnchor, constant: 0),
            allianceTab.leftAnchor.constraint(equalTo: infoTab.rightAnchor, constant: tabWidthSpacing),
            allianceTab.topAnchor.constraint(equalTo: tabContainer.topAnchor, constant: 0),
            allianceTab.widthAnchor.constraint(equalToConstant: tabWidth),
            allianceTab.heightAnchor.constraint(equalToConstant: tabHeight),
            duesTab.widthAnchor.constraint(equalToConstant: tabWidth),
            duesTab.heightAnchor.constraint(equalToConstant: tabHeight),
            duesTab.topAnchor.constraint(equalTo: tabContainer.topAnchor, constant: 0),
            duesTab.leftAnchor.constraint(equalTo: allianceTab.rightAnchor, constant: tabWidthSpacing),
            alwaysTab.widthAnchor.constraint(equalToConstant: tabWidth),
            alwaysTab.heightAnchor.constraint(equalToConstant: tabHeight),
            alwaysTab.topAnchor.constraint(equalTo: infoTab.bottomAnchor, constant: tabHeightSpacing),
            alwaysTab.leftAnchor.constraint(equalTo: tabContainer.leftAnchor, constant: 0),
            festivalTab.widthAnchor.constraint(equalToConstant: tabWidth),
            festivalTab.heightAnchor.constraint(equalToConstant: tabHeight),
            festivalTab.topAnchor.constraint(equalTo: allianceTab.bottomAnchor, constant: tabHeightSpacing),
            festivalTab.leftAnchor.constraint(equalTo: alwaysTab.rightAnchor, constant: tabWidthSpacing),
            eventTab.widthAnchor.constraint(equalToConstant: tabWidth),
            eventTab.heightAnchor.constraint(equalToConstant: tabHeight),
            eventTab.leftAnchor.constraint(equalTo: festivalTab.rightAnchor, constant: tabWidthSpacing),
            eventTab.topAnchor.constraint(equalTo: duesTab.bottomAnchor, constant: tabHeightSpacing)
        ])
    }
    
    private func configureImageScrollView() {
        // TODO: 예외처리, 이미지 개수 없을 때 처리, 다운로드 중 로딩 처리
        var imageList: [UIImage] = []
        
        let url = api_url + "/banner"
        
        let request = AF.request(url, method: .get, parameters: nil)
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let decoder = JSONDecoder()
                        guard let responseData = response.data else { return }
                        let result = try decoder.decode(Banners.self, from: responseData)
                        let dataCount = result.data.count
                        if result.status == 200 && dataCount != 0 {
                            for banner in result.data {
                                guard let url = URL(string: banner.imageUrl) else { return }

                                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                                    guard let data = data, error == nil else { return }
                                    DispatchQueue.main.async() {
                                        if let image = UIImage(data: data) {
                                            imageList.append(image)
                                        }
                                        
                                        if imageList.count == dataCount {
                                            self.setUpImageScrollView(imageList)
                                        }
                                    }
                                }
                                task.resume()
                            }
                            
                        } else if result.status == 200 && dataCount == 0 {
                            guard let tmpImage = UIImage(named: "dream_logo") else { return }
                            let tmpImageList: [UIImage] = [tmpImage]
                            self.setUpImageScrollView(tmpImageList)
                        } else {
                            guard let tmpImage = UIImage(named: "dream_logo") else { return }
                            let tmpImageList: [UIImage] = [tmpImage]
                            self.setUpImageScrollView(tmpImageList)
                        }
                    } catch {
                        guard let tmpImage = UIImage(named: "dream_logo") else { return }
                        let tmpImageList: [UIImage] = [tmpImage]
                        self.setUpImageScrollView(tmpImageList)
                    }
                case .failure:
                    guard let tmpImage = UIImage(named: "dream_logo") else { return }
                    let tmpImageList: [UIImage] = [tmpImage]
                    self.setUpImageScrollView(tmpImageList)
                }
            }
    }
    
    
    // MARK: - Selectors
    @objc private func onTapSettingButton() {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func onTapInfoTap() {
        let vc = InfoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func onTapAllianceTap() {
        showToast(view: view, message: "준비중입니다.")
    }
    
    @objc private func onTapDuesTap() {
        if !getLoginState() {
            showToast(view: view, message: needLoginMessage)
        } else {
            let vc = DuesViewController()
            vc.user = signInUser
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func onTapAlwaysTap() {
        let vc = AlwaysViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func onTapFestivalTap() {
        let url = "\(api_url)/festival"
        AF.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(AuthApiResult.self, from: responseData)
                    if result.status == 200 {
                        let vc = FestivalViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                        return
                    }
                    // not 200
                    showToast(view: self.view, message: "축제 기간이 아니거나 오류가 발생했습니다.\n장애가 계속될 시 문의해주세요. (02-970-7012)")
                } catch {
                    showToast(view: self.view, message: "오류가 발생했습니다.")
                }
            case .failure:
                showToast(view: self.view, message: "오류가 발생했습니다.")
            }
        }
    }
    
    @objc private func onTapEventTap() {
        let vc = EventViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setUpImageScrollView(_ imageList: [UIImage]) {
        // Setup imageScrollView
        for i in 0..<imageList.count {
            let imageView = UIImageView(image: imageList[i])
            let xPos: CGFloat = imageScrollViewWidth * CGFloat(i)
            imageView.frame = CGRect(x: xPos,
                                     y: 0,
                                     width: imageScrollViewWidth,
                                     height: imageScrollViewWidth)
            
            imageView.backgroundColor = .clear
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
            
            imageScrollView.addSubview(imageView)
            
            imageScrollView.contentSize.width = imageScrollViewWidth * CGFloat(i + 1)
            
            imageView.isUserInteractionEnabled = true
            let gesture = CustomTapGesture(target: self, action: #selector(onTapImage))
            gesture.image = imageList[i]
            imageView.addGestureRecognizer(gesture)
        }
        
        // Setup imagePageControl
        imagePageControl.numberOfPages = imageList.count
    }
    
    private func setUpInitImageScrollView() {
        // Setup initial imageScrollView
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageScrollViewWidth, height: imageScrollViewWidth))
        imageView.addSubview(indicator)
        imageView.backgroundColor = .clear
        indicator.center = imageView.center
        indicator.startAnimating()
        
        imageScrollView.addSubview(imageView)
        
        // Setup initial imagePageControl
        imagePageControl.numberOfPages = 1
    }
    
    @objc private func onTapImage(recognizer: CustomTapGesture) {
        let vc = ZoomImageViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.image = recognizer.image
        self.present(vc, animated: true, completion: nil)
    }

}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        imagePageControl.currentPage = Int(round(imageScrollView.contentOffset.x / imageScrollViewWidth))
    }
}

class HomeTabButton: UIButton {
    init(icon: String, title: String) {
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3
        
        if icon != "🤝🏻" && icon != "🎟️" {
            self.layer.cornerRadius = 20
        }
        
        let logoIconLabel = UILabel()
        let logoText = UILabel()
        
        logoIconLabel.text = icon
        logoText.text = title
        
        logoIconLabel.font = UIFont(name: "Pretendard-Bold", size: 25)
        logoText.font = UIFont(name: "Pretendard-Regular", size: 12)
        logoText.textColor = .black
        
        logoIconLabel.translatesAutoresizingMaskIntoConstraints = false
        logoText.translatesAutoresizingMaskIntoConstraints = false
         
        self.addSubview(logoIconLabel)
        self.addSubview(logoText)
        
        NSLayoutConstraint.activate([
            logoIconLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoText.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoIconLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: screenHeight * (26/640)),
            logoText.topAnchor.constraint(equalTo: logoIconLabel.bottomAnchor, constant: screenHeight * (9/640))
        ])
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
