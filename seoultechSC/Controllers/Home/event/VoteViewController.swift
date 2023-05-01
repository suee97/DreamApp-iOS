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
        indicator.layer.zPosition = 100
        indicator.startAnimating()
        return indicator
    }()
    
    private let foregroundLoadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
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
        view.addSubview(foregroundLoadingView)
        
        indicator.snp.makeConstraints({ m in
            m.left.right.top.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        foregroundLoadingView.snp.makeConstraints({ m in
            m.left.right.top.bottom.equalTo(view)
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
        changeVCState(state: .loading)
        
        let id = indexPath.row + 1
        
        if !getLoginState() {
            showToast(view: view, message: needLoginMessage)
            return
        }
        
        fetchSingleVote(voteId: id, completion: { result in
            self.changeVCState(state: .normal)
            switch result {
            case .before:
                showToast(view: self.view, message: "투표가 시작되지 않았습니다.")
            case .start:
                let vc = VoteDetailViewController()
                vc.voteId = id
                self.navigationController?.pushViewController(vc, animated: true)
            case .end:
                showToast(view: self.view, message: "마감된 투표입니다.")
            case .expired:
                AuthHelper.shared.refreshAccessToken(completion: { result in
                    switch result {
                    case .refreshed:
                        self.fetchSingleVote(voteId: id, completion: { result in
                            self.changeVCState(state: .normal)
                            switch result {
                            case .before:
                                showToast(view: self.view, message: "투표가 시작되지 않았습니다.")
                            case .start:
                                let vc = VoteDetailViewController()
                                vc.voteId = id
                                self.navigationController?.pushViewController(vc, animated: true)
                            case .end:
                                showToast(view: self.view, message: "마감된 투표입니다.")
                            case .fail:
                                showToast(view: self.view, message: "오류가 발생했습니다.")
                            case .expired:
                                showToast(view: self.view, message: "오류가 발생했습니다.")
                            }
                        })
                    case .fail:
                        showToast(view: self.view, message: "오류가 발생했습니다.")
                    }
                })
            case .fail:
                showToast(view: self.view, message: "오류가 발생했습니다.")
            }
        })
    }
    
    private func fetchSingleVote(voteId: Int, completion: @escaping (FetchSingleResult) -> Void) {
        let url = "\(api_url)/vote/\(voteId)"
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
                        if result.data![0].status == "START" {
                            completion(.start)
                            return
                        }
                        if result.data![0].status == "BEFORE" {
                            completion(.before)
                            return
                        }
                        if result.data![0].status == "END" {
                            completion(.end)
                            return
                        }
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
                                let vc = SelectLoginViewController()
                                self.indicator.stopAnimating()
                                showToast(view: vc.view, message: Commons.shared.sessionExpiredMessage)
                                self.navigationController?.setViewControllers([vc], animated: true)
                            }
                        })
                    case .fail:
                        showToast(view: self.view, message: "오류가 발생했습니다.")
                        self.indicator.stopAnimating()
                        print("fail1111")
                    }
                })
            case .fail:
                showToast(view: self.view, message: "오류가 발생했습니다.")
                self.indicator.stopAnimating()
                print("fail2222")
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
            print(response)
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(VoteListApiResult.self, from: responseData)
                    print(result.message)
                    if result.status == 200 {
                        for i in result.data! {
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
                    print("fail1")
                } catch {
                    completion(.fail)
                    print("fail2")
                }
            case .failure:
                completion(.fail)
                print("fail3")
            }
        }
    }
    
    private func changeVCState(state: VCState) {
        switch state {
        case .loading:
            indicator.startAnimating()
            voteCollectionView.isUserInteractionEnabled = false
//            foregroundLoadingView.backgroundColor = .text_caption.withAlphaComponent(0.1)
        case .normal:
            indicator.stopAnimating()
            voteCollectionView.isUserInteractionEnabled = true
            foregroundLoadingView.backgroundColor = .clear
        }
    }
    
    private enum FetchApiResult {
        case success
        case expired
        case fail
    }
    
    private enum FetchSingleResult {
        case expired
        case fail
        case before
        case start
        case end
    }
    
    private enum VCState {
        case loading
        case normal
    }
}
