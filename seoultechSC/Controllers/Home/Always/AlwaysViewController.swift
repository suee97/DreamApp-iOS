import UIKit
import Alamofire

class AlwaysViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LogInDelegate {
    
    private var itemTitle = ["돗자리","간이테이블","듀라테이블","앰프&마이크","캐노피","리드선","L카","의자"]
    
    private var itemImageList : [UIImage] = [UIImage(named: "icon_mat")!, UIImage(named: "icon_mini_table")!, UIImage(named: "icon_dura_table")!, UIImage(named: "icon_amp")!, UIImage(named: "icon_canopy")!, UIImage(named: "icon_wire")!, UIImage(named: "icon_cart")!, UIImage(named: "icon_chair")!]
    
    private var itemDetailImageList : [UIImage] = [UIImage(named: "mat")!, UIImage(named: "mini_table")!, UIImage(named: "table")!, UIImage(named: "amp")!, UIImage(named: "canopy")!, UIImage(named: "wire")!, UIImage(named: "cart")!, UIImage(named: "chair")!]
    
    private var itemDescription = ["붕어방에서 피크닉 할 때 사용할 수 있습니다.","간이 테이블로 사용할 수 있습니다.","간이테이블 보다 좀 더 넓게 사용할 수 있습니다.","행사 시에 큰 음향을 낼 수 있습니다.","기둥과 천막으로 부스를 만들 수 있습니다.","콘센트를 연장하여 사용할 수 있습니다.","여러 짐을 한 번에 옮길 수 있습니다.","외부 행사 시에 간이 의자로 활용할 수 있습니다."]
    
    
    let imageList: [UIImage] = [UIImage(named: "dream_logo")!, UIImage(named: "dream_logo")!, UIImage(systemName: "person")!]
    private let scrollView : UIScrollView = UIScrollView()
    
    private let contentView : UIView = UIView()
    
    private lazy var myInfoContainer: UIView = {
        let container = UIView()
        
        let myImage : UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "person.crop.circle")
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .secondaryPurple
            
