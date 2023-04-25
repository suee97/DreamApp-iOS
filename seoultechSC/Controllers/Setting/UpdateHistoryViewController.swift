import UIKit

class UpdateHistoryViewController: UIViewController {
    
    private let scrollView : UIScrollView = UIScrollView()
    private let contentView : UIView = UIView()
    
    private let divider1: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let divider2: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let divider3: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let divider4: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let appVersionContainer_4 : UIView = {
        let container = UIView()
        
        let version = UILabel()
        version.text = "1.1.0"
        version.textColor = .black
        version.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        let updateDate = UILabel()
        updateDate.text = "2023.05.06"
        updateDate.textColor = .black
        updateDate.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        let update1 = UILabel()
        update1.text = "Dream 총학생회 어플리케이션 업데이트"
        update1.textColor = .black
        update1.font = UIFont(name: "Pretendard-Regular", size: 15)
        
        let ViewArr = [version, updateDate, update1]
        
        for i in ViewArr {
            container.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            version.topAnchor.constraint(equalTo: container.topAnchor),
            version.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            
            updateDate.topAnchor.constraint(equalTo: container.topAnchor),
            updateDate.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            update1.topAnchor.constraint(equalTo: version.bottomAnchor, constant: 12),
            update1.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        ])
        
        return container
    }()
    
    private let appVersionContainer_3 : UIView = {
        let container = UIView()
        
        let version = UILabel()
        version.text = "1.0.3"
        version.textColor = .black
        version.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        let updateDate = UILabel()
        updateDate.text = "2022.09.20"
        updateDate.textColor = .black
        updateDate.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        let update1 = UILabel()
        update1.text = "상시사업 현황이 제대로 보이지 않는 문제 수정"
        update1.textColor = .black
        update1.font = UIFont(name: "Pretendard-Regular", size: 15)
        
        let ViewArr = [version, updateDate, update1]
        
        for i in ViewArr {
            container.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            version.topAnchor.constraint(equalTo: container.topAnchor),
            version.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            
            updateDate.topAnchor.constraint(equalTo: container.topAnchor),
            updateDate.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            update1.topAnchor.constraint(equalTo: version.bottomAnchor, constant: 12),
            update1.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        ])
        
        return container
    }()
    
    private let appVersionContainer_2 : UIView = {
        let container = UIView()
        
        let version = UILabel()
        version.text = "1.0.2"
        version.textColor = .black
        version.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        let updateDate = UILabel()
        updateDate.text = "2022.09.20"
        updateDate.textColor = .black
        updateDate.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        let update1 = UILabel()
        update1.text = "오타 및 버그 수정"
        update1.textColor = .black
        update1.font = UIFont(name: "Pretendard-Regular", size: 15)
        
        let update2 = UILabel()
        update2.text = "UI/UX 개선"
        update2.textColor = .black
        update2.font = UIFont(name: "Pretendard-Regular", size: 15)
        
        let ViewArr = [version, updateDate, update1, update2]
        
        for i in ViewArr {
            container.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            version.topAnchor.constraint(equalTo: container.topAnchor),
            version.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            
            updateDate.topAnchor.constraint(equalTo: container.topAnchor),
            updateDate.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            update1.topAnchor.constraint(equalTo: version.bottomAnchor, constant: 12),
            update1.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            
            update2.topAnchor.constraint(equalTo: update1.bottomAnchor, constant: 10),
            update2.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        ])
        
        return container
    }()
    
    private let appVersionContainer_1 : UIView = {
        let container = UIView()
        
        let version = UILabel()
        version.text = "1.0.1"
        version.textColor = .black
        version.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        let updateDate = UILabel()
        updateDate.text = "2022.09.07"
        updateDate.textColor = .black
        updateDate.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        let update1 = UILabel()
        update1.text = "ST'art 총학생회 어플리케이션 출시"
        update1.textColor = .black
        update1.font = UIFont(name: "Pretendard-Regular", size: 15)
        
        let ViewArr = [version, updateDate, update1]
        
        for i in ViewArr {
            container.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            version.topAnchor.constraint(equalTo: container.topAnchor),
            version.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            
            updateDate.topAnchor.constraint(equalTo: container.topAnchor),
            updateDate.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            update1.topAnchor.constraint(equalTo: version.bottomAnchor, constant: 12),
            update1.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        ])
        
        return container
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
        
        self.navigationItem.title = "업데이트 내역"
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        scrollView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(divider1)
        contentView.addSubview(divider2)
        contentView.addSubview(divider3)
        contentView.addSubview(divider4)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let containerViewArr = [appVersionContainer_1, appVersionContainer_2, appVersionContainer_3, appVersionContainer_4]
        
        for i in containerViewArr {
            contentView.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                i.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                i.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                i.heightAnchor.constraint(equalToConstant: 80),
            ])
        }
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            appVersionContainer_4.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            appVersionContainer_3.topAnchor.constraint(equalTo: appVersionContainer_4.bottomAnchor, constant: 12),
            appVersionContainer_2.topAnchor.constraint(equalTo: appVersionContainer_3.bottomAnchor, constant: 12),
            appVersionContainer_1.topAnchor.constraint(equalTo: appVersionContainer_2.bottomAnchor, constant: 12),
            
            divider1.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            divider1.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            divider1.heightAnchor.constraint(equalToConstant: 1),
            divider1.topAnchor.constraint(equalTo: appVersionContainer_4.bottomAnchor, constant: 4),
            
            divider2.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            divider2.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            divider2.heightAnchor.constraint(equalToConstant: 1),
            divider2.topAnchor.constraint(equalTo: appVersionContainer_3.bottomAnchor, constant: 4),
            
            divider3.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            divider3.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            divider3.heightAnchor.constraint(equalToConstant: 1),
            divider3.topAnchor.constraint(equalTo: appVersionContainer_2.bottomAnchor, constant: 4),
            
            divider4.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            divider4.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            divider4.heightAnchor.constraint(equalToConstant: 1),
            divider4.topAnchor.constraint(equalTo: appVersionContainer_1.bottomAnchor, constant: 4)
        ])
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        
    }

}
