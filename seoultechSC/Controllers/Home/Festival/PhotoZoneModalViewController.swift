import UIKit
import Alamofire
import SnapKit

class PhotoZoneModalViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    let imageScrollViewWidth: CGFloat = 280
    var photoZoneListWithImage: [PhotoZoneWithImage] = []

    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .text_caption
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    private lazy var backgroundButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .modalBackground
        button.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        return button
    }()
    
    private let modalView: UIView = {
        let view = UIView()
        view.configureModalView()
        view.backgroundColor = .backgroundPurple
        return view
    }()
    
    private let photoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "포토존"
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        return label
    }()
    
    lazy var imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .clear
        scrollView.delegate = self
        return scrollView
    }()
    
    private let imagePageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.backgroundColor = .clear
        pageControl.pageIndicatorTintColor = .secondaryPurple
        pageControl.currentPageIndicatorTintColor = .primaryPurple
        pageControl.hidesForSinglePage = false
        return pageControl
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPhotoData()
    }
    
    private func configureUI() {
        view.backgroundColor = .modalBackground
        
        view.addSubview(backgroundButton)
        view.addSubview(modalView)
        view.addSubview(photoContainer)
        view.addSubview(titleLabel)
        view.addSubview(indicator)
        
        backgroundButton.snp.makeConstraints({ m in
            m.left.right.top.bottom.equalTo(view)
        })
        modalView.snp.makeConstraints({ m in
            m.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
            m.width.equalTo(320)
            m.height.equalTo(425)
        })
        photoContainer.snp.makeConstraints({ m in
            m.width.equalTo(280)
            m.height.equalTo(340)
            m.centerX.equalTo(modalView)
            m.top.equalTo(modalView.snp.top).inset(65)
        })
        titleLabel.snp.makeConstraints({ m in
            m.centerX.equalTo(modalView)
            m.top.equalTo(modalView.snp.top).inset(25)
        })
        indicator.snp.makeConstraints({ m in
            m.centerX.centerY.equalTo(photoContainer)
        })
    }
    
    private func fetchPhotoData() {
        let url = "\(api_url)/photo-zones"
        AF.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(PhotoZoneResult.self, from: responseData)
                    let dataCount = result.data[0].photoList.count
                    if result.status == 200 {
                        for photo in result.data[0].photoList {
                            guard let url = URL(string: photo.photoImageUrl) else { return }

                            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                                guard let data = data, error == nil else { return }
                                DispatchQueue.main.async() {
                                    if let image = UIImage(data: data) {
                                        self.photoZoneListWithImage.append(PhotoZoneWithImage(photoId: photo.photoId, photoName: photo.photoName, photoDescription: photo.photoDescription, image: image))
                                    }
                                    
                                    if self.photoZoneListWithImage.count == dataCount {
                                        self.setUpScrollView(self.photoZoneListWithImage)
                                        self.indicator.stopAnimating()
                                    }
                                }
                            }
                            task.resume()
                        }
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
    
    private func setUpScrollView(_ imageList: [PhotoZoneWithImage]) {
        photoContainer.addSubview(imageScrollView)
        photoContainer.addSubview(imagePageControl)
        imageScrollView.snp.makeConstraints({ m in
            m.left.right.top.bottom.equalTo(photoContainer)
        })
        imagePageControl.snp.makeConstraints({ m in
            m.centerX.equalTo(photoContainer)
            m.bottom.equalTo(photoContainer.snp.bottom).inset(10)
        })
        
        // Setup imageScrollView
        for i in 0..<imageList.count {
            let imageView = UIImageView(image: imageList[i].image)
            let titleLabel: UILabel = {
                let label = UILabel()
                label.text = imageList[i].photoName
                label.textColor = .primaryPurple
                label.font = UIFont(name: "Pretendard-Bold", size: 16)
                return label
            }()
            
            let descLabel: UILabel = {
                let label = UILabel()
                label.text = imageList[i].photoDescription
                label.textColor = .black
                label.font = UIFont(name: "Pretendard-Regular", size: 15)
                return label
            }()
            
            let xPos: CGFloat = imageScrollViewWidth * CGFloat(i)
            
            imageView.frame = CGRect(x: xPos + 40,
                                     y: 80,
                                     width: 200,
                                     height: 200)
            imageView.backgroundColor = .clear
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
            titleLabel.frame = CGRect(x: xPos + 16, y: 24, width: 200, height: 25)
            descLabel.frame = CGRect(x: xPos + 16, y: 49, width: 200, height: 25)
            
            imageScrollView.addSubview(imageView)
            imageScrollView.addSubview(titleLabel)
            imageScrollView.addSubview(descLabel)
            
            imageScrollView.contentSize.width = imageScrollViewWidth * CGFloat(i + 1)
        }
        
        // Setup imagePageControl
        imagePageControl.numberOfPages = imageList.count
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        imagePageControl.currentPage = Int(round(imageScrollView.contentOffset.x / imageScrollViewWidth))
    }
}
