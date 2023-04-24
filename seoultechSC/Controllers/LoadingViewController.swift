import UIKit
import Lottie
import SnapKit

class LoadingViewController: UIViewController {

    let animationView: LottieAnimationView = .init(name: "lottie_splash")

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .white

        view.addSubview(animationView)
        
        animationView.snp.makeConstraints({ m in
            m.centerX.equalTo(view)
            m.width.equalTo(getRatWidth(140))
            m.height.equalTo(getRatHeight(125))
            m.top.equalTo(view).inset(139)
        })
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
    }
}
