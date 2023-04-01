import UIKit

class AlwaysViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var itemList = ["캐노피", "듀라테이블","앰프&마이크","리드선","L카","의자"]
    
    private let scrollView : UIScrollView = UIScrollView()
    
    private let contentView : UIView = UIView()
    
    private let myInfoContainer: UIView = {
        let container = UIView()
        
        let myImage = UIImageView(frame: CGRect(x: 18, y: 15, width: 78, height: 78))
        myImage.image = UIImage(systemName: "person")
        myImage.contentMode = .scaleAspectFit
        
        let myName = UILabel(frame: CGRect(x: 113, y: 16, width: 100, height: 19))
        myName.text = "이름"
        myName.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        let myCode = UILabel(frame: CGRect(x: 113, y: 48, width: 100, height: 16))
        myCode.text = "학번"
        myCode.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        let myGroup = UILabel(frame: CGRect(x: 113, y: 68, width: 100, height: 16))
        myGroup.text = "단과대학"
        myGroup.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        let myMajor = UILabel(frame: CGRect(x: 113, y: 88, width: 100, height: 16))
        myMajor.text = "학과"
        myMajor.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        container.addSubview(myImage)
        container.addSubview(myName)
        container.addSubview(myCode)
        container.addSubview(myGroup)
        container.addSubview(myMajor)
        
        container.layer.cornerRadius = 10
        
        return container
    }()
    
    private lazy var myReservationButton : ActionButton = {
        let myReservation = ActionButton(title: "내 예약 확인하기")
        myReservation.addTarget(self, action: #selector(myReservationBtn), for: .touchUpInside)
        
        return myReservation
    }()
    
    private let collectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let infoContainer : UIView = {
        let view = UIView()
        
        let title = UILabel()
        title.text = "안내사항"
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        
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
            i.textColor = .text_caption
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
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AlwaysCollectionViewCell.self, forCellWithReuseIdentifier: AlwaysCollectionViewCell.identifier)
        
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
        myInfoContainer.backgroundColor = .white
        collectionView.backgroundColor = .clear
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(myInfoContainer)
        contentView.addSubview(myReservationButton)
        contentView.addSubview(collectionView)
        contentView.addSubview(infoContainer)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        myInfoContainer.translatesAutoresizingMaskIntoConstraints = false
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
            myInfoContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            myInfoContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            myInfoContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            myInfoContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            myInfoContainer.bottomAnchor.constraint(equalTo: myReservationButton.bottomAnchor),
            myReservationButton.topAnchor.constraint(equalTo: myInfoContainer.topAnchor, constant: 119),
            myReservationButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            myReservationButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            collectionView.topAnchor.constraint(equalTo: myReservationButton.bottomAnchor, constant: 30),
            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -181),
            infoContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            infoContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            infoContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            infoContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -136),
        ])
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        
    }
    
    // CollectionView Datasource
    
    // 셀 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    // 셀 지정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlwaysCollectionViewCell.identifier, for: indexPath) as? AlwaysCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        return cell
    }
    
    // CollectionView DelegateFlowLayout
    
    // 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 74, height: 100)
    }
    
    

    
    // MARK: - Selectors
    @objc private func myReservationBtn() {
        print("MyReservation Confirm")
    }
}
