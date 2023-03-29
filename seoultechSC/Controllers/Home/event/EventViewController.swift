import UIKit
import Alamofire

class EventViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var tmpEventList: [Event] = [
        Event(eventId: 1, title: "이벤트 항목 두줄까지?", formLink: "1", imageUrl: "2", startTime: "2022-07-04T22:23:21.15922", endTime: "2022-07-04T22:23:21.15922", eventStatus: "5"),
        Event(eventId: 2, title: "hello2", formLink: "1", imageUrl: "2", startTime: "2022-07-04T22:23:21.15922", endTime: "2022-08-01T22:23:21.15922", eventStatus: "5"),
        Event(eventId: 1, title: "이벤트 항목 두줄까지?이건두줄입니다", formLink: "1", imageUrl: "2", startTime: "2022-07-04T22:23:21.15922", endTime: "2022-07-04T22:23:21.15922", eventStatus: "5"),
        Event(eventId: 2, title: "hello2", formLink: "1", imageUrl: "2", startTime: "2022-07-04T22:23:21.15922", endTime: "2022-08-01T22:23:21.15922", eventStatus: "5"),
        Event(eventId: 1, title: "이벤트 항목 두줄까지?이건두줄인데 최대를초과합니다", formLink: "1", imageUrl: "2", startTime: "2022-07-04T22:23:21.15922", endTime: "2022-07-04T22:23:21.15922", eventStatus: "5"),
        Event(eventId: 2, title: "hello2", formLink: "1", imageUrl: "2", startTime: "2022-07-04T22:23:21.15922", endTime: "2022-08-01T22:23:21.15922", eventStatus: "5"),
        Event(eventId: 1, title: "이벤트 항목 두줄까지?", formLink: "1", imageUrl: "2", startTime: "2022-07-04T22:23:21.15922", endTime: "2022-07-04T22:23:21.15922", eventStatus: "5"),
        Event(eventId: 2, title: "hello2", formLink: "1", imageUrl: "2", startTime: "2022-07-04T22:23:21.15922", endTime: "2022-08-01T22:23:21.15922", eventStatus: "5"),
        Event(eventId: 1, title: "이벤트 항목 두줄까지?", formLink: "1", imageUrl: "2", startTime: "2022-07-04T22:23:21.15922", endTime: "2022-07-04T22:23:21.15922", eventStatus: "5"),
        Event(eventId: 2, title: "hello2", formLink: "1", imageUrl: "2", startTime: "2022-07-04T22:23:21.15922", endTime: "2022-08-01T22:23:21.15922", eventStatus: "5"),
        
    ]
    
    // MARK: - Properties
    let LRSpacing: CGFloat = screenWidth * (20/360)
    let cellWidth: CGFloat = screenWidth * (155/360)
    let cellHeight: CGFloat = screenWidth * (155/360) * (220/155)
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        return layout
    }()
    
    private lazy var eventCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: "event_collectionview_cell")
        collectionView.backgroundColor = .backgroundPurple
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionViewDelegate()
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
        
        self.navigationItem.title = "이벤트 참여"
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .backgroundPurple
        
        view.addSubview(eventCollectionView)
        
        eventCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            eventCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: LRSpacing),
            eventCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -LRSpacing),
            eventCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight * (22/640)),
            eventCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    private func configureCollectionViewDelegate() {
        eventCollectionView.delegate = self
        eventCollectionView.dataSource = self
    }
    
    
    // MARK: - Selectors
    
    
    
    // MARK: - Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "event_collectionview_cell", for: indexPath) as! EventCollectionViewCell
        cell.titleLabel.text = tmpEventList[indexPath.row].title
        cell.startTimeLabel.text = getDateFromString(tmpEventList[indexPath.row].startTime)
        cell.endTimeLabel.text = getDateFromString(tmpEventList[indexPath.row].endTime)
        return cell
    }
    
    private func getDateFromString(_ str: String) -> String {
        let arr = Array(str)
        return "\(arr[5])\(arr[6])/\(arr[8])\(arr[9])"
    }
}
