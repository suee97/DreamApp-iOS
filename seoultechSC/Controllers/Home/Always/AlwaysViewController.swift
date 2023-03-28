//
//  AlwaysViewController.swift
//  seoultechSC
//
//  Created by 변상우 on 2023/03/27.
//

import UIKit

class AlwaysViewController: UIViewController {
    
    private let scrollView : UIScrollView = UIScrollView()
    
    private let contentView : UIView = UIView()
    
    private let myInfoContainer: UIView = {
        let container = UIView()
        
        let myImage = UIImageView(frame: CGRect(x: 18, y: 15, width: 78, height: 78))
        myImage.image = UIImage(systemName: "person")
        myImage.contentMode = .scaleAspectFit
        
        let myName = UILabel(frame: CGRect(x: 113, y: 16, width: 100, height: 19))
        myName.text = "이름"
        myName.font = UIFont(name: "Pretendard-Bold", size: 16)
        
        let myCode = UILabel(frame: CGRect(x: 113, y: 48, width: 100, height: 16))
        myCode.text = "학번"
        myCode.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        let myGroup = UILabel(frame: CGRect(x: 113, y: 68, width: 100, height: 16))
        myGroup.text = "단과대학"
        myGroup.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        let myMajor = UILabel(frame: CGRect(x: 113, y: 88, width: 100, height: 16))
        myMajor.text = "학과"
        myMajor.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        container.addSubview(myImage)
        container.addSubview(myName)
        container.addSubview(myCode)
        container.addSubview(myGroup)
        container.addSubview(myMajor)
        
        container.layer.cornerRadius = 10
        
        return container
    }()
    
    private lazy var myReservationButton : ActionButton = {
        let myReservation = ActionButton(title: "내 예약 확인하기")
        myReservation.addTarget(self, action: #selector(myReservationBtn), for: .touchUpInside)
        
        return myReservation
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
        scrollView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        myInfoContainer.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(myInfoContainer)
        contentView.addSubview(myReservationButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        myInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        myReservationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            myInfoContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            myInfoContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            myInfoContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            myInfoContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            myInfoContainer.bottomAnchor.constraint(equalTo: myReservationButton.bottomAnchor),
            myReservationButton.topAnchor.constraint(equalTo: myInfoContainer.topAnchor, constant: 119),
            myReservationButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            myReservationButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
        ])
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        
    }

    
    // MARK: - Selectors
    @objc private func myReservationBtn() {
        print("logout")
    }
}
