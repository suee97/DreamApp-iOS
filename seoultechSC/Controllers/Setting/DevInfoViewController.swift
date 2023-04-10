import UIKit

class DevInfoViewController: UIViewController {
    
    private let logo : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dream_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let versionContainer : UIView = {
        let container = UIView()
        container.configureModalView()
        container.layer.shadowRadius = 3
        return container
    }()
    
    private let versionTitle : UILabel = {
        let versionTitle = UILabel()
        versionTitle.text = "어플리케이션 버전"
        versionTitle.font = UIFont(name: "Pretendard-Bold", size: 16)
        versionTitle.textColor = .black
        
        return versionTitle
    }()
    
    private let version : UILabel = {
        let version = UILabel()
        version.text = "1.1.0"
        version.font = UIFont(name: "Pretendard-Bold", size: 48)
        version.textColor = .black
        
        return version
    }()
    
    private let contactContainer : UIView = {
        let container = UIView()
        container.configureModalView()
        container.layer.shadowRadius = 3
        return container
    }()
    
    private let contactTitle : UILabel = {
        let contactTitle = UILabel()
        contactTitle.text = "개발 관련 문의"
        contactTitle.font = UIFont(name: "Pretendard-Bold", size: 16)
        contactTitle.textColor = .black
        
        return contactTitle
    }()
    
    private let contactEmail : UILabel = {
        let contactEmail = UILabel()
        contactEmail.text = "dev.seoultech@gmail.com"
        contactEmail.font = UIFont(name: "Pretendard-Regular", size: 15)
        contactEmail.textColor = .black
        
        return contactEmail
    }()
    
    private let devList : UIView = {
        let view = UIView()
        
        let serverAOS = UILabel()
        let iOSDesign = UILabel()
        
        let fontBold = UIFont.boldSystemFont(ofSize: 12)
        
        serverAOS.text = "서버 유서린 임새연 박준찬   안드로이드 채홍무 백송희"
        iOSDesign.text = "iOS 오승언 변상우   디자인 김태림"
        
        serverAOS.textColor = .text_caption
        iOSDesign.textColor = .text_caption
        
        serverAOS.font = UIFont(name: "Pretendard-Regular", size: 12)
        iOSDesign.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        let boldList = ["서버", "안드로이드","iOS", "디자인"]
        
        serverAOS.asFontBold(targetStringList: boldList, font: fontBold, color: .text_caption)
        iOSDesign.asFontBold(targetStringList: boldList, font: fontBold, color: .text_caption)
        
        let labelArr: [UILabel] = [serverAOS, iOSDesign]
        
        for i in labelArr {
            view.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
            i.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            serverAOS.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            iOSDesign.topAnchor.constraint(equalTo: serverAOS.bottomAnchor, constant: 10),
        ])
        
        return view
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
        
        self.navigationItem.title = "개발 관련 정보 및 문의"
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(logo)
        view.addSubview(versionContainer)
        view.addSubview(versionTitle)
        view.addSubview(version)
        view.addSubview(contactContainer)
        view.addSubview(contactTitle)
        view.addSubview(contactEmail)
        view.addSubview(devList)
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        versionContainer.translatesAutoresizingMaskIntoConstraints = false
        versionTitle.translatesAutoresizingMaskIntoConstraints = false
        version.translatesAutoresizingMaskIntoConstraints = false
        contactContainer.translatesAutoresizingMaskIntoConstraints = false
        contactTitle.translatesAutoresizingMaskIntoConstraints = false
        contactEmail.translatesAutoresizingMaskIntoConstraints = false
        devList.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logo.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 110),
            logo.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -110),
            versionContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            versionContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 239),
            versionContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            versionContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            versionContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 379),
            versionTitle.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            versionTitle.topAnchor.constraint(equalTo: versionContainer.topAnchor, constant: 30),
            versionTitle.bottomAnchor.constraint(equalTo: versionContainer.bottomAnchor, constant: -91),
            version.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            version.topAnchor.constraint(equalTo: versionContainer.topAnchor, constant: 52),
            version.bottomAnchor.constraint(equalTo: versionContainer.bottomAnchor, constant: -30),
            contactContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            contactContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 399),
            contactContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            contactContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            contactContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 489),
            contactTitle.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            contactTitle.topAnchor.constraint(equalTo: contactContainer.topAnchor, constant: 21),
            contactTitle.bottomAnchor.constraint(equalTo: contactContainer.bottomAnchor, constant: -50),
            contactEmail.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            contactEmail.topAnchor.constraint(equalTo: contactContainer.topAnchor, constant: 51),
            contactEmail.bottomAnchor.constraint(equalTo: contactContainer.bottomAnchor, constant: -19),
            devList.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            devList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            devList.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 43),
            devList.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -43),
        ])
        
    }

}
