import UIKit

class DuesViewController: UIViewController {

    private let contentWidth = getRatWidth(320) // 이미지 가로, 세로
    private let contentHeight = getRatWidth(481)
    var user: User?
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 6
        return view
    }()
    
    private lazy var membershipImageView: UIImageView = {
        let imageView = UIImageView()
        if user?.memberShip == true {
            imageView.image = UIImage(named: "membership_true")
        } else {
            imageView.image = UIImage(named: "membership_false")
        }
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return imageView
    }()
    
    private let membershipTrueLabel: UILabel = {
        let label = UILabel()
        label.text = "자치회비 납부자"
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textColor = .primaryPurple
        return label
    }()
    
    private let membershipFalseLabel: UILabel = {
        let label = UILabel()
        label.text = "자치회비 미납부자"
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.textColor = UIColor(red: 255/255, green: 173/255, blue: 0, alpha: 1)
        return label
    }()
    
    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        var membershipLabel = UILabel()
        if user?.memberShip == true {
            membershipLabel = membershipTrueLabel
        } else {
            membershipLabel = membershipFalseLabel
        }
        
        let nameLabel = UILabel()
        nameLabel.text = user?.name
        nameLabel.font = UIFont(name: "Pretendard-Bold", size: 16)
        nameLabel.textColor = .black
        
        let idLabel = UILabel()
        idLabel.text = user?.studentNo
        idLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        idLabel.textColor = .black
        
        let collegeLabel = UILabel()
        collegeLabel.text = findCollege(major: user?.department ?? "")
        collegeLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        collegeLabel.textColor = .black
        
        let majorLabel = UILabel()
        majorLabel.text = user?.department
        majorLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        majorLabel.textColor = .black
        
        membershipLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        collegeLabel.translatesAutoresizingMaskIntoConstraints = false
        majorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(membershipLabel)
        view.addSubview(nameLabel)
        view.addSubview(idLabel)
        view.addSubview(collegeLabel)
        view.addSubview(majorLabel)
        
        let ratLeftConstant = getRatWidth(32)
        
        NSLayoutConstraint.activate([
            membershipLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: ratLeftConstant),
            membershipLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: getRatWidth(18)),
            nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: ratLeftConstant),
            nameLabel.topAnchor.constraint(equalTo: membershipLabel.bottomAnchor, constant: getRatWidth(18)),
            idLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: ratLeftConstant),
            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: getRatWidth(7)),
            collegeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: ratLeftConstant),
            collegeLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: getRatWidth(3)),
            majorLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: ratLeftConstant),
            majorLabel.topAnchor.constraint(equalTo: collegeLabel.bottomAnchor, constant: getRatWidth(3))
        ])
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureUI()
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
        
        self.navigationItem.title = "자치회비 납부 확인"
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .backgroundPurple
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        membershipImageView.translatesAutoresizingMaskIntoConstraints = false
        infoView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(contentView)
        contentView.addSubview(membershipImageView)
        contentView.addSubview(infoView)

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: contentWidth),
            contentView.heightAnchor.constraint(equalToConstant: contentHeight),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            membershipImageView.widthAnchor.constraint(equalToConstant: contentWidth),
            membershipImageView.heightAnchor.constraint(equalToConstant: contentWidth),
            membershipImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            membershipImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            infoView.widthAnchor.constraint(equalToConstant: contentWidth),
            infoView.heightAnchor.constraint(equalToConstant: contentHeight - contentWidth),
            infoView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            infoView.topAnchor.constraint(equalTo: membershipImageView.bottomAnchor)
        ])
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
