import UIKit

class SCFeatureViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let contentView = UIView(frame: CGRect(x: 0, y: 0, width: getRatWidth(320), height: 1200))
    
    private let label1: DescLabel = {
        let label = DescLabel(isTitle: true)
        label.text = "학생자치기구\n"
        return label
    }()
    
    private let label2: DescLabel = {
        let label = DescLabel(isTitle: false)
        label.text = "중앙집행국\n총학생회장, 부총학생회장, 집행위원장, 각 집행국(부·차)장과 국원으로 구성되며 본회의 최고집행기구이다.\n\n단과대학 학생회\n단과대학 학생회는 각 단과대학의 최고 자치 기구로, 단과대학 학생회는 각 단과대학의 모든 회원으로 구성하며, 단과대학의 최고집행기구이다.\n\n학과 학생회\n학과 학생회는 본회의 기초자치 기구이자 각 학과의 최고 자치기구로, 학과 학생회는 각 학과의 모든 회원으로 구성하며, 학과의 최고집행기구이다.\n\n동아리연합회\n동아리연합회에서 등록된 정규동아리들의 연합체인 동아리연합회는 전 동아리의 민주적 자치를 위한 대표기구이다. 동아리연합회의 으뜸빛, 버금빛을 동아리연합회 내에서 선거로 선출하며 동아리 으뜸빛은 전 동아리인들을 대표하여 동아리의 자치적 활동에 필요한 제반 업무를 담당한다.\n\n학생복지위원회\n학생복지위원회 위원장과 부위원장은 반대표(각 학과, 각반) 이상 직선 대표자들에 의해 선출된다. 본회 회원들의 복지향상을 위한 자율적 활동에 필요한 제반 사항은 학생복지위원회의 자치회칙에 따른다.\n\n"
        return label
    }()
    
    private let label3: DescLabel = {
        let label = DescLabel(isTitle: true)
        label.text = "상설기구\n"
        return label
    }()
    
    private let label4: DescLabel = {
        let label = DescLabel(isTitle: false)
        label.text = "교지편집위원회 러비\n총학생회 상설 특별기구로서 교지 발간 등을 위한 제반 업무를 담당하며 독자성과 전문성으로 편집권 및 예산집행의 자율권을 가진다.\n\n"
        return label
    }()
    
    private let label5: DescLabel = {
        let label = DescLabel(isTitle: true)
        label.text = "정기특별기구\n"
        return label
    }()
    
    private let label6: DescLabel = {
        let label = DescLabel(isTitle: false)
        label.text = "재정감사위원회\n학생들이 납부한 여러 종류의 자치회비를 사용하는 총학생회 산하의 과와 단과대학을 포함한 모든 기구의 예.결산안을 대조하여 본회의 목적에 맞지 않게 사용되는 일을 감시하는 단체이다.\n\n"
        return label
    }()
    
    private let label7: DescLabel = {
        let label = DescLabel(isTitle: true)
        label.text = "특별기구\n"
        return label
    }()
    
    private let label8: DescLabel = {
        let label = DescLabel(isTitle: false)
        label.text = "학생인권위원회\n교내에서 일어는 다양한 인권 관련 사건에 대해 학생들의 의견을 대표하고, 학생들의 인권 의식 향상을 위해 노력하는 단체이다. 학생인권위원회의 활동에 필요한 제반 사항은 학생인권위원회의 자치회칙에 따른다.\n\n총졸업준비위원회\n총출업준비위원회는 졸업과 사회진출에 관한 업무를 관할하는 상설특별기구이며 회원이 될 자격은 본회의 각과 졸업준비위원장과 졸업이 가능한 본회의 회원으로 구성한다."
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
        contentView.addSubview(label2)
        contentView.addSubview(label3)
        contentView.addSubview(label4)
        contentView.addSubview(label5)
        contentView.addSubview(label6)
        contentView.addSubview(label7)
        contentView.addSubview(label8)
        
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        label3.translatesAutoresizingMaskIntoConstraints = false
        label4.translatesAutoresizingMaskIntoConstraints = false
        label5.translatesAutoresizingMaskIntoConstraints = false
        label6.translatesAutoresizingMaskIntoConstraints = false
        label7.translatesAutoresizingMaskIntoConstraints = false
        label8.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label1.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            label2.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            label3.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            label4.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            label5.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            label6.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            label7.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            label8.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            label1.topAnchor.constraint(equalTo: contentView.topAnchor),
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 0),
            label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 0),
            label4.topAnchor.constraint(equalTo: label3.bottomAnchor, constant: 0),
            label5.topAnchor.constraint(equalTo: label4.bottomAnchor, constant: 0),
            label6.topAnchor.constraint(equalTo: label5.bottomAnchor, constant: 0),
            label7.topAnchor.constraint(equalTo: label6.bottomAnchor, constant: 0),
            label8.topAnchor.constraint(equalTo: label7.bottomAnchor, constant: 0)
        ])
    }
}
