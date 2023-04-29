import UIKit
import Alamofire
import SnapKit

class VoteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Properties
    private var voteList: [Vote] = []
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .text_caption
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: getRatWidth(320), height: getRatHeight(100))
        return layout
    }()
    
    private lazy var voteCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(VoteCell.self, forCellWithReuseIdentifier: "vote_cell")
        collectionView.backgroundColor = .clear
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
        configureDelegate()
        showVoteList()
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
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints({ m in
            m.left.right.top.bottom.equalTo(view.safeAreaLayoutGuide)
        })
    }
    
    private func configureCollectionView() {
        view.addSubview(voteCollectionView)
        
        voteCollectionView.snp.makeConstraints({ m in
            m.left.right.equalTo(view)
            m.top.equalTo(view.safeAreaLayoutGuide).inset(getRatHeight(22))
            m.bottom.equalTo(view.safeAreaLayoutGuide).inset(getRatHeight(22))
        })
    }
    
    private func configureDelegate() {
        voteCollectionView.delegate = self
        voteCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return voteList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vote_cell", for: indexPath) as! VoteCell
        cell.vote = voteList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
    }
    
    private func showVoteList() {
        fetchVoteList(completion: { result in
            switch result {
            case .success:
                self.configureCollectionView()
                self.indicator.stopAnimating()
            case .expired:
                AuthHelper.shared.refreshAccessToken(completion: { result in
                    switch result {
                    case .refreshed:
                        self.fetchVoteList(completion: { secondResult in
                            if secondResult == .success {
                                self.configureCollectionView()
                                self.indicator.stopAnimating()
                            } else {
                                showToast(view: self.view, message: "오류가 발생했습니다.")
                                self.indicator.stopAnimating()
                            }
                        })
                    case .fail:
                        showToast(view: self.view, message: "오류가 발생했습니다.")
                        self.indicator.stopAnimating()
                    }
                })
            case .fail:
                showToast(view: self.view, message: "오류가 발생했습니다.")
                self.indicator.stopAnimating()
            }
        })
    }
    
    private func fetchVoteList(completion: @escaping (FetchApiResult) -> Void) {
        let url = "\(api_url)/vote"
        let aToken: String = KeychainHelper.sharedKeychain.getAccessToken() ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(aToken)"
        ]
        
        AF.request(url, method: .get, headers: header).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(VoteListApiResult.self, from: responseData)
                    if result.status == 200 {
                        for i in result.data {
                            self.voteList.append(i)
                        }
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
    
    private enum FetchApiResult {
        case success
        case expired
        case fail
    }
}
