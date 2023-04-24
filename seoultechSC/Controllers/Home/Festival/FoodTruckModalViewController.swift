import UIKit
import SnapKit
import Alamofire

class FoodTruckModalViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var foodTruckList: [FoodTruck] = []
    
    private lazy var backgroundButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .modalBackground
        button.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        return button
    }()
    
    private let modalView: UIView = {
        let view = UIView()
        view.configureModalView()
        return view
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .text_caption
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "푸드트럭 소개"
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        return label
    }()
    
    private let foodTruckContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.snp.makeConstraints({ m in
            m.width.equalTo(280)
            m.height.equalTo(340)
        })
        return view
    }()
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    private lazy var foodTruckCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FoodTruckCell.self, forCellWithReuseIdentifier: "food_truck_cell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureModalView()
        foodTruckCollectionView.delegate = self
        foodTruckCollectionView.dataSource = self
    }
    
    private func configureUI() {
        view.addSubview(backgroundButton)
        view.addSubview(modalView)
        modalView.addSubview(indicator)
        
        backgroundButton.snp.makeConstraints({ m in
            m.left.right.top.bottom.equalTo(view)
        })
        modalView.snp.makeConstraints({ m in
            m.centerX.centerY.equalTo(view)
            m.width.equalTo(320)
            m.height.equalTo(425)
        })
        indicator.snp.makeConstraints({ m in
            m.centerX.centerY.equalTo(modalView)
        })
    }
    
    private func configureModalView() {
        let url = "\(api_url)/food-trucks"
        AF.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(FoodTruckApiResult.self, from: responseData)
                    if result.status == 200 {
                        let dataCount = result.data[0].truckList.count
                        for foodTruck in result.data[0].truckList {
                            self.foodTruckList.append(FoodTruck(truckId: foodTruck.truckId, truckName: foodTruck.truckName, truckDescription: foodTruck.truckDescription ?? "", truckLocation: foodTruck.truckLocation))
                        }
                        self.configureCollectionView()
                        self.indicator.stopAnimating()
                        return
                    }
                    showToast(view: self.view, message: "오류가 발생했습니다.")
                    self.indicator.stopAnimating()
                } catch {
                    showToast(view: self.view, message: "오류가 발생했습니다.")
                    self.indicator.stopAnimating()
                }
            case .failure:
                showToast(view: self.view, message: "오류가 발생했습니다.")
                self.indicator.stopAnimating()
            }
        }
    }
    
    private func configureCollectionView() {
        modalView.backgroundColor = .backgroundPurple
        modalView.addSubview(foodTruckContainer)
        modalView.addSubview(titleLabel)
        modalView.addSubview(foodTruckCollectionView)
        
        titleLabel.snp.makeConstraints({ m in
            m.centerX.equalTo(modalView)
            m.top.equalTo(modalView).inset(25)
        })
        foodTruckContainer.snp.makeConstraints({ m in
            m.centerX.equalTo(modalView)
            m.top.equalTo(modalView).inset(65)
        })
        foodTruckCollectionView.snp.makeConstraints({ m in
            m.centerX.equalTo(modalView)
            m.width.equalTo(248)
            m.top.equalTo(foodTruckContainer.snp.top).inset(24)
            m.bottom.equalTo(foodTruckContainer.snp.bottom).inset(8)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodTruckList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "food_truck_cell", for: indexPath) as! FoodTruckCell
        cell.nameLabel.text = foodTruckList[indexPath.row].truckLocation
        cell.descLabel.text = foodTruckList[indexPath.row].truckDescription
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = NSString(string: foodTruckList[indexPath.row].truckDescription!).boundingRect(
            with: CGSize(width: 248, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
            ],
            context: nil)
        
        return CGSize(width: 248, height: cellSize.height + 44)
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true)
    }
}
