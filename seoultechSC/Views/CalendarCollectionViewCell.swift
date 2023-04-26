import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CalendarCollectionViewCell"
    
    private var circularProgressBarView = CircularProgressBar()
    
    private lazy var dayLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    private func configure() {
        self.addSubview(dayLabel)
        
        dayLabel.font = UIFont(name: "Pretendard-Bold", size: 15)
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func update(day: String) {
        dayLabel.text = day
        self.isUserInteractionEnabled = true
        circularProgressBarView.isHidden = true
    }
    
    func checkWeekend(indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == 7 || indexPath.row == 14 || indexPath.row == 21 || indexPath.row == 28 || indexPath.row == 35  {
            dayLabel.textColor = .red
        }
        else if indexPath.row == 6 || indexPath.row == 13 || indexPath.row == 20 || indexPath.row == 27 || indexPath.row == 34 {
            dayLabel.textColor = .blue
        }
        else {
            dayLabel.textColor = .black
        }
    }
    
    func drawCircle(day: String, alreadyRentDataList: [AlreadyRentData], totalAmount: Int, availableAmount: Int) {
        if (alreadyRentDataList.count == 0) {
            self.isUserInteractionEnabled = true
            circularProgressBarView.isHidden = true
        }
        
        for rent in alreadyRentDataList {
            if (rent.startMonth.prefix(2) == rent.endMonth.prefix(2)) {
                // 대여기간 : 04.01 ~ 04.05 일때,  2,3,4일 체크
                if ((rent.startTime < Int(day) ?? 0) && (Int(day) ?? 0 < rent.endTime)) {
                    self.isUserInteractionEnabled = true
                    circularProgressBarView.isHidden = false
                    self.addSubview(circularProgressBarView)
                    
                    circularProgressBarView.setProgress(self.circularProgressBarView.bounds, strokeEnd: CGFloat(totalAmount - availableAmount) / CGFloat(totalAmount))
                    
                    circularProgressBarView.translatesAutoresizingMaskIntoConstraints = false
                    
                    NSLayoutConstraint.activate([
                        circularProgressBarView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                        circularProgressBarView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    ])
                    circularProgressBarView.setNeedsDisplay()
                    
                    // 대여기간 : 04.03 ~ 04.03 일때,  3일 체크 (하루 대여하는 날 표시)
                } else if ((rent.startTime == Int(day) ?? 0) && (Int(day) ?? 0 == rent.endTime)) {
                    self.isUserInteractionEnabled = true
                    circularProgressBarView.isHidden = false
                    self.addSubview(circularProgressBarView)
                    
                    circularProgressBarView.setProgress(self.circularProgressBarView.bounds, strokeEnd: CGFloat(totalAmount - availableAmount) / CGFloat(totalAmount))
                    
                    circularProgressBarView.translatesAutoresizingMaskIntoConstraints = false
                    
                    NSLayoutConstraint.activate([
                        circularProgressBarView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                        circularProgressBarView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    ])
                    circularProgressBarView.setNeedsDisplay()
                    
                    // 대여기간 : 04.01 ~ 04.05 일때,  1,5일 체크
                } else if ((rent.startTime == Int(day) ?? 0) || (Int(day) ?? 0 == rent.endTime)) {
                    self.isUserInteractionEnabled = true
                    circularProgressBarView.isHidden = false
                    self.addSubview(circularProgressBarView)
                    
                    circularProgressBarView.setProgress(self.circularProgressBarView.bounds, strokeEnd: CGFloat(totalAmount - availableAmount) / CGFloat(totalAmount))
                    
                    circularProgressBarView.translatesAutoresizingMaskIntoConstraints = false
                    
                    NSLayoutConstraint.activate([
                        circularProgressBarView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                        circularProgressBarView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    ])
                    circularProgressBarView.setNeedsDisplay()
                }
                // 대여기간 : 07.30 ~ 08.03 일때,
            } else if (rent.startMonth.prefix(2) != rent.endMonth.prefix(2)) {
                // 7월 달력에 30,31일 표시
                if (Int(rent.currentMonth) == Int(rent.startMonth.prefix(2))) {
                    if (rent.startTime <= Int(day) ?? 0) {
                        self.isUserInteractionEnabled = true
                        circularProgressBarView.isHidden = false
                        self.addSubview(circularProgressBarView)
                        
                        circularProgressBarView.setProgress(self.circularProgressBarView.bounds, strokeEnd: CGFloat(totalAmount - availableAmount) / CGFloat(totalAmount))
                        
                        circularProgressBarView.translatesAutoresizingMaskIntoConstraints = false
                        
                        NSLayoutConstraint.activate([
                            circularProgressBarView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                            circularProgressBarView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                        ])
                        circularProgressBarView.setNeedsDisplay()
                    }
                // 8월 달력에 1,2,3일 표시
                } else if (Int(rent.currentMonth) == Int(rent.endMonth.prefix(2))) {
                    if (rent.endTime >= Int(day) ?? 0) {
                        self.isUserInteractionEnabled = true
                        circularProgressBarView.isHidden = false
                        self.addSubview(circularProgressBarView)
                        
                        circularProgressBarView.setProgress(self.circularProgressBarView.bounds, strokeEnd: CGFloat(totalAmount - availableAmount) / CGFloat(totalAmount))
                        
                        circularProgressBarView.translatesAutoresizingMaskIntoConstraints = false
                        
                        NSLayoutConstraint.activate([
                            circularProgressBarView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                            circularProgressBarView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                        ])
                        circularProgressBarView.setNeedsDisplay()
                    }
                }
            }
        }
        if (day == "") {
            self.isUserInteractionEnabled = false
            circularProgressBarView.isHidden = true
        }
    }
}
