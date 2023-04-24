import UIKit

class ContentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .backgroundPurple
        tv.separatorStyle = .none
        tv.register(ContentsTableViewCell.classForCoder(), forCellReuseIdentifier: "contents_cell")
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    var contentsList: [Contents] = [
        Contents(id: 1, image: UIImage(named: "booth1")!, title: "운영부스 1", congestion: 0, time: "10:00 ~ 17:00", desc: "어의대동제 행사 진행 관련 개인정보 수집 동의 구글폼 작성\n자치회비 납부 여부를 확인하고 팔찌 배부를 하는 부스"),
        Contents(id: 2, image: UIImage(named: "booth2")!, title: "운영부스 2", congestion: 0, time: "10:00 ~ 16:30", desc: "어의대동제 행사 진행 관련 개인정보 수집 동의 구글폼 작성\n자치회비 납부 여부를 확인하고 팔찌 배부를 하는 부스"),
        Contents(id: 3, image: UIImage(named: "booth3")!, title: "운영부스 3", congestion: 0, time: "17:10 ~ 변경", desc: "어의대동제 행사 진행 관련 개인정보 수집 동의 구글폼 작성\n자치회비 납부 여부를 확인하고 팔찌 배부를 하는 부스"),
        Contents(id: 4, image: UIImage(named: "booth4")!, title: "붕어방의 산신령", congestion: 0, time: "10:00 ~ 18:00", desc: "돗자리(쇠도끼)를 빌려 즐기는 피크닉 부스(미니게임 : 퍼즐 타임어택)"),
        Contents(id: 5, image: UIImage(named: "booth5")!, title: "임금님 귀는 당나귀 귀", congestion: 0, time: "10:00 ~ 18:00", desc: "총학생회와의 소통을 위한 부스\n자신이 마음에 담아두고 있던 말이나 하고 싶었던 이야기들을 적고 머리핀 받아가세요!"),
        Contents(id: 6, image: UIImage(named: "booth6")!, title: "릴레이 소설", congestion: 0, time: "10:00 ~ 18:00", desc: "3일 동안 주어지는 주제로 함께 만들어가는 릴레이 소설 제작을 위한 부스\n참여 시 추첨을 통해 상품권을 드립니다!"),
        Contents(id: 7, image: UIImage(named: "booth7")!, title: "꿈에서 핀 오작교", congestion: 0, time: "10:00 ~ 18:00", desc: "우리학교의 상징 붕어방에서 만남을 이루어 보아요!\n이번 오작교에서의 만남을 통해 이상형과 함께하는 축제가 되어보는 건 어떨까요\n본인 소개를 작성하신 뒤 마음에 드는 이상형이 있는 별사탕을 가져가세요!"),
        Contents(id: 8, image: UIImage(named: "booth8")!, title: "동심 오락실", congestion: 0, time: "10:00 ~ 18:00", desc: "오락 게임존에서 어릴적 추억을 회상하세요!\n(투호, 공기놀이, 제기차기, 장기, 오목, 구슬미로, 컵스택 등)"),
        Contents(id: 9, image: UIImage(named: "booth9")!, title: "마당사업", congestion: 0, time: "10:00 ~ 18:00", desc: "향학로 부스에서 여러 가지 콘텐츠 기획 & 운영\n- 후크 선장의 키링 공방\n- 보물 찾기\n- 후크선장에게서 탈출하라!(미니 4종 게임)\n- 후크선장의 물고기 사냥터"),
    ]
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureDelegate()
    }
    
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ m in
            m.left.right.bottom.equalTo(view)
            m.top.equalTo(view).inset(24)
        })
    }
    
    private func configureDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contents_cell") as! ContentsTableViewCell
        cell.content = contentsList[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getRatHeight(248)
    }
}
