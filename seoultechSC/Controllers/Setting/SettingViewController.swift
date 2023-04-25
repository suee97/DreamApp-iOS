import UIKit
import Alamofire

class SettingViewController: UIViewController, LogoutDelegate, LoginDelegate, WithdrawalDelegate {
    
    private let scrollView : UIScrollView = UIScrollView()
    
    private let contentView : UIView = UIView()
    
    private lazy var myInfoContainer: UIView = {
        let container = UIView()
        
        let myImage : UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "person.crop.circle")
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .secondaryPurple
            
            return imageView
        }()
        
        let myName : UILabel = {
            let name = UILabel()
            name.text = signInUser.name
            name.textColor = .black
            name.font = UIFont(name: "Pretendard-Bold", size: 16)
            return name
        }()
        
        let myCode : UILabel = {
            let code = UILabel()
            code.text = signInUser.studentNo
            code.textColor = .black
            code.font = UIFont(name: "Pretendard-Regular", size: 12)
            return code
        }()
        
        let myGroup : UILabel = {
            let group = UILabel()
            group.text = findCollege(major: signInUser.department)
            group.textColor = .black
            group.font = UIFont(name: "Pretendard-Regular", size: 12)
            return group
        }()
        
        let myMajor : UILabel = {
            let major = UILabel()
            major.text = signInUser.department
            major.textColor = .black
            major.font = UIFont(name: "Pretendard-Regular", size: 12)
            return major
        }()
        
        container.addSubview(myImage)
        container.addSubview(myName)
        container.addSubview(myCode)
        container.addSubview(myGroup)
        container.addSubview(myMajor)
        
        container.layer.cornerRadius = 10
        
        myImage.translatesAutoresizingMaskIntoConstraints = false
        myName.translatesAutoresizingMaskIntoConstraints = false
        myCode.translatesAutoresizingMaskIntoConstraints = false
        myGroup.translatesAutoresizingMaskIntoConstraints = false
        myMajor.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myImage.topAnchor.constraint(equalTo: container.topAnchor),
            myImage.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            myImage.widthAnchor.constraint(equalToConstant: 78),
            myImage.heightAnchor.constraint(equalToConstant: 78),
            
            myName.leadingAnchor.constraint(equalTo: myImage.trailingAnchor, constant: 17),
            myName.topAnchor.constraint(equalTo: container.topAnchor),
            
            myCode.leadingAnchor.constraint(equalTo: myImage.trailingAnchor, constant: 17),
            myCode.topAnchor.constraint(equalTo: myName.bottomAnchor, constant: 13),
            
            myGroup.leadingAnchor.constraint(equalTo: myImage.trailingAnchor, constant: 17),
            myGroup.topAnchor.constraint(equalTo: myCode.bottomAnchor, constant: 4),
            
            myMajor.leadingAnchor.constraint(equalTo: myImage.trailingAnchor, constant: 17),
            myMajor.topAnchor.constraint(equalTo: myGroup.bottomAnchor, constant: 4),
        ])
        
        return container
    }()
    
    private let needLoginContainer: UIView = {
        let container = UIView()
        
        let myImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "person.crop.circle")
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .secondaryPurple
            return imageView
        }()
        
        let needLoginLabel: UILabel = {
            let label = UILabel()
            label.text = "로그인이 필요합니다."
            label.textColor = .black
            label.font = UIFont(name: "Pretendard-Bold", size: 16)
            return label
        }()
        
        let loginButton: ActionButton = {
            let button = ActionButton(title: "로그인 하기", height: 34)
            button.addTarget(self, action: #selector(loginBtn), for: .touchUpInside)
            return button
        }()
        
        container.addSubview(myImageView)
        container.addSubview(needLoginLabel)
        container.addSubview(loginButton)
        
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        needLoginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myImageView.leftAnchor.constraint(equalTo: container.leftAnchor),
            myImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            myImageView.widthAnchor.constraint(equalToConstant: 78),
            myImageView.heightAnchor.constraint(equalToConstant: 78),
            needLoginLabel.leftAnchor.constraint(equalTo: myImageView.rightAnchor, constant: 17),
            needLoginLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 7),
            loginButton.widthAnchor.constraint(equalToConstant: 97),
            loginButton.leftAnchor.constraint(equalTo: myImageView.rightAnchor, constant: 18),
            loginButton.topAnchor.constraint(equalTo: needLoginLabel.bottomAnchor, constant: 10)
        ])
        
        return container
    }()
    
    private let manageAccountContainer: UIView = {
        
        let container = UIView()
        container.layer.cornerRadius = 10
        
        let divider: UIView = {
            let view = UIView()
            view.backgroundColor = .lightGrey
            return view
        }()
        
        container.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 14).isActive = true
        divider.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -9).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.topAnchor.constraint(equalTo: container.topAnchor, constant: 36).isActive = true
        
        let title = UILabel()
        title.text = "계정관리"
        title.textColor = .black
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        let logout = UIButton()
        logout.setTitle("로그아웃", for: .normal)
        logout.setTitleColor(.black, for: .normal)
        logout.contentHorizontalAlignment = .leading
        logout.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        logout.backgroundColor = .clear
        logout.addTarget(self, action: #selector(logoutBtn), for: .touchUpInside)
        
        let resetPassword = UIButton()
        resetPassword.setTitle("비밀번호 재설정", for: .normal)
        resetPassword.setTitleColor(.black, for: .normal)
        resetPassword.contentHorizontalAlignment = .leading
        resetPassword.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        resetPassword.backgroundColor = .clear
        resetPassword.addTarget(self, action: #selector(resetPasswordBtn), for: .touchUpInside)
        
        let withdrawl = UIButton()
        withdrawl.setTitle("회원탈퇴", for: .normal)
        withdrawl.setTitleColor(.black, for: .normal)
        withdrawl.contentHorizontalAlignment = .leading
        withdrawl.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        withdrawl.backgroundColor = .clear
        withdrawl.addTarget(self, action: #selector(withdrawlBtn), for: .touchUpInside)
        
        let viewArr = [title, logout, resetPassword, withdrawl]
        
        for i in viewArr {
            container.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: container.topAnchor, constant: 9),
            title.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14),
            
            logout.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            logout.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            
            resetPassword.topAnchor.constraint(equalTo: logout.bottomAnchor, constant: 2),
            resetPassword.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            
            withdrawl.topAnchor.constraint(equalTo: resetPassword.bottomAnchor, constant: 2),
            withdrawl.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            
        ])
        
        return container
        
    }()
    
    private let nonLoginManageAccountContainer: UIView = {
        
        let container = UIView()
        container.layer.cornerRadius = 10
        
        let divider: UIView = {
            let view = UIView()
            view.backgroundColor = .lightGrey
            return view
        }()
        
        container.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 14).isActive = true
        divider.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -9).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.topAnchor.constraint(equalTo: container.topAnchor, constant: 36).isActive = true
        
        let title = UILabel()
        title.text = "계정관리"
        title.textColor = .text_caption
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        let logout = UIButton()
        logout.setTitle("로그아웃", for: .normal)
        logout.setTitleColor(.text_caption, for: .normal)
        logout.contentHorizontalAlignment = .leading
        logout.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        logout.backgroundColor = .clear
        logout.isEnabled = false
        
        let resetPassword = UIButton()
        resetPassword.setTitle("비밀번호 재설정", for: .normal)
        resetPassword.setTitleColor(.text_caption, for: .normal)
        resetPassword.contentHorizontalAlignment = .leading
        resetPassword.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        resetPassword.backgroundColor = .clear
        resetPassword.isEnabled = false
        
        let withdrawl = UIButton()
        withdrawl.setTitle("회원탈퇴", for: .normal)
        withdrawl.setTitleColor(.text_caption, for: .normal)
        withdrawl.contentHorizontalAlignment = .leading
        withdrawl.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        withdrawl.backgroundColor = .clear
        withdrawl.isEnabled = false
        
        let viewArr = [title, logout, resetPassword, withdrawl]
        
        for i in viewArr {
            container.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: container.topAnchor, constant: 9),
            title.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14),
            
            logout.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            logout.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            
            resetPassword.topAnchor.constraint(equalTo: logout.bottomAnchor, constant: 2),
            resetPassword.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            
            withdrawl.topAnchor.constraint(equalTo: resetPassword.bottomAnchor, constant: 2),
            withdrawl.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            
        ])
        
        return container
        
    }()
    
    private let SNSContainer: UIView = {
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let container = UIView()
        container.layer.cornerRadius = 10
        
        let divider: UIView = {
            let view = UIView()
            view.backgroundColor = .lightGrey
            return view
        }()
        
        container.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 14).isActive = true
        divider.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -9).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.topAnchor.constraint(equalTo: container.topAnchor, constant: 36).isActive = true
        
        let title = UILabel()
        title.text = "총학생회 SNS 바로가기"
        title.textColor = .black
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        let instagram = UIButton()
        instagram.setTitle("인스타그램", for: .normal)
        instagram.setImage(UIImage(named: "instagram_logo"), for: .normal)
        instagram.addTarget(self, action: #selector(instagramBtn), for: .touchUpInside)
        
        let youtube = UIButton()
        youtube.setTitle("유튜브", for: .normal)
        youtube.setImage(UIImage(named: "youtube_logo"), for: .normal)
        youtube.addTarget(self, action: #selector(youtubeBtn), for: .touchUpInside)
        
        let kakao = UIButton()
        kakao.setTitle("카카오톡", for: .normal)
        kakao.setImage(UIImage(named: "kakao_logo"), for: .normal)
        kakao.addTarget(self, action: #selector(kakaoBtn), for: .touchUpInside)
        
        let homepage = UIButton()
        homepage.setTitle("홈페이지", for: .normal)
        homepage.setImage(UIImage(systemName: "globe", withConfiguration: imageConfig), for: .normal)
        homepage.addTarget(self, action: #selector(homepageBtn), for: .touchUpInside)
        
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.backgroundColor = .clear
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            stackView.alignment = .center
            return stackView
        }()
        
        let buttonList: [UIButton] = [instagram, youtube, kakao, homepage]
        
        for i in buttonList {
            i.tintColor = .primaryPurple
            i.setTitleColor(.primaryPurple, for: .normal)
            i.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
            i.imageView?.contentMode = .scaleAspectFit
            i.alignTextBelow(spacing: 4)
            i.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(i)
            i.widthAnchor.constraint(equalToConstant: 52).isActive = true
        }
        
        title.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(title)
        container.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 44),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -7),
            title.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 14),
            title.topAnchor.constraint(equalTo: container.topAnchor, constant: 9)
        ])
        
        return container
        
    }()
    
    private let InfoContainer: UIView = {
        
        let container = UIView()
        container.layer.cornerRadius = 10
        
        let divider: UIView = {
            let view = UIView()
            view.backgroundColor = .lightGrey
            return view
        }()
        
        container.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 14).isActive = true
        divider.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -9).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.topAnchor.constraint(equalTo: container.topAnchor, constant: 36).isActive = true
        
        let title = UILabel()
        title.text = "정보"
        title.textColor = .black
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        let update = UIButton()
        update.setTitle("업데이트 내역", for: .normal)
        update.setTitleColor(.black, for: .normal)
        update.contentHorizontalAlignment = .leading
        update.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        update.backgroundColor = .clear
        update.addTarget(self, action: #selector(updateBtn), for: .touchUpInside)
        
        let infoAboutDev = UIButton()
        infoAboutDev.setTitle("개발 관련 정보 및 문의", for: .normal)
        infoAboutDev.setTitleColor(.black, for: .normal)
        infoAboutDev.contentHorizontalAlignment = .leading
        infoAboutDev.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        infoAboutDev.backgroundColor = .clear
        infoAboutDev.addTarget(self, action: #selector(infoAboutDevBtn), for: .touchUpInside)
        
        let viewArr = [title, update, infoAboutDev]
        
        for i in viewArr {
            container.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: container.topAnchor, constant: 9),
            title.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14),
            
            update.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            update.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            
            infoAboutDev.topAnchor.constraint(equalTo: update.bottomAnchor, constant: 2),
            infoAboutDev.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
        ])
        
        return container
        
    }()
    
    private let adviceContainer: UIView = {
        
        let container = UIView()
        container.layer.cornerRadius = 10
        
        let divider: UIView = {
            let view = UIView()
            view.backgroundColor = .lightGrey
            return view
        }()
        
        container.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 14).isActive = true
        divider.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -9).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.topAnchor.constraint(equalTo: container.topAnchor, constant: 36).isActive = true
        
        let title = UILabel()
        title.text = "제안사항"
        title.textColor = .black
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        let adviceFunction = UIButton()
        adviceFunction.setTitle("기능 개선 제안", for: .normal)
        adviceFunction.setTitleColor(.black, for: .normal)
        adviceFunction.contentHorizontalAlignment = .leading
        adviceFunction.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        adviceFunction.backgroundColor = .clear
        adviceFunction.addTarget(self, action: #selector(adviceFunctionBtn), for: .touchUpInside)
        
        let report = UIButton()
        report.setTitle("오류 신고", for: .normal)
        report.setTitleColor(.black, for: .normal)
        report.contentHorizontalAlignment = .leading
        report.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        report.backgroundColor = .clear
        report.addTarget(self, action: #selector(reportBtn), for: .touchUpInside)
        
        let someAdvice = UIButton()
        someAdvice.setTitle("기타 제안", for: .normal)
        someAdvice.setTitleColor(.black, for: .normal)
        someAdvice.contentHorizontalAlignment = .leading
        someAdvice.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        someAdvice.backgroundColor = .clear
        someAdvice.addTarget(self, action: #selector(someAdviceBtn), for: .touchUpInside)
        
        let viewArr = [title, adviceFunction, report, someAdvice]
        
        for i in viewArr {
            container.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: container.topAnchor, constant: 9),
            title.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14),
            
            adviceFunction.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            adviceFunction.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            
            report.topAnchor.constraint(equalTo: adviceFunction.bottomAnchor, constant: 2),
            report.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            
            someAdvice.topAnchor.constraint(equalTo: report.bottomAnchor, constant: 2),
            someAdvice.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            
        ])
        
        return container
        
    }()
    
    private let policyContainer: UIView = {
        
        let container = UIView()
        container.layer.cornerRadius = 10
        
        let divider: UIView = {
            let view = UIView()
            view.backgroundColor = .lightGrey
            return view
        }()
        
        container.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 14).isActive = true
        divider.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -9).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.topAnchor.constraint(equalTo: container.topAnchor, constant: 36).isActive = true
        
        let title = UILabel()
        title.text = "약관 및 정책"
        title.textColor = .black
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        let service = UIButton()
        service.setTitle("서비스 이용약관", for: .normal)
        service.setTitleColor(.black, for: .normal)
        service.contentHorizontalAlignment = .leading
        service.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        service.backgroundColor = .clear
        service.addTarget(self, action: #selector(serviceBtn), for: .touchUpInside)
        
        let policy = UIButton()
        policy.setTitle("개인정보처리방침", for: .normal)
        policy.setTitleColor(.black, for: .normal)
        policy.contentHorizontalAlignment = .leading
        policy.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
        policy.backgroundColor = .clear
        policy.addTarget(self, action: #selector(policyBtn), for: .touchUpInside)
        
        container.addSubview(title)
        container.addSubview(service)
        container.addSubview(policy)
        
        let viewArr = [title, service, policy]
        
        for i in viewArr {
            container.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: container.topAnchor, constant: 9),
            title.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14),
            
            service.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            service.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            
            policy.topAnchor.constraint(equalTo: service.bottomAnchor, constant: 2),
            policy.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            
        ])
        
        return container
        
    }()
    
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
        print("setting : is Login? >> \(getLoginState())")
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
        nonLoginManageAccountContainer.backgroundColor = .white
        SNSContainer.backgroundColor = .white
        InfoContainer.backgroundColor = .white
        adviceContainer.backgroundColor = .white
        policyContainer.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(SNSContainer)
        contentView.addSubview(InfoContainer)
        contentView.addSubview(adviceContainer)
        contentView.addSubview(policyContainer)
        contentView.addSubview(tel)
        contentView.addSubview(location)
        contentView.addSubview(right)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
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
            
            SNSContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            SNSContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 290),
            SNSContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            SNSContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            SNSContainer.heightAnchor.constraint(equalToConstant: 110),
            
            InfoContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            InfoContainer.topAnchor.constraint(equalTo: SNSContainer.bottomAnchor, constant: 20),
            InfoContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            InfoContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            InfoContainer.heightAnchor.constraint(equalToConstant: 110),
            
            adviceContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            adviceContainer.topAnchor.constraint(equalTo: InfoContainer.bottomAnchor, constant: 20),
            adviceContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            adviceContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            adviceContainer.heightAnchor.constraint(equalToConstant: 140),
            
            policyContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            policyContainer.topAnchor.constraint(equalTo: adviceContainer.bottomAnchor, constant: 20),
            policyContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            policyContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            policyContainer.heightAnchor.constraint(equalToConstant: 110),
            
            tel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            tel.topAnchor.constraint(equalTo: policyContainer.bottomAnchor, constant: 35),
            location.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            location.topAnchor.constraint(equalTo: tel.bottomAnchor, constant: 3),
            right.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            right.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 3),
            right.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            right.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            right.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -33)
        ])
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        
        if getLoginState() {
            contentView.addSubview(myInfoContainer)
            contentView.addSubview(manageAccountContainer)
            myInfoContainer.translatesAutoresizingMaskIntoConstraints = false
            manageAccountContainer.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                myInfoContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
                myInfoContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
                myInfoContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
                myInfoContainer.bottomAnchor.constraint(equalTo: manageAccountContainer.topAnchor, constant: -32),
                
                manageAccountContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                manageAccountContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 140),
                manageAccountContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
                manageAccountContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
                manageAccountContainer.heightAnchor.constraint(equalToConstant: 140),
            ])
        } else {
            contentView.addSubview(needLoginContainer)
            contentView.addSubview(nonLoginManageAccountContainer)
            needLoginContainer.translatesAutoresizingMaskIntoConstraints = false
            nonLoginManageAccountContainer.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                needLoginContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
                needLoginContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
                needLoginContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
                needLoginContainer.bottomAnchor.constraint(equalTo: nonLoginManageAccountContainer.topAnchor, constant: -32),
                
                nonLoginManageAccountContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                nonLoginManageAccountContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 140),
                nonLoginManageAccountContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
                nonLoginManageAccountContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
                nonLoginManageAccountContainer.heightAnchor.constraint(equalToConstant: 140),
            ])
        }
    }
    
    // MARK: - Selectors
    @objc private func loginBtn() {
        let vc = LoginModalViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func updateLogin(isLogin: Bool) {
        if isLogin {
            let vc = SelectLoginViewController()
            navigationController?.setViewControllers([vc], animated: true)
        }
    }
    
    @objc private func logoutBtn() {
        let vc = LogoutModalViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func resetPasswordBtn() {
        let vc = LoginResetPwViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func withdrawlBtn() {
        let vc = WithdrawalModalViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func instagramBtn() {
        let Username =  "seoultech__39"
        let appURL = URL(string: "instagram://user?username=\(Username)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            let webURL = URL(string: "https://instagram.com/\(Username)")!
            application.open(webURL)
        }
    }
    
    @objc private func youtubeBtn() {
        let youtubeId = "UCLYljVZiYHeJxaHTbRpVauQ"
        var youtubeUrl = URL(string:"youtube://www.youtube.com/channel/\(youtubeId)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(youtubeUrl){
            application.open(youtubeUrl)
        } else{
            let webURL = URL(string: "https://www.youtube.com/channel/\(youtubeId)")!
            application.open(webURL)
        }
    }
    
    @objc private func kakaoBtn() {
        let application = UIApplication.shared
        let url = URL(string: "https://pf.kakao.com/_yxatCV")!
        application.open(url)
    }
    
    @objc private func homepageBtn() {
        let application = UIApplication.shared
        let url = URL(string: "https://gwack2.seoultech.ac.kr")!
        application.open(url)
    }
    
    @objc private func updateBtn() {
        let vc = UpdateHistoryViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func infoAboutDevBtn() {
        let vc = DevInfoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func adviceFunctionBtn() {
        let vc = SuggestViewController()
        vc.appBarTitle = "기능 개선 제안"
        vc.suggestCase = .feature
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func reportBtn() {
        let vc = SuggestViewController()
        vc.appBarTitle = "오류 신고"
        vc.suggestCase = .error
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func someAdviceBtn() {
        let vc = SuggestViewController()
        vc.appBarTitle = "기타 제안"
        vc.suggestCase = .etc
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func serviceBtn() {
        let vc = ServiceViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func policyBtn() {
        let vc = PrivacyViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateLogout(isLogout: Bool) {
        if isLogout {
            let vc = SelectLoginViewController()
            setLoginState(false)
            let url = "\(api_url)/auth/logout"
            let aToken: String = KeychainHelper.sharedKeychain.getAccessToken() ?? ""
            let rToken: String = KeychainHelper.sharedKeychain.getRefreshToken() ?? ""
            let header: HTTPHeaders = [
                "Authorization": "Bearer \(aToken)",
                "refresh" : "Bearer \(rToken)"
            ]
            
            KeychainHelper.sharedKeychain.resetAccessRefreshToken()
            
            let request = AF.request(url,
                                     method: .get,
                                     parameters: nil,
                                     headers: header
            ).responseJSON { response in
                
            }
            
            navigationController?.setViewControllers([vc], animated: true)
        }
    }
    
    func withdrawal(isLogout: Bool) {
        if isLogout {
            let vc = SelectLoginViewController()
            setLoginState(false)
            let url = "\(api_url)/member"
            let aToken: String = KeychainHelper.sharedKeychain.getAccessToken() ?? ""
            let rToken: String = KeychainHelper.sharedKeychain.getRefreshToken() ?? ""
            let header: HTTPHeaders = [
                "Authorization": "Bearer \(aToken)",
                "refresh" : "Bearer \(rToken)"
            ]
            
            KeychainHelper.sharedKeychain.resetAccessRefreshToken()
            
            let request = AF.request(url,
                                     method: .delete,
                                     parameters: nil,
                                     headers: header
            ).responseJSON { response in
                print("회원탈퇴 처리 완료")
                
            }
            
            navigationController?.setViewControllers([vc], animated: true)
        }
    }
    
    private func findCollege(major: String) -> String {
        for i in 0..<collegeList.count {
            for j in 0..<majorList[i].count {
                if major == majorList[i][j] {
                    return collegeList[i]
                }
            }
        }
        return ""
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
