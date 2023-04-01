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
}
