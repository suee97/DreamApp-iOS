import UIKit

class InfoViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // MARK: - Properties
    private let imageScrollViewWidth: CGFloat = screenWidth * (254/360)
    private let tabWidth: CGFloat = screenWidth * (107/360)
    private let tabHeight: CGFloat = screenHeight * (30/640)
    private let tabWidthSpacing: CGFloat = 0
    private let tabHeightSpacing: CGFloat = screenHeight * (10/640)
    
    private var currentPage = 0
    
    private let tabButtonContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var info1Button: InfoTabButton = {
        let button = InfoTabButton(title: "총학생회란?")
        button.addTarget(self, action: #selector(onTapInfo1), for: .touchUpInside)
        return button
    }()
    
    private lazy var info2Button: InfoTabButton = {
        let button = InfoTabButton(title: "FAQ")
        button.addTarget(self, action: #selector(onTapInfo2), for: .touchUpInside)
        return button
    }()
    
    private lazy var info3Button: InfoTabButton = {
        let button = InfoTabButton(title: "학생회 구성/기능")
        button.addTarget(self, action: #selector(onTapInfo3), for: .touchUpInside)
        return button
    }()
    
    private lazy var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white

        return view
    }()
    
    private lazy var vc1: UIViewController = {
        let vc = WhatIsSCViewController()
        return vc
    }()

    private lazy var vc2: UIViewController = {
        let vc = FAQViewController()
        return vc
    }()

    private lazy var vc3: UIViewController = {
        let vc = SCFeatureViewController()
        return vc
    }()
    
    private lazy var viewsList: [UIViewController] = {
        return [vc1, vc2, vc3]
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return vc
    }()
    

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        info1Button.layer.clickedBorder()
        info2Button.layer.nonClickedBorder()
        info3Button.layer.nonClickedBorder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if let firstVC = viewsList.first {
                    pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
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
        
        self.navigationItem.title = "총학생회 설명"
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        addChild(pageViewController)
        tabButtonContainer.addSubview(info1Button)
        tabButtonContainer.addSubview(info2Button)
        tabButtonContainer.addSubview(info3Button)
        view.addSubview(tabButtonContainer)
        view.addSubview(pageViewController.view)
        info1Button.setTitlePrimary()
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        tabButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        info1Button.translatesAutoresizingMaskIntoConstraints = false
        info2Button.translatesAutoresizingMaskIntoConstraints = false
        info3Button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tabButtonContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight * (22/640)),
            tabButtonContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabButtonContainer.widthAnchor.constraint(equalToConstant: screenWidth * (320/360)),
            tabButtonContainer.heightAnchor.constraint(equalToConstant: tabHeight),
            pageViewController.view.topAnchor.constraint(equalTo: tabButtonContainer.bottomAnchor, constant: screenHeight * (19/640)),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            pageViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageViewController.view.widthAnchor.constraint(equalToConstant: screenWidth * (320/360)),
            info1Button.widthAnchor.constraint(equalToConstant: tabWidth),
            info1Button.heightAnchor.constraint(equalToConstant: tabHeight),
            info1Button.leftAnchor.constraint(equalTo: tabButtonContainer.leftAnchor, constant: 0),
            info1Button.topAnchor.constraint(equalTo: tabButtonContainer.topAnchor, constant: 0),
            info2Button.leftAnchor.constraint(equalTo: info1Button.rightAnchor, constant: tabWidthSpacing),
            info2Button.topAnchor.constraint(equalTo: tabButtonContainer.topAnchor, constant: 0),
            info2Button.widthAnchor.constraint(equalToConstant: tabWidth),
            info2Button.heightAnchor.constraint(equalToConstant: tabHeight),
            info3Button.widthAnchor.constraint(equalToConstant: tabWidth),
            info3Button.heightAnchor.constraint(equalToConstant: tabHeight),
            info3Button.topAnchor.constraint(equalTo: tabButtonContainer.topAnchor, constant: 0),
            info3Button.leftAnchor.constraint(equalTo: info2Button.rightAnchor, constant: tabWidthSpacing),
        ])
        
    }
    
    private func changeCurrentPage(index: Int) {
        if index == 0 {
            info1Button.layer.clickedBorder()
            info2Button.layer.nonClickedBorder()
            info3Button.layer.nonClickedBorder()
            pageViewController.setViewControllers([vc1], direction: .reverse, animated: true, completion: nil)
            info1Button.setTitlePrimary()
            info2Button.setTitleSecondary()
            info3Button.setTitleSecondary()
        } else if index == 1 {
            info1Button.layer.nonClickedBorder()
            info2Button.layer.clickedBorder()
            info3Button.layer.nonClickedBorder()
            pageViewController.setViewControllers([vc2], direction: .forward, animated: true, completion: nil)
            info1Button.setTitleSecondary()
            info2Button.setTitlePrimary()
            info3Button.setTitleSecondary()
        } else if index == 2 {
            info1Button.layer.nonClickedBorder()
            info2Button.layer.nonClickedBorder()
            info3Button.layer.clickedBorder()
            pageViewController.setViewControllers([vc3], direction: .forward, animated: true, completion: nil)
            info1Button.setTitleSecondary()
            info2Button.setTitleSecondary()
            info3Button.setTitlePrimary()
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewsList.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return viewsList[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewsList.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == viewsList.count {
            return nil
        }
        return viewsList[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
            let currentVC = pageViewController.viewControllers!.first,
            let index = viewsList.firstIndex(of: currentVC) else { return }
        
        currentPage = index
        
        changeCurrentPage(index: currentPage)
        
    }
    
    func enabledBtn() {
        if currentPage == 0 {
            info1Button.isEnabled = false
        } else if currentPage == 2 {
            info3Button.isEnabled = false
        } else {
            info1Button.isEnabled = true
            info2Button.isEnabled = true
            info3Button.isEnabled = true
        }
    }
    
    func prevAction(_ sender: Any) {
        // 지금 페이지 - 1
        let prevPage = currentPage - 1
        //화면 이동 (지금 페이지에서 -1 페이지로 setView 합니다.)
        pageViewController.setViewControllers([viewsList[prevPage]], direction: .reverse, animated: true)
        
        //현재 페이지 잡아주기
        currentPage = pageViewController.viewControllers!.first!.view.tag
        enabledBtn()
    }
    
    func nextAction(_ sender: Any) {
        // 지금 페이지 + 1
        let nextPage = currentPage + 1
        //화면 이동 (지금 페이지에서 -1 페이지로 setView 합니다.)
        pageViewController.setViewControllers([viewsList[nextPage]], direction: .forward, animated: true)
        
        //현재 페이지 잡아주기
        currentPage = pageViewController.viewControllers!.first!.view.tag
        enabledBtn()
    }

    
    // MARK: - Selectors
    @objc private func onTapInfo1() {
        changeCurrentPage(index: 0)
    }
    
    @objc private func onTapInfo2() {
        changeCurrentPage(index: 1)
    }
    
    @objc private func onTapInfo3() {
        changeCurrentPage(index: 2)
    }

}

class InfoTabButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(.secondaryPurple, for: .normal)
        self.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 16)
//        let logoText = UILabel()
//
//        logoText.text = title
//        logoText.font = UIFont(name: "Pretendard-Bold", size: 16)
//        logoText.textColor = .primaryPurple
//        logoText.translatesAutoresizingMaskIntoConstraints = false
//
//        self.addSubview(logoText)
//        logoText.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        logoText.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func setTitlePrimary() {
        self.setTitleColor(.primaryPurple, for: .normal)
    }
    
    func setTitleSecondary() {
        self.setTitleColor(.secondaryPurple, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CALayer {
    func clickedBorder() {
        let border = CALayer()
        border.frame = CGRect.init(x: 0, y: frame.height - 5, width: frame.width, height: 5)
        border.backgroundColor = UIColor.primaryPurple.cgColor
        
        self.addSublayer(border)
    }
    
    func nonClickedBorder() {
        let border = CALayer()
        border.frame = CGRect.init(x: 0, y: frame.height - 3, width: frame.width, height: 3)
        border.backgroundColor = UIColor.secondaryPurple.cgColor
        
        let border2 = CALayer()
        border2.frame = CGRect.init(x: 0, y: frame.height - 5, width: frame.width, height: 5)
        border2.backgroundColor = UIColor.white.cgColor
        
        self.addSublayer(border2)
        self.addSublayer(border)
    }
}