            return imageView
        }()
        
        let myName : UILabel = {
            let name = UILabel()
            name.text = signInUser.name
            name.font = UIFont(name: "Pretendard-Bold", size: 16)
            return name
        }()
        
        let myCode : UILabel = {
            let code = UILabel()
            code.text = signInUser.studentNo
            code.font = UIFont(name: "Pretendard-Regular", size: 12)
            return code
        }()
        
        let myGroup : UILabel = {
            let group = UILabel()
            group.text = findCollege(major: signInUser.department)
            group.font = UIFont(name: "Pretendard-Regular", size: 12)
            return group
        }()
        
        let myMajor : UILabel = {
            let major = UILabel()
            major.text = signInUser.department
            major.font = UIFont(name: "Pretendard-Regular", size: 12)
            return major
        }()
        
        container.addSubview(myImage)
        container.addSubview(myName)
        container.addSubview(myCode)
        container.addSubview(myGroup)
        container.addSubview(myMajor)
        
        container.layer.cornerRadius = 10
        
        myImage.translatesAutoresizingMaskIntoConstraints = false
        myName.translatesAutoresizingMaskIntoConstraints = false
        myCode.translatesAutoresizingMaskIntoConstraints = false
        myGroup.translatesAutoresizingMaskIntoConstraints = false
        myMajor.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myImage.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            myImage.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 18),
            myImage.widthAnchor.constraint(equalToConstant: 78),
            myImage.heightAnchor.constraint(equalToConstant: 78),
            
            myName.leadingAnchor.constraint(equalTo: myImage.trailingAnchor, constant: 17),
            myName.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            
            myCode.leadingAnchor.constraint(equalTo: myImage.trailingAnchor, constant: 17),
            myCode.topAnchor.constraint(equalTo: myName.bottomAnchor, constant: 13),
            
            myGroup.leadingAnchor.constraint(equalTo: myImage.trailingAnchor, constant: 17),
            myGroup.topAnchor.constraint(equalTo: myCode.bottomAnchor, constant: 4),
            
            myMajor.leadingAnchor.constraint(equalTo: myImage.trailingAnchor, constant: 17),
            myMajor.topAnchor.constraint(equalTo: myGroup.bottomAnchor, constant: 4),
        ])
        
        return container
    }()
    
    private let needLoginContainer: UIView = {
        let container = UIView()
        
        let myImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "person.crop.circle")
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .lightGrey
            return imageView
        }()
                
        let needLoginLabel: UILabel = {
            let label = UILabel()
            label.text = "로그인이 필요합니다."
            label.textColor = .black
            label.font = UIFont(name: "Pretendard-Bold", size: 16)
            return label
        }()
        
        let loginButton: ActionButton = {
            let button = ActionButton(title: "로그인 하기", height: 34)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 12)
            
            button.addTarget(self, action: #selector(goToLoginButton), for: .touchUpInside)
            return button
        }()
        
        container.addSubview(myImageView)
        container.addSubview(needLoginLabel)
        container.addSubview(loginButton)
        
        container.layer.cornerRadius = 10
        
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        needLoginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            myImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 18),
            myImageView.widthAnchor.constraint(equalToConstant: 78),
            myImageView.heightAnchor.constraint(equalToConstant: 78),
            needLoginLabel.leftAnchor.constraint(equalTo: myImageView.rightAnchor, constant: 17),
            needLoginLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 27),
            loginButton.widthAnchor.constraint(equalToConstant: 97),
            loginButton.leftAnchor.constraint(equalTo: myImageView.rightAnchor, constant: 18),
            loginButton.topAnchor.constraint(equalTo: needLoginLabel.bottomAnchor, constant: 10)
        ])
        
        return container
    }()
    
    private lazy var myReservationButton : ActionButton = {
        let myReservation = ActionButton(title: "내 예약 확인하기")
        myReservation.addTarget(self, action: #selector(myReservationBtn), for: .touchUpInside)
        
        return myReservation
    }()
    
    private lazy var collectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(AlwaysCollectionViewCell.self, forCellWithReuseIdentifier: AlwaysCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private let infoContainer : UIView = {
        let view = UIView()
        
        let title = UILabel()
        title.text = "안내사항"
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        title.textColor = .red
        
        view.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let info1 = UILabel()
        let info2 = UILabel()
        
        info1.text = "1. 대여 물품이 파손되었을 시, 수리 비용의 80%를 대여인(또는 대여 기구) 측에서 비용하고 나머지 20%는 총학생회 자치회비에서 부담한다."
        info2.text = "2. 파손에 대해 수리가 불가하다고 판단될 시, 대여인(또는 대여 기구)에서 같은 제품 또는 그에 걸맞는 비용을 부담하여야 한다."
        
        let labelArr: [UILabel] = [info1, info2]
        
        for i in labelArr {
            view.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
            i.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            i.font = UIFont(name: "Pretendard-Regular", size: 12)
            i.textColor = .navy
            i.numberOfLines = 3
            
            NSLayoutConstraint.activate([
                i.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                i.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            title.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            info1.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 7),
            info2.topAnchor.constraint(equalTo: info1.bottomAnchor, constant: 3),
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
        
        configureCollectionViewDelegate()
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
        
        self.navigationItem.title = "상시사업 예약"
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .backgroundPurple
        scrollView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        collectionView.backgroundColor = .clear
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(myReservationButton)
        contentView.addSubview(collectionView)
        contentView.addSubview(infoContainer)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        myReservationButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        infoContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            myReservationButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 141),
            myReservationButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            myReservationButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            collectionView.topAnchor.constraint(equalTo: myReservationButton.bottomAnchor, constant: 30),
            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: myReservationButton.bottomAnchor, constant: 240),
            infoContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            infoContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            infoContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            infoContainer.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 45),
        ])
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        
        if getLoginState() {
            contentView.addSubview(myInfoContainer)
            myInfoContainer.backgroundColor = .white
            myInfoContainer.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                myInfoContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                myInfoContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
                myInfoContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
                myInfoContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
                myInfoContainer.bottomAnchor.constraint(equalTo: myReservationButton.bottomAnchor),
            ])
            
            myReservationButton.setActive(true)
            
            contentView.bringSubviewToFront(myReservationButton)
            
        } else {
            contentView.addSubview(needLoginContainer)
            needLoginContainer.backgroundColor = .white
            needLoginContainer.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                needLoginContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
                needLoginContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
                needLoginContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
                needLoginContainer.bottomAnchor.constraint(equalTo: myReservationButton.bottomAnchor),
            ])
            
            myReservationButton.setActive(true)
            myReservationButton.setTitleColor(UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1), for: .normal)
            myReservationButton.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
            
            contentView.bringSubviewToFront(myReservationButton)
        }
        
    }
    
    private func findCollege(major: String) -> String {
        for i in 0..<collegeList.count {
            for j in 0..<majorList[i].count {
                if major == majorList[i][j] {
                    return collegeList[i]
                }
            }
        }
        return ""
    }
    
    private func configureCollectionViewDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // CollectionView Datasource
    
    // 셀 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemTitle.count
    }
    
    // 셀 지정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlwaysCollectionViewCell.identifier, for: indexPath) as! AlwaysCollectionViewCell
            
        cell.itemTitle.text = itemTitle[indexPath.row]
        cell.itemImageView.image = itemImageList[indexPath.row]
        
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        return cell
    }
    
    // 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 74, height: 100)
    }
    
    // 셀 선택
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AlwaysRentViewController()
        vc.item.text = itemTitle[indexPath.row]
        vc.itemImageView.image = itemDetailImageList[indexPath.row]
        vc.purpose.text = itemDescription[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Selectors
    @objc private func myReservationBtn() {
        let vc = MyRentViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func goToLoginButton() {
        let vc = LogInModalViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func updateLogIn(isLogIn: Bool) {
        if isLogIn {
            let vc = LoginViewController()
            setLoginState(false)
            let url = "\(api_url)/auth/logout"
            let aToken: String = KeychainHelper.sharedKeychain.getAccessToken() ?? ""
            let rToken: String = KeychainHelper.sharedKeychain.getRefreshToken() ?? ""
            let header: HTTPHeaders = [
                "Authorization": "Bearer \(aToken)",
                "refresh" : "Bearer \(rToken)"
            ]
            
            KeychainHelper.sharedKeychain.resetAccessRefreshToken()
            
            let request = AF.request(url,
                                     method: .get,
                                     parameters: nil,
                                     headers: header
            ).responseJSON { response in
                print("logout api call")
            }
            
            navigationController?.setViewControllers([vc], animated: true)
        }
    }
    
}
