import UIKit
import Alamofire

class EventViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Properties
    let LRSpacing: CGFloat = screenWidth * (20/360)
    let cellWidth: CGFloat = screenWidth * (155/360)
    let cellHeight: CGFloat = screenWidth * (155/360) * (220/155)
    
    var eventList: [EventWithImage] = []
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .text_caption
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    private let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let errorView: UIView = {
        let view = UIView()
        let logoImageView = UIImageView()
        let messageLabel = UILabel()
        
        messageLabel.text = "이벤트를 불러오지 못했습니다."
        messageLabel.font = UIFont(name: "Pretendard-Bold", size: 16)
        messageLabel.textColor = .primaryPurple
        logoImageView.image = UIImage(named: "dream_charactor")
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        view.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight * (172/640)),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: getRatWidth(81)),
            logoImageView.heightAnchor.constraint(equalToConstant: getRatWidth(97)),
            messageLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: screenHeight * (28/640)),
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.isHidden = true
        return view
    }()
    
    private let noEventView: UIView = {
        let view = UIView()
        let logoImageView = UIImageView()
        let messageLabel = UILabel()
        
        messageLabel.text = "진행중인 이벤트가 없습니다."
        messageLabel.font = UIFont(name: "Pretendard-Bold", size: 16)
        messageLabel.textColor = .primaryPurple
        logoImageView.image = UIImage(named: "dream_charactor")
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        view.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight * (172/640)),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: getRatWidth(81)),
            logoImageView.heightAnchor.constraint(equalToConstant: getRatWidth(97)),
            messageLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: screenHeight * (28/640)),
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.isHidden = true
        return view
    }()
    
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
        fetchEventList()
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
        view.addSubview(loadingView)
        view.addSubview(errorView)
        view.addSubview(noEventView)
        loadingView.addSubview(indicator)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        eventCollectionView.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false
        noEventView.translatesAutoresizingMaskIntoConstraints = false
        
        // indicator
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            eventCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: LRSpacing),
            eventCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -LRSpacing),
            eventCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight * (22/640)),
            eventCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            loadingView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            loadingView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            errorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            errorView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            errorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -22),
            noEventView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            noEventView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            noEventView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            noEventView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -22),
        ])
    }
    
    private func configureCollectionViewDelegate() {
        eventCollectionView.delegate = self
        eventCollectionView.dataSource = self
    }
    
    
    // MARK: - Selectors
    
    
    
    // MARK: - Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "event_collectionview_cell", for: indexPath) as! EventCollectionViewCell
        cell.imageView.image = eventList[indexPath.row].image
        cell.titleLabel.text = eventList[indexPath.row].title
        cell.startTimeLabel.text = getDateFromString(eventList[indexPath.row].startTime)
        cell.endTimeLabel.text = getDateFromString(eventList[indexPath.row].endTime)
        cell.status = eventList[indexPath.row].eventStatus
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = EventDetailViewController()
        vc.event = eventList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func fetchEventList() {
        let url = "\(api_url)/event"
        AF.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success:
                print("success")
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(EventsApiResult.self, from: responseData)
                    let dataCount = result.data?.count
                    if result.status == 200 && dataCount != 0 {
                        for event in result.data! {
                            guard let url = URL(string: event.imageUrl) else { return }
                            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                                guard let data = data, error == nil else { return }
                                DispatchQueue.main.async() {
                                    if let image = UIImage(data: data) {
                                        let status: EventStatus
                                        switch event.eventStatus {
                                        case "BEFORE":
                                            status = .BEFORE
                                        case "PROCEEDING":
                                            status = .PROCEEDING
                                        default: // END
                                            status = .END
                                        }
                                        self.eventList.append(EventWithImage(eventId: event.eventId, title: event.title, formLink: event.formLink, image: image, startTime: event.startTime, endTime: event.endTime, eventStatus: status))
                                    }
                                    
                                    if self.eventList.count == dataCount {
                                        self.sortEventList()
                                        self.eventCollectionView.reloadData()
                                        self.indicator.stopAnimating()
                                    }
                                }
                            }
                            task.resume()
                        }
                    } else if result.status == 200 && dataCount == 0 {
                        self.indicator.stopAnimating()
                        self.noEventView.isHidden = false
                    } else {
                        self.indicator.stopAnimating()
                        self.errorView.isHidden = false
                    }
                } catch {
                    self.indicator.stopAnimating()
                    self.errorView.isHidden = false
                }
            case .failure:
                self.indicator.stopAnimating()
                self.errorView.isHidden = false
            }
        }
        
    }
    
    private func getDateFromString(_ str: String) -> String {
        let arr = Array(str)
        return "\(arr[5])\(arr[6])/\(arr[8])\(arr[9])"
    }
    
    private func sortEventList() {
        var beforeArr: [EventWithImage] = []
        var proceedingArr: [EventWithImage] = []
        var endArr: [EventWithImage] = []
        
        for event in eventList {
            switch event.eventStatus {
            case .BEFORE:
                beforeArr.append(event)
            case .PROCEEDING:
                proceedingArr.append(event)
            case .END:
                endArr.append(event)
            }
        }
        
        beforeArr.sort(by: {
            return getIntFromTimeString($0.startTime) > getIntFromTimeString($1.startTime)
        })
        proceedingArr.sort(by: {
            return getIntFromTimeString($0.startTime) > getIntFromTimeString($1.startTime)
        })
        endArr.sort(by: {
            return getIntFromTimeString($0.startTime) > getIntFromTimeString($1.startTime)
        })
        
        eventList = proceedingArr + beforeArr + endArr
    }
    
    private func getIntFromTimeString(_ str: String) -> Int {
        let arr = Array(str)
        let stringValue = "\(arr[2])\(arr[3])\(arr[5])\(arr[6])\(arr[8])\(arr[9])"
        return Int(stringValue) ?? 0
    }
    
}

struct EventWithImage {
    let eventId: Int
    let title: String
    let formLink: String
    let image: UIImage
    let startTime: String
    let endTime: String
    let eventStatus: EventStatus
}
