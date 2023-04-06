import UIKit

class FAQViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let contentView = UIView(frame: CGRect(x: 0, y: 0, width: getRatWidth(320), height: getRatHeight(900)))
    
    private let label1: DescLabel = {
        let label = DescLabel(isTitle: false)
        label.text = "Q : 자치회비는 왜 내야 하나요?\nA : 우선 자치회비는 총학생회, 학생복지위원회, 동아리연합회, 교지편집위원회가 운영되는 데에 쓰이며 전체학생대표자대회를 통해 각각 자치기구 예산으로 엄정하게 인준되며 결산내역은 철저한 보고를 원칙으로 한다는 점을 알려드리며, 자치회비란 자치기구의 존속 및 사업 추진을 위해 자발적으로 납부하는 비용입니다. 이는 우리 서울과학기술대학교 학우 여러분의 권리증진과 학교생활 만족도를 증진하기 위해 사용되고 있습니다.\n\nQ : 등록금 납부 기간에 자치회비를 납부하지 않았다면, 추가로 납부할 수 있나요?\nA : 정규 등록 기간 이후, 자치회비 추가 납부 기간이 설정되어 납부 방법에 대한 공지가 이루어집니다. 이 기간에 맞춰 자치회비 납부를 진행하면 됩니다.\n\nQ : 총학생회에 건의/상시사업을 위해 총학생회실에 방문하고 싶은데 총학생회실은 어디에 있나요?\nA : 총학생회실은 제1학생회관 (37번 건물) 226호에 있습니다.\n\nQ : 자치회비는 어떻게 내나요?\nA : 자치회비는 매 학기 등록금 납부 기간에 가상계좌를 통해 납부하실 수 있습니다. 고지서에 기재된 등록금에 11,000원을 추가한 금액을 입금하면 자동으로 자치회비 납부 처리가 됩니다. 세부사항은 등록금 고지서를 통해 확인하실 수 있습니다. 또한 등록금 납부기간에 기재된 학생처나 총학생회 번호(02-970-7011)로 연락주시면 자세한 설명을 들으실 수 있습니다.\n\nQ : 문화기획국에서는 어떤 일을 하나요?\nA : 문화기획국은 어의대동제, 어의체전 등 학우분들이 즐길 수 있는 학교에서의 전반적인 문화 행사 및 텐츠를 기획합니다. 또한, 원활한 이행을 위해 행사에 대한 지속적인 관리 감독을 진행합니다.\n\nQ : 정책기획국에서는 어떤 일을 하나요?.\nA : 정책기획국은  각종 정책, 학술 기획  등 학우들의 편의를 위한 업무를 담당합니다. 학교 행정과 제도에 학우들의 목소리를 반영하고 개선하는 데 중점을 두고 활동합니다.\n\nQ : 사무국은 어떤 일을 하나요?\nA : 사무국은 대외적으로 학생자치기구 및 특별기구에 자치회비를 배분하는 일을 맡고 있으며, 대내적으로는 학생회실 운영 및 상시사업 진행에 필요한 비품을 구입하고 그에 따른 재정업무를 처리합니다. 투명하고 공정한 업무 수행을 위해 자치회비 예·결산안을 '전체학생대표자대회'에서 인준받으며 관련 자료는 매월 활동 보고 및 재정감사 결과를 통해 확인할 수 있습니다.\n\nQ : 홍보국에선 어떤 일을 하나요?\nA : 홍보국은 총학생회에서 진행하는 다양한 행사 및 각종 안내 사항을 시각 자료를 통해 효과적으로 전달하는 역할을 맡고 있습니다. 총학생회 공약 이행, 활동 보고 카드 뉴스, 이벤트 사업 등 카드 뉴스부터 포스터까지 다양한 업무를 진행합니다.\n\nQ : 정보통신국은 어떤 일을 하나요?\nA : 정보통신국은 총학생회 주관 행사에 대한 안내는 물론, 학우 여러분의 학교생활과 직결되는 여러 사항에 대한 논의 결과에 대하여 안내하고 있습니다. 학우들과의 소통창구를 원활히 운영하기 위해 힘쓰고 있습니다.\n\nQ : 대외협력국은 어떤 일을 하나요?\nA : 대외협력국은 교외 즉, 학교 밖의 다른 단체와 협력을 통해서 대학 문제에 대한 해결을 논의하는 데 중점을 가지고 활동합니다. 다양한 연합체와 회의를 통하여 사안에 대해 논의하고 진행합니다. 또한, 다양한 업체와의 활발한 제휴 협약을 통해 학우들의 복지를 위해 힘쓰고 있습니다.\n\nQ : 미디어국은 어떤 일을 하나요?\nA : 미디어국은 학생사회의 장기적인 발전을 위해, 총학생회의 사업 전반에 대한 영상 콘텐츠 제작을 담당하고 있습니다. 효과적인 아카이빙을 위한 기틀을 다지고, 총학생회 유튜브 채널을 운영하고 있습니다.\n\nQ : IT국은 어떤 일을 하나요?\nA  : IT국은 총학생회 애플리케이션을 기획하고 제작하고 있습니다. 성능 향상과 결함 수정 등 지속적인 유지보수를 통해 원활한 애플리케이션 사용을 돕고 있습니다. 기능 개선 제안, 오류 신고는 총학생회 애플리케이션을 통해 가능합니다."
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .white
        
        scrollView.contentSize = contentView.frame.size
        scrollView.frame = view.bounds
        contentView.backgroundColor = .clear
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(label1)
        
        label1.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: contentView.topAnchor),
            label1.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
        ])
    }
}
