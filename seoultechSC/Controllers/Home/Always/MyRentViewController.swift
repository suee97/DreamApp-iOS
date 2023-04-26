import UIKit
import Alamofire

class MyRentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var myRentDataList: [MyRentData] = []
    
    private var noneRentContainer : UIView = {
        let container = UIView()
        container.layer.cornerRadius = 10
        container.backgroundColor = .white
        
        let image = UIImageView()
        image.image = UIImage(named: "dream_logo")
        image.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.text = "예약 중인 물품이 없습니다"
        label.textColor = .primaryPurple
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        container.addSubview(image)
        container.addSubview(label)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -80),
            image.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 90),
            image.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -90),
            
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        
        ])
        
        return container
    }()
    
    private var tableView : UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    

    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        
        fetchMyRentInfo()
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
        
        self.navigationItem.title = "내 예약"
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .backgroundPurple
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myRentDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyRentTableViewCell.identifier, for: indexPath) as! MyRentTableViewCell
        
        cell.itemTitle.text = changeCategory(category: myRentDataList[indexPath.row].itemCategory)
        cell.amount.text = String(myRentDataList[indexPath.row].account)
        cell.range.text = myRentDataList[indexPath.row].startTime + " ~ " + myRentDataList[indexPath.row].endTime.suffix(5)
        cell.rentStatusLabel.text = changeRentStatus(status: myRentDataList[indexPath.row].rentStatus)
        var currentColor = changeRentColor(status: myRentDataList[indexPath.row].rentStatus)
        cell.circleContainer.backgroundColor = UIColor(red: currentColor[0], green: currentColor[1], blue: currentColor[2], alpha: 1)
        
        return cell
    }
    
    private func checkMyRentInfo() {
        if self.myRentDataList.count == 0 {
            view.addSubview(noneRentContainer)
            noneRentContainer.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                noneRentContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                noneRentContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                noneRentContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                noneRentContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            ])
        } else {
            tableView.register(MyRentTableViewCell.self, forCellReuseIdentifier: MyRentTableViewCell.identifier)
            tableView.delegate = self
            tableView.dataSource = self
            
            view.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.layer.cornerRadius = 10
            tableView.backgroundColor = .clear
            tableView.rowHeight = 115
            tableView.separatorStyle = .none
            tableView.allowsSelection = false
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            ])
        }
    }
    
    private func fetchMyRentInfo() {
        
        fetchMyRent(completion: { result in
            if result == .success {
                self.checkMyRentInfo()
                self.tableView.reloadData()
                return
            } else if result == .expired {
                AuthHelper.shared.refreshAccessToken(completion: { result in
                    if result == .refreshed {
                        self.fetchMyRent(completion: { result in
                            if result == .success {
                                self.checkMyRentInfo()
                                self.tableView.reloadData()
                                return
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
    
    private func fetchMyRent(completion: @escaping (MyRentResult) -> Void) {
        let url = "\(api_url)/rent"
        
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
                    let result = try decoder.decode(MyRentDataApiResult.self, from: responseData)
                    let dataCount = result.data?.count
                    
                    if result.status == 200 {
                        for rent in result.data! {
                            self.myRentDataList.append(MyRentData(rentId: rent.rentId, account: rent.account, purpose: rent.purpose, rentStatus: rent.rentStatus, itemCategory: rent.itemCategory, startTime: rent.startTime, endTime: rent.endTime, createdAt: rent.createdAt, updatedAt: rent.updatedAt))
                        }
                        completion(.success)
                        return
                        
                    } else if result.errorCode == "ST011" {
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
    
    private func changeCategory(category: String) -> String {
        var eng_Catgory = category
        var kor_Category = ""
        switch eng_Catgory {
        case "MAT" :
            kor_Category = "돗자리"
        case "S_TABLE" :
            kor_Category = "간이테이블"
        case "TABLE" :
            kor_Category = "듀라테이블"
        case "AMP" :
            kor_Category = "앰프&마이크"
        case "CANOPY" :
            kor_Category = "캐노피"
        case "WIRE" :
            kor_Category = "리드선"
        case "CART" :
            kor_Category = "L카"
        case "CHAIR" :
            kor_Category = "의자"
        default:
            print("")
        }
        return kor_Category
    }
    
    private func changeRentStatus(status: String) -> String {
        var status = status
        var currentStatus = ""
        switch status {
        case "CONFIRM" :
            currentStatus = "승인"
        case "RENT" :
            currentStatus = "대여중"
        case "DONE" :
            currentStatus = "반납완료"
        case "DENY" :
            currentStatus = "거절"
        case "WAIT" :
            currentStatus = "승인대기"
        default:
            print("")
        }
        return currentStatus
    }
    
    private func changeRentColor(status: String) -> [Double] {
        var circle : [Double] = []
        var status = status
        switch status {
        case "CONFIRM" :
            circle = [0.154, 0.804, 0.482]
        case "RENT" :
            circle = [0.486, 0.529, 0.949]
        case "DONE" :
            circle = [0.592, 0.592, 0.592]
        case "DENY" :
            circle = [1, 0.22, 0.271]
        case "WAIT" :
            circle = [0.746, 0.772, 1]
        default:
            print("")
        }
        return circle
    }

}

struct MyRentData {
    let rentId: Int
    let account: Int
    let purpose: String
    let rentStatus: String
    let itemCategory: String
    let startTime: String
    let endTime: String
    let createdAt: String
    let updatedAt: String
}

enum MyRentResult {
    case success
    case expired
    case fail
}
