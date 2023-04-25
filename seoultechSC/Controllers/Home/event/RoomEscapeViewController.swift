import UIKit
import Alamofire

class RoomEscapeViewController: UIViewController, SuccessDelegate {
    
    private var currentRoomId : Int = 0
    private var currentImageUrl : String = ""
    private var quiz : [String] = []
    private var totalQuizCount = 8
    
    private var roomEscapeDataList: [RoomEscapeData] = []
    
    private lazy var totalProblem: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = .primaryPurple
        
        return label
    }()
    
    private lazy var progressBar: UIProgressView = {
       let progressBar = UIProgressView()
        progressBar.progressViewStyle = .default
        
        progressBar.progressTintColor = .primaryPurple
        progressBar.trackTintColor = .secondaryPurple
        progressBar.layer.cornerRadius = 20
        
        return progressBar
    }()
    
    let container: UIView = {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 10
        
        return container
    }()
    
    var problemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.image = UIImage(named: "dream_charactor")
        
        return imageView
    }()
    
    var answerSheet: UITextField = {
        let answer = UITextField()
        answer.layer.cornerRadius = 10
        answer.backgroundColor = .white
        answer.tintColor = .text_caption
        answer.textColor = .black
        answer.attributedPlaceholder = NSAttributedString(string: "정답을 입력하세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.text_caption ])
        answer.addLeftPadding()
        
        return answer
    }()
    
    private lazy var nextButton: ActionButton = {
        let button = ActionButton(title: "다음으로")
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(onTapNextButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        
        fetchCurrentRoomInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        fetchProblemInfo()
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
        
        let viewArr = [totalProblem, progressBar, problemImageView, container, problemImageView, answerSheet, nextButton]
        
        for i in viewArr {
            view.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            totalProblem.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 19),
            totalProblem.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            progressBar.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            progressBar.topAnchor.constraint(equalTo: totalProblem.bottomAnchor, constant: 1),
            progressBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            progressBar.heightAnchor.constraint(equalToConstant: 10),
            
            container.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            container.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 19),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            container.heightAnchor.constraint(equalToConstant: 340),
            
            problemImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            problemImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            problemImageView.widthAnchor.constraint(equalToConstant: 280),
            problemImageView.heightAnchor.constraint(equalToConstant: 280),
            
            answerSheet.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            answerSheet.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 20),
            answerSheet.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            answerSheet.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            answerSheet.heightAnchor.constraint(equalToConstant: 40),
            
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: answerSheet.bottomAnchor, constant: 38),
            nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
        ])
        
    }
    
    func goEventList() {
        guard let viewControllerStack = self.navigationController?.viewControllers else { return }
        for viewController in viewControllerStack {
            if let vc = viewController as? EventViewController {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
        
    }
    
    private func fetchProblemInfo() {
        fetchProblem(completion: { result in
            if result == .success {
                return
            } else if result == .expired {
                AuthHelper.shared.refreshAccessToken(completion: { result in
                    if result == .refreshed {
                        self.fetchProblem(completion: { result in
                            if result == .success {
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
    
    private func fetchProblem(completion: @escaping (RoomEscapeResult) -> Void) {
        let url = "\(api_url)/room-escapes"
        
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
                    let result = try decoder.decode(RoomEscapeApiResult.self, from: responseData)
                    let dataCount = result.data?.count
                    
                    if result.status == 200 && dataCount != 0 {
                        for room in result.data! {
                            self.roomEscapeDataList.append(RoomEscapeData(roomId: room.roomId, imageUrl: room.imageUrl))
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
    
    private func showProblem() {
        
        if (currentRoomId >= 8) {
            currentImageUrl = "https://devstartappbucket.s3.ap-northeast-2.amazonaws.com/app/foodtruck/22.jpg"
            
            totalProblem.text = "총 8문제 중 8문제"
            progressBar.progress = Float(8) / Float(8)
            
            guard let url = URL(string: currentImageUrl) else { return }
            problemImageView.load(url: url)
            
            let vc = SuccessModalViewController()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
            
        } else {
            totalQuizCount = roomEscapeDataList.count
            currentImageUrl = roomEscapeDataList[currentRoomId].imageUrl
            
            totalProblem.text = "총 \(totalQuizCount)문제 중 \(currentRoomId+1)문제"
            progressBar.progress = Float(currentRoomId+1) / Float(totalQuizCount)
            
            guard let url = URL(string: currentImageUrl) else { return }
            problemImageView.load(url: url)
        }
    }
    
    private func fetchCurrentRoomInfo() {
        fetchUserCurrentHistory(completion: { result in
            if result == .success {
                self.showProblem()
                return
            } else if result == .expired {
                AuthHelper.shared.refreshAccessToken(completion: { result in
                    if result == .refreshed {
                        self.fetchProblem(completion: { result in
                            if result == .success {
                                self.showProblem()
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
    
    private func fetchUserCurrentHistory(completion: @escaping (RoomEscapeResult) -> Void) {
        let url = "\(api_url)/room-escapes/history"
        
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
                    let result = try decoder.decode(RoomEscapeHistoryApiResult.self, from: responseData)
                    
                    if result.status == 200 {
                        self.currentRoomId = result.data![0].roomId
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
    
    
    private func PostAnswerRequest(completion: @escaping (RoomEscapeResult) -> Void) {
        let url = "\(api_url)/room-escapes/answer"
        
        let aToken = KeychainHelper.sharedKeychain.getAccessToken() ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(aToken)"
        ]
        
        let params = ["roomId" : currentRoomId + 1,
                      "answer" : answerSheet.text!] as Dictionary
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: header)
        .responseJSON { response in
            switch response.result {
            case.success:
                print(self.currentRoomId + 1)
                print(self.answerSheet.text!)
                do {
                    print(response)
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(RoomEscapeAnswerApiResult.self, from: responseData)
                    if result.status == 200 && result.data![0].answer == true {
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
                print("failure")
                completion(.fail)
            }
        }
    }
    
    private func checkAnswer() {
        
    }
    
    @objc func onTapNextButton() {
        PostAnswerRequest(completion: {result in
            if result == .success {
                showToast(view: self.view, message: "정답입니다")
                self.currentRoomId += 1
                self.showProblem()
                
                return
                
            } else if result == .expired {
                AuthHelper.shared.refreshAccessToken(completion: {result in
                    if result == .refreshed {
                        self.PostAnswerRequest(completion: { result in
                            if result == .success {
                                showToast(view: self.view, message: "정답입니다")
                                self.currentRoomId += 1
                                self.showProblem()
                                
                                return
                                
                            } else {
                                showToast(view: self.view, message: "토큰 재발급 오류 발생")
                            }
                        })
                    } else {
                        
                    }
                })
            } else {
                showToast(view: self.view, message: "정답이 아닙니다.")
            }
        })
    }
}

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 21, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
      }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

struct RoomEscapeData {
    let roomId: Int
    let imageUrl: String
}

struct RoomIdData {
    let roomId: Int
}

enum RoomEscapeResult {
    case success
    case expired
    case fail
}
