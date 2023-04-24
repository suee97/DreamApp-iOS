import UIKit

class LineUpViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Properties
    var lineUpList_5_10: [LineUp] = []
    var lineUpList_5_11: [LineUp] = []
    var lineUpList_5_12: [LineUp] = []
    var lineUpList: [LineUp] = []
    
    private var currentPage = 0
    
    private let dayChangeView: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryPurple
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        let imageView = UIImageView(image: UIImage(named: "preButton")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        button.addSubview(imageView)
        imageView.snp.makeConstraints({ m in
            m.centerY.equalTo(button)
            m.left.equalTo(button).inset(getRatWidth(31))
        })
        button.addTarget(self, action: #selector(onTapLeftButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        let imageView = UIImageView(image: UIImage(named: "nextButton")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        button.addSubview(imageView)
        imageView.snp.makeConstraints({ m in
            m.centerY.equalTo(button)
            m.right.equalTo(button).inset(getRatWidth(31))
        })
        button.addTarget(self, action: #selector(onTapRightButton), for: .touchUpInside)
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "5월 10일"
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        return label
    }()
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(LineUpCell.self, forCellWithReuseIdentifier: "line_up_cell")
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lineUpList = lineUpList_5_10
        configureUI()
        configureDelegate()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .clear
        
        view.addSubview(dayChangeView)
        dayChangeView.addSubview(leftButton)
        dayChangeView.addSubview(rightButton)
        dayChangeView.addSubview(dateLabel)
        view.addSubview(collectionView)
        
        dayChangeView.snp.makeConstraints({ m in
            m.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            m.left.right.equalTo(view)
            m.height.equalTo(30)
        })
        leftButton.snp.makeConstraints({ m in
            m.left.top.bottom.equalTo(dayChangeView)
            m.width.equalTo(dayChangeView).multipliedBy(0.25)
        })
        rightButton.snp.makeConstraints({ m in
            m.right.top.bottom.equalTo(dayChangeView)
            m.width.equalTo(dayChangeView).multipliedBy(0.25)
        })
        dateLabel.snp.makeConstraints({ m in
            m.centerX.centerY.equalTo(dayChangeView)
        })
        collectionView.snp.makeConstraints({ m in
            m.left.right.equalTo(view)
            m.top.equalTo(dayChangeView.snp.bottom).offset(15)
            m.bottom.equalTo(view.safeAreaLayoutGuide)
        })
    }
    
    @objc private func onTapLeftButton() {
        if currentPage == 1 {
            dateLabel.text = "5월 10일"
            lineUpList = lineUpList_5_10
            collectionView.reloadData()
            currentPage = 0
        } else if currentPage == 2 {
            dateLabel.text = "5월 11일"
            lineUpList = lineUpList_5_11
            collectionView.reloadData()
            currentPage = 1
        }
    }
    
    @objc private func onTapRightButton() {
        if currentPage == 0 {
            dateLabel.text = "5월 11일"
            lineUpList = lineUpList_5_11
            collectionView.reloadData()
            currentPage = 1
        } else if currentPage == 1 {
            dateLabel.text = "5월 12일"
            lineUpList = lineUpList_5_12
            collectionView.reloadData()
            currentPage = 2
        }
    }
    
    private func configureDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lineUpList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "line_up_cell", for: indexPath) as! LineUpCell
        cell.backgroundColor = .clear
        cell.lineUp = lineUpList[indexPath.row]
        if indexPath.row == 0 {
            cell.location = .start
        } else if indexPath.row == lineUpList.count-1 {
            cell.location = .end
        } else {
            cell.location = .middle
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 88)
    }
}
