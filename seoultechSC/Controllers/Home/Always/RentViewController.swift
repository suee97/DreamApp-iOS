import UIKit
import Alamofire

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
        title.font = UIFont(name: "Pretendard-Bold", size: 16)
        return title
    }()
    
    private lazy var rentNotice: UIView = {
        let container = UIView()
        
        container.layer.cornerRadius = 10
        container.backgroundColor = .lightGrey
        container.heightAnchor.constraint(equalToConstant: 76).isActive = true
        
        return container
    }()
    
    private lazy var notice: UILabel = {
        let notice = UILabel()
        
        notice.text = "주의사항"
        notice.textColor = .black
        notice.font = UIFont(name: "Pretendard-Regular", size: 14)
        
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
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            container.bottomAnchor.constraint(equalTo: rentButton.topAnchor, constant: -17),

            itemTitle.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            itemTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: 11),

            line.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            line.topAnchor.constraint(equalTo: itemTitle.bottomAnchor, constant: 13),
            line.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            line.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),

            rentRangeTitle.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 19),
            rentRangeTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 21),

            rentRange.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            rentRange.topAnchor.constraint(equalTo: rentRangeTitle.bottomAnchor, constant: 10),
            rentRange.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            rentRange.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            
            rentRangeButton.centerYAnchor.constraint(equalTo: rentRange.centerYAnchor),
            rentRangeButton.trailingAnchor.constraint(equalTo: rentRange.trailingAnchor, constant: -13),

            rentPurposeTitle.topAnchor.constraint(equalTo: rentRange.bottomAnchor, constant: 20),
            rentPurposeTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 21),

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

            confirmButton.topAnchor.constraint(equalTo: rentNotice.bottomAnchor, constant: 14),
            confirmButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 21),
            
            rentButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            rentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -38),
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
    
    private func checkAllInfo() {
        print(rentPurpose.text?.count)
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
        print("서버로 전송")
        print(rentPurpose.text!)
        print(Int(rentAmountLabel.text!)!)
        print(changeCategory(category: itemTitle.text!))
        print(String(rentRange.text!.prefix(10)))
        print(String(rentRange.text!.suffix(10)))
        PostRentRequest()
    }
    
    private func PostRentRequest() {
        let url = "\(api_url)/rent"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        
        let params = ["purpose" : rentPurpose.text!,
                      "account" : Int(rentAmountLabel.text!)!,
                      "itemCategory" : changeCategory(category: itemTitle.text!),
                      "startTime" : String(rentRange.text!.prefix(10)),
                      "endTime": String(rentRange.text!.suffix(10))] as Dictionary
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseString { response in
            switch response.result {
            case .success:
                print("success")
            case .failure:
                print("fail")
            }
        }
    }
    
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
        
        return startDay
    }()
    
    private var line: UILabel = {
        var startDay = UILabel()
        startDay.text = "-"
        startDay.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        return startDay
    }()
    
    private var endDay: UILabel = {
        var endDay = UILabel()
        endDay.text = "종료일"
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
    }

    @objc private func handleDatePicker(_ sender: UIDatePicker) {
        print("touch")
        
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
            var firstDay = startDay.text!.suffix(3)
            var secondDay = formatter.string(from: sender.date).suffix(3)
            
            firstDay = firstDay.dropLast(1)
            secondDay = secondDay.dropLast(1)
            
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
        } else {
            confirmButton.setActive(false)
            formatter.dateFormat = "MM월 dd일"
            startDay.text = formatter.string(from: sender.date)
            endDay.text = "종료일"
        }
    }
}
