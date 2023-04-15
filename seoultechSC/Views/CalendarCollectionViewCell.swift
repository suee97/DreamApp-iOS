//
//  CalendarCollectionViewCell.swift
//  seoultechSC
//
//  Created by 변상우 on 2023/04/01.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CalendarCollectionViewCell"
    
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
            dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func update(day: String) {
        dayLabel.text = day
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
}
