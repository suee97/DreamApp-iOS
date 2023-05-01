import UIKit
import Alamofire
import SnapKit

class VoteDetailViewController: UIViewController {
    
    // MARK: - Properties
    var voteId: Int? {
        didSet {
            fetchVote(id: voteId!)
        }
    }
    var vote: Vote? {
        didSet {
            titleLabel.text = vote?.title
            descLabel.text = vote?.description
            
            elementContainer.snp.makeConstraints({ m in
                m.height.equalTo(CGFloat((vote?.voteOptionList.count)!) * getRatHeight(38) + getRatHeight(38))
            })
            
            for i in vote!.voteOptionList {
                let button = RadioButton()
                button.setTitle(i.optionTitle, for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
                button.addTarget(self, action: #selector(onTapRadioButton), for: .touchUpInside)
                elementButtonList.append(button)
            }
            
            for i in 0..<vote!.voteOptionList.count {
                elementContainer.addSubview(elementButtonList[i])
                elementButtonList[i].snp.makeConstraints({ m in
                    m.left.equalTo(elementContainer).inset(getRatWidth(26))
                    m.height.equalTo(getRatHeight(38))
                    m.top.equalTo(elementContainer).inset(getRatHeight(19) + CGFloat(i) * getRatHeight(38))
                })
            }
            
            if vote?.userSelectedOptionIds.count != 0 {
                voteButton.setActive(false)
                voteButton.setTitle("투표완료", for: .normal)
                for i in 0..<vote!.voteOptionList.count {
                    elementButtonList[i].setTitleColor(.text_caption, for: .normal)
                    elementButtonList[i].isEnabled = false
                    if vote!.userSelectedOptionIds.contains(vote!.voteOptionList[i].votingOptionId) {
                        elementButtonList[i].changeState()
                    }
                }
            }
        }
    }
    
    private var elementButtonList: [RadioButton] = []
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .text_caption
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = .clear
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textColor = .primaryPurple
        label.numberOfLines = 0
        return label
    }()
    
    private let purpleDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryPurple
        return view
    }()
    
