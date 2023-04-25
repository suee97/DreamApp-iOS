import UIKit
import SnapKit
import PDFKit

class PrivacyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureUI()
    }

    private func configureUI() {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        view.addSubview(pdfView)
        pdfView.snp.makeConstraints({ m in
            m.left.right.top.bottom.equalTo(view)
        })
        guard let path = Bundle.main.url(forResource: "sc_privacy", withExtension: "pdf") else {
            return
        }

        if let document = PDFDocument(url: path) {
            pdfView.document = document
        }
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        let na = customNavBarAppearance()
        self.navigationController?.navigationBar.scrollEdgeAppearance = na
        self.navigationController?.navigationBar.compactAppearance = na
        self.navigationController?.navigationBar.standardAppearance = na
        if #available(iOS 15.0, *) {
            navigationController?.navigationBar.compactScrollEdgeAppearance = na
        }
        
        self.navigationItem.title = "개인정보처리방침"
        
        self.navigationController?.navigationBar.tintColor = .white
    }
}
