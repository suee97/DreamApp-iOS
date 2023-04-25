import UIKit
import SnapKit
import Alamofire

class FestivalInfoViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // MARK: - Properties
    private lazy var contentsViewController = ContentsViewController()
    private lazy var lineUpViewController = LineUpViewController()
    private lazy var dataViewControllers = [contentsViewController, lineUpViewController]
    var currentPage = 0

    lazy var contentsButton: InfoTabButton = {
        let button = InfoTabButton(title: "콘텐츠")
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(onTapContentsButton), for: .touchUpInside)
        return button
    }()
    
    lazy var lineUpButton: InfoTabButton = {
        let button = InfoTabButton(title: "라인업")
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(onTapLineUpButton), for: .touchUpInside)
        return button
    }()
    
    lazy var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        view.addSubview(contentsButton)
        view.addSubview(lineUpButton)
        contentsButton.snp.makeConstraints({ m in
            m.left.top.bottom.equalTo(view)
            m.width.equalTo(getRatWidth(160))
        })
        lineUpButton.snp.makeConstraints({ m in
            m.right.top.bottom.equalTo(view)
            m.width.equalTo(getRatWidth(160))
        })
        return view
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        vc.view.backgroundColor = .backgroundPurple
        return vc
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .text_caption
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureUI()
        fetchContentsLineUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentsButton.layer.clickedBorder()
        contentsButton.setTitlePrimary()
        changeButtonState(page: 0)
    }
    
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .backgroundPurple
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints({ m in
            m.centerX.centerY.equalTo(view)
        })
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        let na = customNavBarAppearance()
        self.navigationController?.navigationBar.scrollEdgeAppearance = na
        self.navigationController?.navigationBar.compactAppearance = na
        self.navigationController?.navigationBar.standardAppearance = na
        if #available(iOS 15.0, *) {
            navigationController?.navigationBar.compactScrollEdgeAppearance = na
        }
        
        self.navigationItem.title = "축제 정보"
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func showUI() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if let firstVC = dataViewControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        view.addSubview(navigationView)
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        navigationView.snp.makeConstraints { m in
            m.centerX.equalTo(view.safeAreaLayoutGuide)
            m.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            m.height.equalTo(52)
            m.width.equalTo(getRatWidth(320))
        }
        
        pageViewController.view.snp.makeConstraints { m in
            m.top.equalTo(navigationView.snp.bottom)
            m.bottom.equalToSuperview()
            m.left.right.equalTo(view).inset(getRatWidth(20))
            
        }
        pageViewController.didMove(toParent: self)
    }
    
    private func fetchContentsLineUp() {
        let url = "\(api_url)/booth"
        AF.request(url, method: .get).responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(BoothApiResult.self, from: responseData)
                    if result.status == 200 {
                        self.indicator.stopAnimating()
                        for i in 0..<result.data![0].boothList.count {
                            self.contentsViewController.contentsList[i].congestion = result.data![0].boothList[i].congestion
                        }
                        for i in result.data![0].lineUpList {
                            let dayArray = Array(i.lineUpDay)
                            let day = "\(dayArray[8])\(dayArray[9])"
                            if day == "10" {
                                self.lineUpViewController.lineUpList_5_10.append(i)
                            } else if day == "11" {
                                self.lineUpViewController.lineUpList_5_11.append(i)
                            } else if day == "12" {
                                self.lineUpViewController.lineUpList_5_12.append(i)
                            }
                        }
                        self.showUI()
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
        })
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return dataViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == dataViewControllers.count {
            return nil
        }
        
        return dataViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
            let currentVC = pageViewController.viewControllers!.first,
            let index = dataViewControllers.firstIndex(of: currentVC) else { return }
        currentPage = index
        changeButtonState(page: currentPage)
    }
    
    private func changeButtonState(page: Int) {
        if page == 0 {
            contentsButton.setTitlePrimary()
            contentsButton.layer.clickedBorder()
            lineUpButton.setTitleSecondary()
            lineUpButton.layer.nonClickedBorder()
            return
        }
        if page == 1 {
            contentsButton.setTitleSecondary()
            contentsButton.layer.nonClickedBorder()
            lineUpButton.setTitlePrimary()
            lineUpButton.layer.clickedBorder()
            return
        }
    }
    
    @objc private func onTapContentsButton() {
        changeButtonState(page: 0)
        pageViewController.setViewControllers([contentsViewController], direction: .reverse, animated: true)
    }
    
    @objc private func onTapLineUpButton() {
        changeButtonState(page: 1)
        pageViewController.setViewControllers([lineUpViewController], direction: .forward, animated: true)
    }
}