    private let greyDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGrey
        return view
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = .text_caption
        label.numberOfLines = 0
        return label
    }()
    
    private let warningTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "주의사항"
        label.textColor = UIColor(red: 255/255, green: 56/255, blue: 69/255, alpha: 1)
        label.font = UIFont(name: "Pretendard-Bold", size: 12)
        return label
    }()
    
    private let warningContentLabel: UILabel = {
        let label = UILabel()
        label.text = "한 번 투표 시 수정이 불가능합니다."
        label.textColor = .text_caption
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        return label
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let elementContainer: UIView = {
        let view = UIView()
        view.configureModalView()
        return view
    }()
    
    private lazy var voteButton: ActionButton = {
        let button = ActionButton(title: "투표하기")
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(onTapVote), for: .touchUpInside)
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
        self.navigationItem.title = "이벤트 참여"
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .backgroundPurple
        
        view.addSubview(indicator)
        
        indicator.snp.makeConstraints({ m in
            m.left.right.bottom.top.equalTo(view.safeAreaLayoutGuide)
        })
    }
    
    private func configureVote() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(purpleDivider)
        container.addSubview(descLabel)
        container.addSubview(elementContainer)
        container.addSubview(greyDivider)
        container.addSubview(warningTitleLabel)
        container.addSubview(warningContentLabel)
        contentView.addSubview(voteButton)
        
        scrollView.snp.makeConstraints({ m in
            m.left.right.bottom.top.equalTo(view.safeAreaLayoutGuide)
        })
        
        contentView.snp.makeConstraints({ m in
            m.width.equalToSuperview()
            m.centerX.top.bottom.equalToSuperview()
        })
        
        container.snp.makeConstraints({ m in
            m.width.equalTo(getRatWidth(320))
            m.centerX.equalTo(contentView)
            m.top.equalTo(contentView).inset(getRatHeight(22))
            m.bottom.equalTo(warningContentLabel.snp.bottom).offset(getRatHeight(11))
        })
        
        titleLabel.snp.makeConstraints({ m in
            m.left.right.equalTo(container).inset(getRatWidth(19))
            m.height.equalTo(getRatHeight(38))
            m.top.equalTo(container).inset(getRatHeight(16))
        })
        
        purpleDivider.snp.makeConstraints({ m in
            m.left.right.equalTo(container).inset(getRatWidth(20))
            m.top.equalTo(titleLabel.snp.bottom).offset(getRatHeight(14))
            m.height.equalTo(1)
        })
        
        descLabel.snp.makeConstraints({ m in
            m.left.equalTo(container).inset(getRatWidth(21))
            m.right.equalTo(container).inset(getRatWidth(33))
            m.height.equalTo(getRatHeight(32))
            m.top.equalTo(purpleDivider.snp.bottom).offset(getRatHeight(14))
        })
        
        elementContainer.snp.makeConstraints({ m in
            m.left.right.equalTo(container).inset(getRatWidth(17))
            m.top.equalTo(descLabel.snp.bottom).offset(getRatHeight(18))
        })
        
        greyDivider.snp.makeConstraints({ m in
            m.left.right.equalTo(container).inset(getRatWidth(14))
            m.top.equalTo(elementContainer.snp.bottom).offset(getRatHeight(31))
            m.height.equalTo(1)
            m.height.equalTo(200)
        })
        
        warningTitleLabel.snp.makeConstraints({ m in
            m.left.equalTo(container).inset(getRatWidth(18))
            m.top.equalTo(greyDivider.snp.bottom).offset(getRatHeight(9))
        })
        
        warningContentLabel.snp.makeConstraints({ m in
            m.left.equalTo(container).inset(getRatWidth(18))
            m.top.equalTo(warningTitleLabel.snp.bottom).offset(getRatHeight(8))
        })
        
        voteButton.snp.makeConstraints({ m in
            m.left.right.equalTo(contentView).inset(getRatWidth(30))
            m.top.equalTo(container.snp.bottom).offset(getRatHeight(20))
            m.bottom.equalToSuperview().inset(8)
        })
    }
    
    @objc private func onTapVote() {
        voteButton.setLoading(true)
        let inputVotingId = vote!.votingId
        var inputVotingOptionIds: [Int] = []
        
        for i in 0..<vote!.voteOptionList.count {
            if elementButtonList[i].checked {
                inputVotingOptionIds.append(vote!.voteOptionList[i].votingOptionId)
            }
        }
        
        if inputVotingOptionIds.count < vote!.minSelect {
            showToast(view: view, message: "\(vote!.minSelect)개 이상 선택해주세요.")
            voteButton.setLoading(false)
            return
        }
        
        postVote(votingId: inputVotingId, votingOptionIds: inputVotingOptionIds, completion: { result in
            switch result {
            case .success:
                self.voteButton.setLoading(false)
                self.navigationController?.popViewController(animated: true)
            case .expired:
                AuthHelper.shared.refreshAccessToken(completion: { result in
                    switch result {
                    case .refreshed:
                        self.postVote(votingId: inputVotingId, votingOptionIds: inputVotingOptionIds, completion: { result in
                            if result == .success {
                                self.voteButton.setLoading(false)
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                showToast(view: self.view, message: "오류가 발생했습니다.")
                                self.voteButton.setLoading(false)
                            }
                        })
                    case .fail:
                        showToast(view: self.view, message: "오류가 발생했습니다.")
                        self.voteButton.setLoading(false)
                    }
                })
            case .fail:
                showToast(view: self.view, message: "오류가 발생했습니다.")
                self.voteButton.setLoading(false)
            }
        })
    }
    
    private func postVote(votingId: Int, votingOptionIds: [Int], completion: @escaping (PostApiResult) -> Void) {
        let url = "\(api_url)/vote"
        let aToken: String = KeychainHelper.sharedKeychain.getAccessToken() ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(aToken)",
            "Content-Type": "application/json"
        ]
        let params : [String: Any] = [
            "votingId" : votingId,
            "votingOptionIds" : votingOptionIds
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: header).responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(AuthApiResult.self, from: responseData)
                    if result.status == 201 {
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
    
    @objc private func onTapRadioButton(_ sender: Any) {
        for i in elementButtonList {
            if sender as! RadioButton == i {
                if i.checked {
                    i.changeState()
                    return
                }
            }
        }
        
        var checkCount = 0
        
        for i in elementButtonList {
            if i.checked {
                checkCount += 1
            }
        }
        
        if checkCount >= vote!.maxSelect {
            showToast(view: view, message: "\(vote!.maxSelect)개까지 선택이 가능합니다.")
        } else {
            for i in elementButtonList {
                if sender as! RadioButton == i {
                    i.changeState()
                }
            }
        }
    }
    
    private func fetchVote(id: Int) {
        let url = "\(api_url)/vote/\(id)"
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
                        self.indicator.stopAnimating()
                        self.vote = result.data![0]
                        self.configureVote()
                        return
                    }
                    self.indicator.stopAnimating()
                    showToast(view: self.view, message: "오류가 발생했습니다.")
                } catch {
                    self.indicator.stopAnimating()
                    showToast(view: self.view, message: "오류가 발생했습니다.")
                }
            case .failure:
                self.indicator.stopAnimating()
                showToast(view: self.view, message: "오류가 발생했습니다.")
            }
        }
    }
    
    private enum PostApiResult {
        case success
        case expired
        case fail
    }
}
