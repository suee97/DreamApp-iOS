import UIKit
import Alamofire

class AlwaysRentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private var calendarYear = Date()
    private var calendarMonth = Date()
    private var days = [String]()
    
    
    let itemInfoContainer: UIView = {
        let container = UIView()
        container.layer.cornerRadius = 10
        
        return container
    }()
    
    var itemImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 120))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        
        return imageView
    }()
    
    var itemTitle: UILabel = {
        let title = UILabel()
        title.text = "품목명"
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        return title
    }()
    
    var item: UILabel = {
        let item = UILabel()
        item.font = UIFont(name: "Pretendard-Regular", size: 12)
        return item
    }()
    
    var totalAmountTitle: UILabel = {
        let title = UILabel()
        title.text = "총 수량"
        title.font = UIFont(name: "Pretendard-Bold", size: 12)
        return title
    }()
    
    var purposeTitle: UILabel = {
        let title = UILabel()
        title.text = "사용 목적"
        title.font = UIFont(name: "Pretendard-Bold", size: 12)
        return title
    }()
    
    var totalAmount: UILabel = {
        let title = UILabel()
        title.font = UIFont(name: "Pretendard-Regular", size: 12)
        return title
    }()
    
    var purpose: UILabel = {
        let title = UILabel()
        title.numberOfLines = 3
        title.font = UIFont(name: "Pretendard-Regular", size: 12)
        return title
    }()
    
    // 캘린더 구현
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var titleLabel : UILabel = {
        let title = UILabel()
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        title.textColor = .navy
        
        return title
    }()
    
    private lazy var preButton : UIButton = {
        let preButton = UIButton()
        preButton.setImage(UIImage(named: "preButton"), for: .normal)
        preButton.addTarget(self, action: #selector(prevButtonTouched), for: .touchUpInside)
        
        return preButton
    }()
    
    private lazy var nextButton : UIButton = {
        let nextButton = UIButton()
        nextButton.setImage(UIImage(named: "nextButton"), for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonTouched), for: .touchUpInside)
        
        return nextButton
    }()
        
    private var weekStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        
        
        return collectionView
    }()
    
    private lazy var itemInfoBar = UIView()
    
    private let selectedText : UILabel = {
        let title = UILabel()
        title.text = "선택한 날짜: "
        title.textColor = .navy
        title.font = UIFont(name: "Pretendard-Bold", size: 12)
        
        return title
    }()
    
    private lazy var selectedDay = UILabel()
    private lazy var availableAmount = UILabel()
    
    private let availableText : UILabel = {
        let title = UILabel()
        title.text = "개 대여 가능"
        title.textColor = .navy
        title.font = UIFont(name: "Pretendard-Bold", size: 12)
        
        return title
    }()
    
    private lazy var rentButton : ActionButton = {
        let button = ActionButton(title: "대여하러 가기")
        button.addTarget(self, action: #selector(rentBtn), for: .touchUpInside)
        
        return button
    }()

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureCollectionViewDelegate()
        configureCalendar()
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
        
        self.navigationItem.title = "상시사업 예약"
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .backgroundPurple
        itemInfoContainer.backgroundColor = .white
        scrollView.backgroundColor = .clear
        contentView.backgroundColor = .white
        collectionView.backgroundColor = .white
        itemInfoBar.backgroundColor = .secondaryPurple
        itemInfoBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        itemInfoBar.layer.cornerRadius = 10
        
        configureWeekLabel()
        scrollView.layer.cornerRadius = 10
        contentView.layer.cornerRadius = 10
        collectionView.layer.cornerRadius = 10
        
        view.addSubview(itemInfoContainer)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.addSubview(rentButton)
        
        let contentViewArr = [titleLabel, preButton, nextButton, weekStackView, collectionView, itemInfoBar, selectedText, selectedDay, availableText, availableAmount]
        
        for i in contentViewArr {
            contentView.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
        }
        
        itemInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        rentButton.translatesAutoresizingMaskIntoConstraints = false
        
        let infoViewArr = [itemImageView, itemTitle, item, totalAmountTitle, purposeTitle, totalAmount, purpose]
        
        for i in infoViewArr {
            itemInfoContainer.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            itemInfoContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            itemInfoContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            itemInfoContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            itemInfoContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            itemInfoContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 196),
            itemImageView.centerYAnchor.constraint(equalTo: itemInfoContainer.centerYAnchor),
            itemImageView.leadingAnchor.constraint(equalTo: itemInfoContainer.leadingAnchor, constant: 17),
            itemTitle.topAnchor.constraint(equalTo: itemInfoContainer.topAnchor, constant: 25),
            itemTitle.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 16),
            item.leadingAnchor.constraint(equalTo: itemTitle.trailingAnchor, constant: 28),
            item.centerYAnchor.constraint(equalTo: itemTitle.centerYAnchor),
            totalAmountTitle.topAnchor.constraint(equalTo: itemInfoContainer.topAnchor, constant: 57),
            totalAmountTitle.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 16),
            totalAmount.leadingAnchor.constraint(equalTo: item.leadingAnchor),
            totalAmount.centerYAnchor.constraint(equalTo: totalAmountTitle.centerYAnchor),
            purposeTitle.topAnchor.constraint(equalTo: itemInfoContainer.topAnchor, constant: 83),
            purposeTitle.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 16),
            purpose.leadingAnchor.constraint(equalTo: item.leadingAnchor),
            purpose.trailingAnchor.constraint(equalTo: itemInfoContainer.trailingAnchor, constant: -16),
            purpose.topAnchor.constraint(equalTo: purposeTitle.topAnchor),
            // 캘린더 위치
            scrollView.topAnchor.constraint(equalTo: itemInfoContainer.bottomAnchor, constant: 10),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -89),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            preButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            preButton.widthAnchor.constraint(equalToConstant: 90),
            preButton.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -30),
            nextButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 90),
            nextButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 30),
            weekStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13),
            weekStackView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            weekStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            weekStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: weekStackView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: weekStackView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: weekStackView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 1.5),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            itemInfoBar.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -41),
            itemInfoBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemInfoBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itemInfoBar.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            selectedText.centerYAnchor.constraint(equalTo: itemInfoBar.centerYAnchor),
            selectedText.leadingAnchor.constraint(equalTo: itemInfoBar.leadingAnchor, constant: 8),
            selectedDay.centerYAnchor.constraint(equalTo: itemInfoBar.centerYAnchor),
            selectedDay.leadingAnchor.constraint(equalTo: selectedText.trailingAnchor, constant: 3),
            availableText.centerYAnchor.constraint(equalTo: itemInfoBar.centerYAnchor),
            availableText.trailingAnchor.constraint(equalTo: itemInfoBar.trailingAnchor, constant: -8),
            availableAmount.centerYAnchor.constraint(equalTo: itemInfoBar.centerYAnchor),
            availableAmount.trailingAnchor.constraint(equalTo: availableText.leadingAnchor, constant: 3),
            rentButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -22),
            rentButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            rentButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        ])
        
    }
    
    private func configureCollectionViewDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func configureWeekLabel() {
        let dayOfWeek = ["일","월","화","수","목","금","토"]
        
        for i in 0..<7 {
            let label = UILabel()
            label.text = dayOfWeek[i]
            label.font = UIFont(name: "Pretendard-Regular", size: 12)
            label.textAlignment = .center
            weekStackView.addArrangedSubview(label)
            
            if i == 0 {
                label.textColor = .red
            } else if i == 6 {
                label.textColor = .blue
            }
        }
    }
    
    private func configureCalendar() {
        let components = calendar.dateComponents([.year, .month], from: Date())
        calendarMonth = calendar.date(from: components) ?? Date()
        dateFormatter.dateFormat = "MM월"
        updateCalendar()
    }
    
    // 일요일: 1, 토요일: 7 로 반환되니 0번 인덱스를 일요일로 표시해주기 위해 -1을 해줌
    private func startDayOfTheWeek() -> Int {
        return calendar.component(.weekday, from: calendarMonth) - 1
    }
    
    // 해당 달의 날짜가 며칠까지 있는지 계산 후 반환
    private func endDate() -> Int {
        return calendar.range(of: .day, in: .month, for: calendarMonth)?.count ?? Int()
    }
    
    private func updateTitle() {
        let date = dateFormatter.string(from: calendarMonth)
        titleLabel.text = date + " 예약 현황"
    }
    
    private func updateDays() {
        days.removeAll()
        let startDayOfTheWeek = startDayOfTheWeek()
        let totalDays = startDayOfTheWeek + endDate()
        
        for day in Int() ..< totalDays {
            if day < startDayOfTheWeek {
                days.append("")
                continue
            }
            days.append("\(day - startDayOfTheWeek + 1)")
        }
        
        collectionView.reloadData()
    }
    
    private func updateCalendar() {
        updateTitle()
        updateDays()
        fetchRent()
    }
    
    private func minusMonth() {
        calendarMonth = calendar.date(byAdding: DateComponents(month: -1), to: calendarMonth) ?? Date()
        updateCalendar()
    }
    
    private func plusMonth() {
        calendarMonth = calendar.date(byAdding: DateComponents(month: 1), to: calendarMonth) ?? Date()
        updateCalendar()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell else {
            return UICollectionViewCell() }
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1).cgColor
        cell.backgroundColor = .white
        selectedDay.text = ""
        cell.update(day: days[indexPath.item])
        cell.checkWeekend(indexPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCollectionViewCell
        
        let components = calendar.dateComponents([.year, .month], from: Date())
        calendarMonth = calendar.date(from: components) ?? Date()
        dateFormatter.dateFormat = "MM월"
        
        
        
        selectedDay.text = days[indexPath.item] + "일"
        selectedDay.textColor = .navy
        selectedDay.font = UIFont(name: "Pretendard-Bold", size: 12)
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 0.486, green: 0.529, blue: 0.949, alpha: 1).cgColor
        cell.backgroundColor = UIColor(red: 0.914, green: 0.937, blue: 1, alpha: 1)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCollectionViewCell
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1).cgColor
        cell.backgroundColor = .white
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = weekStackView.frame.width / 7
        return CGSize(width: width, height: width * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
//month: Int, year: Int, category: String
    private func fetchRent() {
        let url = "\(api_url)/rent/calendar?month=4&year=2023&category=TABLE"
        AF.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success:
                print("success")
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(RentApiResult.self, from: responseData)
                    let dataCount = result.data?.count
                    
                    print(result)

                    if result.status == 200 && dataCount != 0 {
                        for rent in result.data! {
                            print(rent)
                        }
                    }


                } catch {

                }
            case .failure:
                print("fail")
            }
        }

    }
    
    @objc private func prevButtonTouched(_ sender: UIButton) {
        minusMonth()
    }
    
    @objc private func nextButtonTouched(_ sender: UIButton) {
        plusMonth()
    }
    
    @objc private func rentBtn() {
        let vc = RentViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
