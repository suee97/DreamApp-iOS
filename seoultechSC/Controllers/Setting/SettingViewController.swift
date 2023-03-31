import UIKit

class SettingViewController: UIViewController {
    
    private let scrollView : UIScrollView = UIScrollView()
    
    private let contentView : UIView = UIView()
    
    private let myInfoContainer: UIView = {
        let container = UIView()
        
        let myImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 78, height: 78))
        myImage.image = UIImage(systemName: "person")
        myImage.contentMode = .scaleAspectFit
        
        let myName = UILabel(frame: CGRect(x: 95, y: 0, width: 100, height: 19))
        myName.text = "이름"
        myName.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        let myCode = UILabel(frame: CGRect(x: 95, y: 32, width: 100, height: 16))
        myCode.text = "학번"
        myCode.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        let myGroup = UILabel(frame: CGRect(x: 95, y: 52, width: 100, height: 16))
        myGroup.text = "단과대학"
        myGroup.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        let myMajor = UILabel(frame: CGRect(x: 95, y: 72, width: 100, height: 16))
        myMajor.text = "학과"
        myMajor.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        container.addSubview(myImage)
        container.addSubview(myName)
        container.addSubview(myCode)
        container.addSubview(myGroup)
        container.addSubview(myMajor)
        
        return container
    }()
    
    private let manageAccountContainer: UIView = {
        
        let container = UIView()
        container.layer.cornerRadius = 10
        
        let title = UILabel(frame: CGRect(x: 14, y: 9, width: 320, height: 19))
        title.text = "계정관리"
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        let logout = UIButton(frame: CGRect(x: 15, y: 44, width: 320, height: 20))
        logout.setTitle("로그아웃", for: .normal)
        logout.setTitleColor(.black, for: .normal)
        logout.contentHorizontalAlignment = .leading
        logout.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        logout.backgroundColor = .clear
        
        let resetPassword = UIButton(frame: CGRect(x: 15, y: 74, width: 320, height: 20))
        resetPassword.setTitle("비밀번호 재설정", for: .normal)
        resetPassword.setTitleColor(.black, for: .normal)
        resetPassword.contentHorizontalAlignment = .leading
        resetPassword.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        resetPassword.backgroundColor = .clear
        
        let withdrawl = UIButton(frame: CGRect(x: 15, y: 104, width: 320, height: 20))
        withdrawl.setTitle("회원탈퇴", for: .normal)
        withdrawl.setTitleColor(.black, for: .normal)
        withdrawl.contentHorizontalAlignment = .leading
        withdrawl.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        withdrawl.backgroundColor = .clear
        
        container.addSubview(title)
        container.addSubview(logout)
        container.addSubview(resetPassword)
        container.addSubview(withdrawl)
        
        return container
        
    }()
    
    private let SNSContainer: UIView = {
        
        let container = UIView()
        container.layer.cornerRadius = 10
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        
        let title = UILabel(frame: CGRect(x: 14, y: 9, width: 320, height: 19))
        title.text = "총학생회 SNS 바로가기"
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        
//        인스타그램 유튜브 카카오톡 홈페이지
        let instagram = UIButton(frame: CGRect(x: 20, y: 44, width: 52, height: 50))
        instagram.setTitle("인스타그램", for: .normal)
        instagram.setTitleColor(.primaryPurple, for: .normal)
        instagram.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
        instagram.setImage(UIImage(systemName: "person", withConfiguration: imageConfig), for: .normal)
        instagram.imageView?.contentMode = .scaleAspectFit
        instagram.alignTextBelow(spacing: 4)
        
        let youtube = UIButton(frame: CGRect(x: 109, y: 44, width: 52, height: 50))
        youtube.setTitle("유튜브", for: .normal)
        youtube.setTitleColor(.primaryPurple, for: .normal)
        youtube.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
        youtube.setImage(UIImage(systemName: "person", withConfiguration: imageConfig), for: .normal)
        youtube.imageView?.contentMode = .scaleAspectFit
        youtube.alignTextBelow(spacing: 4)
        
        let kakao = UIButton(frame: CGRect(x: 185, y: 44, width: 52, height: 50))
        kakao.setTitle("카카오톡", for: .normal)
        kakao.setTitleColor(.primaryPurple, for: .normal)
        kakao.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
        kakao.setImage(UIImage(systemName: "person", withConfiguration: imageConfig), for: .normal)
        kakao.imageView?.contentMode = .scaleAspectFit
        kakao.alignTextBelow(spacing: 4)
        
        let homepage = UIButton(frame: CGRect(x: 260, y: 44, width: 52, height: 50))
        homepage.setTitle("홈페이지", for: .normal)
        homepage.setTitleColor(.primaryPurple, for: .normal)
        homepage.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
        homepage.setImage(UIImage(systemName: "person", withConfiguration: imageConfig), for: .normal)
        homepage.imageView?.contentMode = .scaleAspectFit
        homepage.alignTextBelow(spacing: 4)
        
        container.addSubview(title)
        container.addSubview(instagram)
        container.addSubview(youtube)
        container.addSubview(kakao)
        container.addSubview(homepage)
        
        return container
        
    }()
    
    private let InfoContainer: UIView = {
        
        let container = UIView()
        container.layer.cornerRadius = 10
        
        let title = UILabel(frame: CGRect(x: 14, y: 9, width: 320, height: 19))
        title.text = "정보"
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        let update = UIButton(frame: CGRect(x: 15, y: 44, width: 320, height: 20))
        update.setTitle("업데이트 내역", for: .normal)
        update.setTitleColor(.black, for: .normal)
        update.contentHorizontalAlignment = .leading
        update.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        update.backgroundColor = .clear
        
        let infoAboutDev = UIButton(frame: CGRect(x: 15, y: 74, width: 320, height: 20))
        infoAboutDev.setTitle("개발 관련 정보 및 문의", for: .normal)
        infoAboutDev.setTitleColor(.black, for: .normal)
        infoAboutDev.contentHorizontalAlignment = .leading
        infoAboutDev.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        infoAboutDev.backgroundColor = .clear
        
        container.addSubview(title)
        container.addSubview(update)
        container.addSubview(infoAboutDev)
        
        return container
        
    }()
    
    private let adviceContainer: UIView = {
        
        let container = UIView()
        container.layer.cornerRadius = 10
        
        let title = UILabel(frame: CGRect(x: 14, y: 9, width: 320, height: 19))
        title.text = "제안사항"
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        let adviceFunction = UIButton(frame: CGRect(x: 15, y: 44, width: 320, height: 20))
        adviceFunction.setTitle("기능 개선 제안", for: .normal)
        adviceFunction.setTitleColor(.black, for: .normal)
        adviceFunction.contentHorizontalAlignment = .leading
        adviceFunction.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        adviceFunction.backgroundColor = .clear
        
        let report = UIButton(frame: CGRect(x: 15, y: 74, width: 320, height: 20))
        report.setTitle("오류 신고", for: .normal)
        report.setTitleColor(.black, for: .normal)
        report.contentHorizontalAlignment = .leading
        report.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        report.backgroundColor = .clear
        
        let someAdvice = UIButton(frame: CGRect(x: 15, y: 104, width: 320, height: 20))
        someAdvice.setTitle("기타 제안", for: .normal)
        someAdvice.setTitleColor(.black, for: .normal)
        someAdvice.contentHorizontalAlignment = .leading
        someAdvice.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        someAdvice.backgroundColor = .clear
        
        container.addSubview(title)
        container.addSubview(adviceFunction)
        container.addSubview(report)
        container.addSubview(someAdvice)
        
        return container
        
    }()
    
    private let policyContainer: UIView = {
        
        let container = UIView()
        container.layer.cornerRadius = 10
        
        let title = UILabel(frame: CGRect(x: 14, y: 9, width: 320, height: 19))
        title.text = "약관 및 정책"
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        let service = UIButton(frame: CGRect(x: 15, y: 44, width: 320, height: 20))
        service.setTitle("서비스 이용약관", for: .normal)
        service.setTitleColor(.black, for: .normal)
        service.contentHorizontalAlignment = .leading
        service.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        service.backgroundColor = .clear
        
        let location = UIButton(frame: CGRect(x: 15, y: 74, width: 320, height: 20))
        location.setTitle("위치기반서비스 이용약관", for: .normal)
        location.setTitleColor(.black, for: .normal)
        location.contentHorizontalAlignment = .leading
        location.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        location.backgroundColor = .clear
        
        let policy = UIButton(frame: CGRect(x: 15, y: 104, width: 320, height: 20))
        policy.setTitle("개인정보처리방침", for: .normal)
        policy.setTitleColor(.black, for: .normal)
        policy.contentHorizontalAlignment = .leading
        policy.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        policy.backgroundColor = .clear
        
        let info = UIButton(frame: CGRect(x: 15, y: 134, width: 320, height: 20))
        info.setTitle("정보제공처", for: .normal)
        info.setTitleColor(.black, for: .normal)
        info.contentHorizontalAlignment = .leading
        info.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        info.backgroundColor = .clear
        
        let opensource = UIButton(frame: CGRect(x: 15, y: 164, width: 320, height: 20))
        opensource.setTitle("오픈소스 라이선스", for: .normal)
        opensource.setTitleColor(.black, for: .normal)
        opensource.contentHorizontalAlignment = .leading
        opensource.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        opensource.backgroundColor = .clear
        
        container.addSubview(title)
        container.addSubview(service)
        container.addSubview(location)
        container.addSubview(policy)
        container.addSubview(info)
        container.addSubview(opensource)
        
        return container
        
    }()
