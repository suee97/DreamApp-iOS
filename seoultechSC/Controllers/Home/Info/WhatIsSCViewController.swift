import UIKit

class WhatIsSCViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    let contentView = UIView(frame: CGRect(x: 0, y: 0, width: getRatWidth(320), height: getRatHeight(900)))
    
    private let label1: DescLabel = {
        let label = DescLabel(isTitle: false)
        label.text = "총학생회는 학생회칙이 정하는 바에 따라 입후보한 자에 대해 재학 중인 전체 학생들의 직접선거에 의해 선출되며, 성실, 협동, 창의를 교훈으로 민주적인 학생 자치활동을 통하여 민주시민으로서 자질을 함양하고 대학 문화를 창출하여 자율적 발전을 도모하며 사회와 민주국가 발전에 기여할 수 있는 능력 배양을 목적으로 한다.\n\n"
        return label
    }()
    
    private let label2: DescLabel = {
        let label = DescLabel(isTitle: true)
        label.text = "총학생회 조직도\n"
        return label
    }()
    
    private let label3: DescLabel = {
        let label = DescLabel(isTitle: true)
        label.text = "Dream 총학생회\n"
        return label
    }()
    
    private let label4: DescLabel = {
        let label = DescLabel(isTitle: false)
        label.text = "자랑스럽고 존경하는 우리 서울과학기술대학교 학우 여러분 안녕하십니까!\n\n2023년 1월 1일부로 임기를 시작하게 된 제39대 Dream 총학생회 인사드립니다.\n\n먼저, 선거 기간 동안 학우 여러분들의 많은 관심과 응원 덕에 총학생회가 선출되어 기쁨과 감사의 말씀 전합니다.\n\n지난 3년 유례없는 전염병인 코로나로 인한 어려운 시기를 이겨내고 일상 회복을 마주하고 있는 현시점에 여러분께 인사드릴 수 있어 영광입니다.\n\n이제는 코로나라는 틀에서 벗어나 그동안 학우분들께서 이루지 못했던 꿈들을 함께 이뤄갈 시간입니다.\n\n저희 Dream 총학생회는 그 과정의 뒷받침 역할을 통해 저희 슬로건인 ‘우리가 함께 이뤄가는 꿈’을 실현하겠습니다.\n\n학우 여러분의 소중한 꿈을 이뤄가실 수 있게 다음을 약속하겠습니다.\n\n첫째, 학우 여러분들과 가장 먼저 소통하겠습니다.\n\n회의록 공개, 미팅 발언 공유, 상시 건의함 및 피드백, 소통 부스 운영, 주요 보직자 및 정무직 공무원 간담회를 이행하겠습니다.\n\n둘째, 학우 여러분의 인권과 권리를 보장하겠습니다.\n\n생활하시면서 느낀 불편함, 행정 시스템 마비, 불평등 및 차별, 학습권 침해 등 학생으로서 누려야 할 모든 권리를 보장할 수 있게 노력하고 발전시키겠습니다.\n\n셋째, 더욱 활기찬 캠퍼스를 만들겠습니다.\n\n일상 회복이 된 현재, 대학 생활의 꽃인 행사를 모두 진행해 학우분들의 재밌는 대학 생활을 보장하겠습니다.\n\n학생 사회 발전을 위해 힘 써주신 역대 총학생회 선배님들께 감사드리며, 팬데믹이라는 어려운 상황 속에서 학우들의 인권과 권리를 보장하는 데 최선을 다하신 선배님들께도 존경을 표합니다.\n\n이제 선배님들의 노고를 이어받아 학우분들을 위해 곁에 항상 함께하는 총학생회가 되겠습니다.\n\n우리가 함께 이뤄가는 꿈, 제39대 Dream 총학생회 올림"
        return label
    }()
    
    private let organizationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "organization")
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        contentView.addSubview(label2)
        contentView.addSubview(label3)
        contentView.addSubview(label4)
        contentView.addSubview(organizationImageView)
        
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        label3.translatesAutoresizingMaskIntoConstraints = false
        label4.translatesAutoresizingMaskIntoConstraints = false
        organizationImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: contentView.topAnchor),
            label1.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 0),
            label2.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            organizationImageView.widthAnchor.constraint(equalToConstant: getRatWidth(320)),
            organizationImageView.heightAnchor.constraint(equalToConstant: getRatWidth(200)),
            organizationImageView.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 0),
            label3.topAnchor.constraint(equalTo: organizationImageView.bottomAnchor, constant: 16),
            label3.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            label4.topAnchor.constraint(equalTo: label3.bottomAnchor, constant: 0),
            label4.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1)
        ])
    }
}
