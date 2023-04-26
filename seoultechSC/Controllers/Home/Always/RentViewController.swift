import UIKit
import Alamofire
import SnapKit

protocol SendDataDelegate {
    func sendDate(data: String)
}

class RentViewController: UIViewController, SendDataDelegate {
    func sendDate(data: String) {
        rentRange.text = data
    }
    
    var availableAmount : Int = 0
    
    let container: UIView = {
        let container = UIView()
        container.layer.cornerRadius = 10
        return container
    }()
    
    var itemTitle: UILabel = {
        let title = UILabel()
        title.text = "품목 이름"
        title.textColor = .black
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        return title
    }()
    
    var line: UILabel = {
        let line = UILabel()
        line.text = "  "
        line.font = UIFont(name: "Pretendard-Bold", size: 1)
        line.textColor = .white
        
        line.layer.borderWidth = 1
        line.layer.borderColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1).cgColor
        
        return line
    }()
    
    var rentRangeTitle: UILabel = {
        let title = UILabel()
        title.text = "기간"
        title.textColor = .black
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        return title
    }()
    
    var rentRangeButton: UIButton = {
        let RangeButton = UIButton()
        RangeButton.setImage(UIImage(named: "calendar"), for: .normal)
        RangeButton.addTarget(self, action: #selector(calendarOpenButton), for: .touchUpInside)
        
        return RangeButton
    }()
    
    var rentRange: GreyTextField = {
        let textField = GreyTextField()
        textField.configurePlaceholder("2000.00.00 - 00.00")
        textField.isUserInteractionEnabled = false
        
        return textField
    }()
    
    var rentPurposeTitle: UILabel = {
        let title = UILabel()
        title.text = "목적"
        title.textColor = .black
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        return title
    }()
    
    private lazy var rentPurpose: GreyTextField = {
        let textField = GreyTextField()
        textField.configurePlaceholder("물품 대여 목적을 적어주세요.")
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        return textField
    }()
    
    var rentAmountTitle: UILabel = {
        let title = UILabel()
        title.text = "수량"
        title.textColor = .black
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        return title
    }()
    
    private lazy var rentAmount: UIView = {
        let container = UIView()
        
        container.layer.cornerRadius = 10
        container.backgroundColor = .lightGrey
        container.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        return container
    }()
    
    var rentAmountLabel: UILabel = {
        let title = UILabel()
        title.text = "0"
        title.textColor = .black
        title.font = UIFont(name: "Pretendard-Regular", size: 16)
        title.textColor = .text_caption
        return title
    }()
    
    private lazy var plusButton : UIButton = {
        let plusbutton = UIButton()
        plusbutton.setImage(UIImage(named: "plus_button"), for: .normal)
        plusbutton.addTarget(self, action: #selector(plusButtonTouched), for: .touchUpInside)
        
        return plusbutton
    }()
    
    private lazy var minusButton : UIButton = {
        let minusbutton = UIButton()
        minusbutton.isEnabled = false
        minusbutton.setImage(UIImage(named: "minus_button"), for: .normal)
        minusbutton.addTarget(self, action: #selector(minusButtonTouched), for: .touchUpInside)
        
        return minusbutton
    }()

    var rentNoticeTitle: UILabel = {
        let title = UILabel()
        title.text = "주의사항"
        title.textColor = .black
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        return title
    }()
    
    private lazy var rentNotice: UIView = {
        let container = UIView()
        
        container.layer.cornerRadius = 10
        container.backgroundColor = .lightGrey
        container.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        return container
    }()
    
    private lazy var notice: UILabel = {
        let notice = UILabel()
        
        notice.text = changeNotice(category: itemTitle.text!)
        notice.numberOfLines = 10
        
        notice.textColor = .black
        notice.font = UIFont(name: "Pretendard-Regular", size: 14)
        notice.textColor = .black
        return notice
    }()
    
    private lazy var confirmButton: RadioButton = {
        let button = RadioButton()
        var config = UIButton.Configuration.plain()
        config.title = "동의합니다"
        config.attributedTitle?.font = UIFont(name: "Pretendard-Regular", size: 12)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.imagePadding = 7
        button.checked = false
        button.configuration = config
        button.titleLabel?.tintColor = .black
        button.addTarget(self, action: #selector(onTapNoticeConfirmButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var rentButton : ActionButton = {
        let button = ActionButton(title: "신청하기")
        
        button.setActive(false)
        
        button.addTarget(self, action: #selector(onTapRentButton), for: .touchUpInside)
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
        
        self.navigationItem.title = "상시사업 예약"
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureUI() {
        view.backgroundColor = .backgroundPurple
        container.backgroundColor = .white
        
        let ViewArr = [container, itemTitle, line, rentRangeTitle, rentRange, rentRangeButton, rentPurposeTitle, rentPurpose, rentAmountTitle, rentAmount, rentAmountLabel ,plusButton, minusButton, rentNoticeTitle, rentNotice, notice, confirmButton, rentButton]
        
        for i in ViewArr {
            view.addSubview(i)
            i.translatesAutoresizingMaskIntoConstraints = false
        }
        
        container.snp.makeConstraints({ m in
            m.left.right.equalTo(view).inset(getRatWidth(20))
            m.top.equalTo(view.safeAreaLayoutGuide).inset(getRatHeight(23))
            m.bottom.equalTo(view.safeAreaLayoutGuide).inset(getRatHeight(105))
        })
        
        itemTitle.snp.makeConstraints({ m in
            m.centerX.equalTo(container.snp.centerX)
            m.top.equalTo(container.snp.top).inset(getRatHeight(11))
        })
        
        line.snp.makeConstraints({ m in
            m.left.right.equalTo(container).inset(getRatWidth(11))
            m.height.equalTo(1)
            m.top.equalTo(itemTitle.snp.bottom).offset(getRatHeight(13))
        })
        
        rentRangeTitle.snp.makeConstraints({ m in
            m.left.equalTo(container).inset(getRatWidth(21))
            m.top.equalTo(line.snp.bottom).offset(getRatHeight(19))
        })
        
        rentRange.snp.makeConstraints({ m in
            m.left.right.equalTo(container).inset(getRatWidth(20))
            m.height.equalTo(40)
            m.top.equalTo(rentRangeTitle.snp.bottom).offset(getRatHeight(10))
        })
        
        rentRangeButton.snp.makeConstraints({ m in
            m.centerY.equalTo(rentRange)
            m.right.equalTo(rentRange).inset(getRatWidth(13))
        })
        
        rentPurposeTitle.snp.makeConstraints({ m in
            m.left.equalTo(container).inset(getRatWidth(21))
            m.top.equalTo(rentRange.snp.bottom).offset(getRatHeight(20))
        })
        
        NSLayoutConstraint.activate([
//            container.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
//            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
//            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            container.heightAnchor.constraint(equalToConstant: 540),

//            itemTitle.centerXAnchor.constraint(equalTo: container.centerXAnchor),
//            itemTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: 11),

//            line.centerXAnchor.constraint(equalTo: container.centerXAnchor),
//            line.topAnchor.constraint(equalTo: itemTitle.bottomAnchor, constant: 13),
//            line.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
//            line.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),

//            rentRangeTitle.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 19),
//            rentRangeTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 21),

//            rentRange.centerXAnchor.constraint(equalTo: container.centerXAnchor),
//            rentRange.topAnchor.constraint(equalTo: rentRangeTitle.bottomAnchor, constant: 10),
//            rentRange.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
//            rentRange.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            
//            rentRangeButton.centerYAnchor.constraint(equalTo: rentRange.centerYAnchor),
//            rentRangeButton.trailingAnchor.constraint(equalTo: rentRange.trailingAnchor, constant: -13),

//            rentPurposeTitle.topAnchor.constraint(equalTo: rentRange.bottomAnchor, constant: 20),
//            rentPurposeTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 21),

            rentPurpose.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            rentPurpose.topAnchor.constraint(equalTo: rentPurposeTitle.bottomAnchor, constant: 10),
            rentPurpose.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            rentPurpose.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),

            rentAmountTitle.topAnchor.constraint(equalTo: rentPurpose.bottomAnchor, constant: 20),
            rentAmountTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 21),

            rentAmount.topAnchor.constraint(equalTo: rentAmountTitle.bottomAnchor, constant: 10),
            rentAmount.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            rentAmount.widthAnchor.constraint(equalToConstant: 123),
            
            rentAmountLabel.centerXAnchor.constraint(equalTo: rentAmount.centerXAnchor),
            rentAmountLabel.centerYAnchor.constraint(equalTo: rentAmount.centerYAnchor),
            
            minusButton.centerYAnchor.constraint(equalTo: rentAmount.centerYAnchor),
            minusButton.leadingAnchor.constraint(equalTo: rentAmount.leadingAnchor, constant: 8),
            minusButton.widthAnchor.constraint(equalToConstant: 20),
            
            plusButton.centerYAnchor.constraint(equalTo: rentAmount.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: rentAmount.trailingAnchor, constant: -8),
            plusButton.widthAnchor.constraint(equalToConstant: 20),

            rentNoticeTitle.topAnchor.constraint(equalTo: rentAmount.bottomAnchor, constant: 20),
            rentNoticeTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 21),

            rentNotice.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            rentNotice.topAnchor.constraint(equalTo: rentNoticeTitle.bottomAnchor, constant: 10),
            rentNotice.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            rentNotice.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            
            notice.topAnchor.constraint(equalTo: rentNotice.topAnchor, constant: 14),
            notice.leadingAnchor.constraint(equalTo: rentNotice.leadingAnchor, constant: 14),
            notice.trailingAnchor.constraint(equalTo: rentNotice.trailingAnchor, constant: -14),

            confirmButton.topAnchor.constraint(equalTo: rentNotice.bottomAnchor, constant: 14),
            confirmButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 21),
            
            rentButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            rentButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 17),
            rentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            rentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func changeCategory(category: String) -> String {
        var kor_Category = category
        var eng_Catgory = ""
        switch kor_Category {
        case "돗자리" :
            eng_Catgory = "MAT"
        case "간이테이블" :
            eng_Catgory = "S_TABLE"
        case "듀라테이블" :
            eng_Catgory = "TABLE"
        case "앰프&마이크" :
            eng_Catgory = "AMP"
        case "캐노피" :
            eng_Catgory = "CANOPY"
        case "리드선" :
            eng_Catgory = "WIRE"
        case "L카" :
            eng_Catgory = "CART"
        case "의자" :
            eng_Catgory = "CHAIR"
        default:
            print("")
        }
        return eng_Catgory
    }
    
    private func changeNotice(category: String) -> String {
        var kor_Category = category
        var notice = ""
        switch kor_Category {
        case "돗자리" :
            notice = """
                    1. 찢어지지 않게 사용해주세요.\n
                    2. 깨끗하게 사용해주세요.
                    """
        case "간이테이블" :
            notice = "1. 깨끗하게 사용해주세요."
        case "듀라테이블" :
            notice = "1. 듀라테이블을 조립하거나 정리할 때, 테이블 다리 접합부 또는 관절 부분에 손이 끼이지 않도록 주의해주세요."
        case "앰프&마이크" :
            notice = """
                    1. 앰프에 물이 들어가지 않도록 해야 합니다. \n
                    2. 다른 장비를 연결한 뒤에 앰프의 전원을 켜주세요. \n
                    3. 사용 후에는 볼륨노브를 0으로 설정한 뒤 앰프의 전원을 끄고 장비를 분리해주세요.
                    """
        case "캐노피" :
            notice = """
                    1. 캐노피를 설치하거나 기둥 높이를 조절할 때에는 여럿이서 작업해야 합니다. \n
                    2. 운반 시에 끌지 않고 들어서 이동시켜야 합니다. \n
                    3. 캐노피를 경사면에 설치하지 않도록 해주세요.
                    """
        case "리드선" :
            notice = """
                    1. 선을 말아서 정리할 때, 릴의 한쪽으로 선이 치우치지 않도록 해주세요. \n
                    2. 리드선을 모두 풀어서 사용해야 부하를 최소화할 수 있습니다.
                    """
        case "L카" :
            notice = """
                    1. 바퀴가 고장나지 않도록 조심히 다뤄주세요. \n
                    2. 카트를 끌 때, 사람이 올라타지 않도록 해야합니다.
                    """
        case "의자" :
            notice = """
                    1. 의자를 포개서 정리할 때, 의자 사이에 손이 끼이지 않도록 주의해주세요. \n
                    2. 의자 위에 무거운 물건을 올리지 말아주세요.
                    """
        default:
            print("")
        }
        return notice
    }
    
    private func checkAllInfo() {
        if (rentRange.text != nil && rentPurpose.text!.count != 0 && rentAmountLabel.text != "0" && confirmButton.checked != false) {
            rentButton.setActive(true)
        } else {
            rentButton.setActive(false)
        }
    }
    
    @objc private func calendarOpenButton() {
        let vc = CalendarModal()
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func textFieldDidChange(_ sender: Any?) {
        checkAllInfo()
    }
    
    @objc private func plusButtonTouched() {
        var amount = rentAmountLabel.text!
        
        if (Int(amount) == availableAmount - 1) {
            plusButton.isEnabled = false
        }
        
        amount = String(Int(amount)! + 1)
        rentAmountLabel.text = amount
        rentAmountLabel.textColor = .black
        minusButton.isEnabled = true
        
        checkAllInfo()
    }
    
    @objc private func minusButtonTouched() {
        var amount = rentAmountLabel.text!
        
        if amount == "1" {
            minusButton.isEnabled = false
        }
        plusButton.isEnabled = true
        
        amount = String(Int(amount)! - 1)
        rentAmountLabel.text = amount
        rentAmountLabel.textColor = .black
        
        checkAllInfo()
    }
    
    @objc private func onTapNoticeConfirmButton() {
        confirmButton.changeState()
        checkAllInfo()
    }
    
    @objc private func onTapRentButton() {
        PostRentRequest(completion: {result in
            if result == .success {
                guard let viewControllerStack = self.navigationController?.viewControllers else { return }
                
                for viewController in viewControllerStack {
                    if let vc = viewController as? AlwaysViewController {
                        self.navigationController?.popToViewController(vc, animated: true)
                    }
                }
            } else if result == .expired {
                AuthHelper.shared.refreshAccessToken(completion: {result in
                    if result == .refreshed {
                        self.PostRentRequest(completion: { result in
                            if result == .success {
                                guard let viewControllerStack = self.navigationController?.viewControllers else { return }
                                
                                for viewController in viewControllerStack {
                                    if let vc = viewController as? AlwaysViewController {
                                        self.navigationController?.popToViewController(vc, animated: true)
                                    }
                                }
                            } else {
                                showToast(view: self.view, message: "오류가 발생했습니다.")
                            }
                        })
                    } else {
                        
                    }
                })
            } else {
                
            }
        })
    }
    
    private func PostRentRequest(completion: @escaping (PostRentResult) -> Void) {
        let url = "\(api_url)/rent"
        
        let aToken = KeychainHelper.sharedKeychain.getAccessToken() ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(aToken)"
        ]
        
        let params = ["purpose" : rentPurpose.text!,
                      "account" : Int(rentAmountLabel.text!)!,
                      "itemCategory" : changeCategory(category: itemTitle.text!),
                      "startTime" : String(rentRange.text!.prefix(10)),
                      "endTime": String(rentRange.text!.suffix(10))] as Dictionary
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: header)
        .responseJSON { response in
            switch response.result {
            case.success:
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(MyRentDataApiResult.self, from: responseData)
                    
                    if result.status == 200 {
                        completion(.success)
                        return
                    }
                    if result.errorCode == "ST011" {
                        completion(.expired)
                        return
                    }
                    if result.errorCode == "ST054" {
                        self.view.makeToast("해당 날짜에 요청하신 갯수만큼 물품을 대여하실 수 없습니다.")
                        completion(.fail)
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
}

enum PostRentResult {
    case success
    case expired
    case fail
}






class CalendarModal: UIViewController {
    
    var delegate: SendDataDelegate?
    
    var sendStartDay : String = ""
    var sendEndDay : String = ""
    
    private let modalView: UIView = {
        let view = UIView()
        view.configureModalView()
        
        return view
    }()
    
    private var startDay: UILabel = {
        var startDay = UILabel()
        startDay.text = "시작일"
        startDay.font = UIFont(name: "Pretendard-Bold", size: 16)
        startDay.textColor = .black
        return startDay
    }()
    
    private var line: UILabel = {
        var startDay = UILabel()
        startDay.text = "-"
        startDay.font = UIFont(name: "Pretendard-Bold", size: 16)
        startDay.textColor = .black
        return startDay
    }()
    
    private var endDay: UILabel = {
        var endDay = UILabel()
        endDay.text = "종료일"
        endDay.textColor = .black
        endDay.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        return endDay
    }()
    
    private lazy var rentOneDayButton: ActionButton = {
        let button = ActionButton(title: "1일 대여", height: 30)
        button.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 12)
        button.addTarget(self, action: #selector(onTapRentOneDayButton), for: .touchUpInside)
        button.setActive(false)
        return button
    }()
    
    private let datePicker = UIDatePicker()
    
    private lazy var cancelButton: ActionButton = {
        let button = ActionButton(title: "취소", backgroundColor: .secondaryPurple, height: 34)
        button.addTarget(self, action: #selector(onTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton: ActionButton = {
        let button = ActionButton(title: "확인", height: 34)
        button.setActive(false)
        button.addTarget(self, action: #selector(onTapConfirmButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    private func configureUI() {
            setAttributes()
            setContraints()
        }
    
    private func setAttributes() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
        
        datePicker.backgroundColor = .white
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        
        datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        
        var components = DateComponents()
        components.day = 0
        
        let todayDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
        
        datePicker.minimumDate = todayDate
    }

    private func setContraints() {
        view.addSubview(modalView)
        modalView.addSubview(datePicker)
        modalView.addSubview(cancelButton)
        modalView.addSubview(confirmButton)
        modalView.addSubview(startDay)
        modalView.addSubview(endDay)
        modalView.addSubview(line)
        modalView.addSubview(rentOneDayButton)
        modalView.translatesAutoresizingMaskIntoConstraints = false
        startDay.translatesAutoresizingMaskIntoConstraints = false
        endDay.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        rentOneDayButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            modalView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            modalView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modalView.heightAnchor.constraint(equalToConstant: 450),
            line.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            line.centerYAnchor.constraint(equalTo: startDay.centerYAnchor),
            startDay.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 20),
            startDay.centerXAnchor.constraint(equalTo: modalView.centerXAnchor, constant: -50),
            endDay.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 20),
            endDay.centerXAnchor.constraint(equalTo: modalView.centerXAnchor, constant: 50),
            rentOneDayButton.centerYAnchor.constraint(equalTo: startDay.centerYAnchor),
            rentOneDayButton.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -20),
            rentOneDayButton.widthAnchor.constraint(equalToConstant: 60),
            datePicker.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 10),
            datePicker.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -10),
            datePicker.topAnchor.constraint(equalTo: endDay.bottomAnchor, constant: 10),
            cancelButton.bottomAnchor.constraint(equalTo: modalView.bottomAnchor, constant: -20),
            cancelButton.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 160),
            confirmButton.bottomAnchor.constraint(equalTo: modalView.bottomAnchor, constant: -20),
            confirmButton.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -20),
            confirmButton.widthAnchor.constraint(equalToConstant: 160),
        ])
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true)
    }
    
    @objc private func onTapCancelButton() {
        dismissModal()
    }
    
    @objc private func onTapConfirmButton() {
        let data = sendStartDay + " ~ " + sendEndDay
        delegate?.sendDate(data: data)
        dismissModal()
    }
    
    @objc private func onTapRentOneDayButton() {
        endDay.text = startDay.text
        sendEndDay = sendStartDay
        confirmButton.setActive(true)
    }

    @objc private func handleDatePicker(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        if (startDay.text == "시작일") {
            confirmButton.setActive(false)
            formatter.dateFormat = "MM월 dd일"
            startDay.text = formatter.string(from: sender.date)
            rentOneDayButton.setActive(true)
            
            formatter.dateFormat = "YYYY-MM-dd"
            sendStartDay = formatter.string(from: sender.date)
            
        } else if (endDay.text == "종료일") {
            confirmButton.setActive(false)
            formatter.dateFormat = "MM월 dd일"
            var firstMonth = startDay.text?.prefix(2)
            var secondMonth = formatter.string(from: sender.date).prefix(2)
            
            var firstDay = startDay.text!.suffix(3)
            var secondDay = formatter.string(from: sender.date).suffix(3)
            
            firstDay = firstDay.dropLast(1)
            secondDay = secondDay.dropLast(1)
            
            if (firstMonth == secondMonth) {
                if Int(firstDay)! > Int(secondDay)! {
                    confirmButton.setActive(false)
                    startDay.text = formatter.string(from: sender.date)
                    formatter.dateFormat = "YYYY-MM-dd"
                    sendStartDay = formatter.string(from: sender.date)
                } else {
                    confirmButton.setActive(true)
                    endDay.text = formatter.string(from: sender.date)
                    formatter.dateFormat = "YYYY-MM-dd"
                    sendEndDay = formatter.string(from: sender.date)
                }
            } else if (firstMonth! < secondMonth) {
                confirmButton.setActive(true)
                endDay.text = formatter.string(from: sender.date)
                formatter.dateFormat = "YYYY-MM-dd"
                sendEndDay = formatter.string(from: sender.date)
            } else if (firstMonth! > secondMonth) {
                confirmButton.setActive(false)
                startDay.text = formatter.string(from: sender.date)
                formatter.dateFormat = "YYYY-MM-dd"
                sendStartDay = formatter.string(from: sender.date)
            }
        } else {
            confirmButton.setActive(false)
            formatter.dateFormat = "MM월 dd일"
            startDay.text = formatter.string(from: sender.date)
            endDay.text = "종료일"
        }
    }
}

import SwiftUI
#if DEBUG
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
    @available(iOS 13.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        RentViewController()
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
}

#endif
