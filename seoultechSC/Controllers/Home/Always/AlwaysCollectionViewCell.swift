//
//  AlwaysCollectionViewCell.swift
//  seoultechSC
//
//  Created by 변상우 on 2023/03/28.
//

import UIKit

class AlwaysCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AlwaysCollectionViewCell"
    
    private let itemImageViewSize : CGFloat = 40
    
    private let itemImageView : UIImageView = {
        
        var imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 10
        
        return imageView
    }()
    
    private let itemTitle : UILabel = {
        
        var itemTitle = UILabel()
        itemTitle.backgroundColor = .secondaryPurple
        itemTitle.clipsToBounds = true
        itemTitle.layer.cornerRadius = 10
        itemTitle.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        return itemTitle
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
        setConstraint()
    }
    
    private func setUI() {
        self.addSubview(itemImageView)
        self.addSubview(itemTitle)
    }
    
    private func setConstraint() {
        
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            itemImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            itemImageView.widthAnchor.constraint(equalToConstant: itemImageViewSize),
            itemImageView.heightAnchor.constraint(equalToConstant: itemImageViewSize),
            itemImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            itemTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 74),
            itemTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            itemTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            itemTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            itemTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
    }
    
}