//
//    Tel. 02) 970-7012
//    서울특별시 노원구 공릉로 232 제1학생회관 226호
//    ⓒSeoul National University of Science and Technology. All Rights Reserved.
    
    private var tel : UILabel = {
        let tel = UILabel()
        tel.text = "Tel. 02) 970-7012"
        tel.font = UIFont(name: "Pretendard-Regular", size: 12)
        tel.textAlignment = .center
        tel.textColor = .gray
        return tel
    }()
    
    private var location : UILabel = {
        let location = UILabel()
        location.text = "서울특별시 노원구 공릉로 232 제1학생회관 226호"
        location.font = UIFont(name: "Pretendard-Regular", size: 12)
        location.textAlignment = .center
        location.textColor = .gray
        return location
    }()
    
    private var right : UILabel = {
        let right = UILabel()
        right.text = "ⓒSeoul National University of Science and Technology. All Rights Reserved."
        right.font = UIFont(name: "Pretendard-Regular", size: 12)
        right.textAlignment = .center
        right.numberOfLines = 2
        right.textColor = .gray
        return right
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
        
        self.navigationItem.title = "설정"
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .backgroundPurple
        scrollView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        manageAccountContainer.backgroundColor = .white
        SNSContainer.backgroundColor = .white
        InfoContainer.backgroundColor = .white
        adviceContainer.backgroundColor = .white
        policyContainer.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(myInfoContainer)
        contentView.addSubview(manageAccountContainer)
        contentView.addSubview(SNSContainer)
        contentView.addSubview(InfoContainer)
        contentView.addSubview(adviceContainer)
        contentView.addSubview(policyContainer)
        contentView.addSubview(tel)
        contentView.addSubview(location)
        contentView.addSubview(right)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        myInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        manageAccountContainer.translatesAutoresizingMaskIntoConstraints = false
        SNSContainer.translatesAutoresizingMaskIntoConstraints = false
        InfoContainer.translatesAutoresizingMaskIntoConstraints = false
        adviceContainer.translatesAutoresizingMaskIntoConstraints = false
        policyContainer.translatesAutoresizingMaskIntoConstraints = false
        tel.translatesAutoresizingMaskIntoConstraints = false
        location.translatesAutoresizingMaskIntoConstraints = false
        right.translatesAutoresizingMaskIntoConstraints = false
        

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            myInfoContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            myInfoContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            myInfoContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            myInfoContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            manageAccountContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            manageAccountContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 140),
            manageAccountContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            manageAccountContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            manageAccountContainer.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 270),
            SNSContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            SNSContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 290),
            SNSContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            SNSContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            SNSContainer.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 390),
            InfoContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            InfoContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 410),
            InfoContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            InfoContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            InfoContainer.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 510),
            adviceContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            adviceContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 530),
            adviceContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            adviceContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            adviceContainer.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 660),
            policyContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            policyContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 680),
            policyContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            policyContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            policyContainer.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 880),
            tel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            tel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 913),
            location.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            location.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 925),
            right.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            right.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 937),
            right.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            right.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            right.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -33)
        ])
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        
    }
}

extension UIButton {
    
    func alignTextBelow(spacing: CGFloat = 8.0) {
            guard let image = self.imageView?.image else {
                return
            }

            guard let titleLabel = self.titleLabel else {
                return
            }

            guard let titleText = titleLabel.text else {
                return
            }

            let titleSize = titleText.size(withAttributes: [
                NSAttributedString.Key.font: titleLabel.font as Any
            ])

            titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image.size.width, bottom: -image.size.height, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
        }
}
