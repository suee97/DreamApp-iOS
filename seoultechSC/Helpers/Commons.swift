import Foundation
import UIKit
import Toast_Swift
import SnapKit

// 배포 서버
public let api_url: String = Bundle.main.api_url

// 개발 서버
//public let api_url: String = Bundle.main.dev_api_url

// Google Maps API Key
public let maps_api_key: String = Bundle.main.maps_api_key

// SwiftUI Preview
//import SwiftUI
//#if DEBUG
//struct ViewControllerRepresentable: UIViewControllerRepresentable {
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//
//    }
//    @available(iOS 13.0, *)
//    func makeUIViewController(context: Context) -> some UIViewController {
//        EnterInfoViewController()
//    }
//}
//
//struct ViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewControllerRepresentable()
//    }
//}
//
//#endif

public let collegeList: [String] = ["공과대학", "정보통신대학", "에너지바이오대학", "조형대학", "인문사회대학", "기술경영융합대학", "미래융합대학", "창의융합대학", "교양대학"]

public let majorList: [[String]] = [
    ["기계시스템디자인공학과", "기계자동차공학과", "안전공학과", "신소재공학과", "건설시스템공학과", "건축학부(건축공학전공)", "건축학부(건축학전공)", "[계약학과]건축기계설비공학과"],
    ["전기정보공학과", "전자IT미디어공학과", "컴퓨터공학과", "스마트ICT융합공학과"],
    ["화공생명공학과", "환경공학과", "식품공학과", "정밀화학과", "스포츠과학과", "안경광학과"],
    ["디자인학과(산업디자인전공)", "디자인학과(시각디자인전공)", "도예학과", "금속공예디자인학과", "조형예술학과"],
    ["행정학과", "영어영문학과", "문예창작학과"],
    ["산업정보시스템전공", "ITM전공", "MSDE학과", "경영학전공", "글로벌테크노경영전공"],
    ["융합공학부(융합기계공학전공)", "융합공학부(건설환경융합전공)", "융합사회학부(헬스피트니스전공)", "융합사회학부(문화예술전공)", "융합사회학부(영어전공)", "융합사회학부(벤처경영전공)"],
    ["인공지능응용학과", "지능형반도체공학과", "미래에너지융합학과"],
    ["인문사회교양학부", "자연과학부", "융합교양학부"]
]



// Login State Management
public func setLoginState(_ state: Bool) {
    UserDefaults.standard.set(state, forKey: "isLogin")
    UserDefaults.standard.synchronize()
}

public func getLoginState() -> Bool {
    return UserDefaults.standard.bool(forKey: "isLogin")
}

public var needLoginMessage: String = "로그인이 필요한 기능입니다. '홈 -> 설정'에서 로그인해주세요."

// Screen
public let screenWidth = UIScreen.main.bounds.width
public let screenHeight = UIScreen.main.bounds.height

public func getRatWidth(_ width: CGFloat) -> CGFloat {
    return screenWidth * (width/360)
}

public func getRatHeight(_ height: CGFloat) -> CGFloat {
    return screenHeight * (height/640)
}

var signInUser = User(memberId: -1, studentNo: "00000000", name: "nil", department: "nil", phoneNo: "nil", memberShip: false, createdAt: "nil", updatedAt: "nil", memberStatus: "nil")

var signUpUser = SignUpUser()

public func showToast(view: UIView, message: String) {
    var style = ToastStyle()
    style.backgroundColor = .black
    style.messageColor = .white
    style.cornerRadius = 10
    style.messageFont = UIFont(name: "Pretendard-Regular", size: 12)!
    view.makeToast(message, position: .bottom, style: style)
}

class Commons {
    static let shared = Commons()
    private init(){}

    let sessionExpiredMessage: String = "로그인 세션이 만료되었습니다. 다시 로그인해주세요."
}

class ZoomImageViewController: UIViewController {
    
    var image: UIImage? {
        didSet {
            let iv = UIImageView(image: image)
            iv.contentMode = .scaleAspectFit
            view.addSubview(iv)
            iv.snp.makeConstraints({ m in
                m.left.right.top.bottom.equalTo(view)
            })
        }
    }
    
    private lazy var backgroundButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .modalBackground
        button.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundButton)
        backgroundButton.snp.makeConstraints({ m in
            m.left.right.top.bottom.equalTo(view)
        })
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true)
    }
}

class CustomTapGesture: UITapGestureRecognizer {
  var image: UIImage?
}
