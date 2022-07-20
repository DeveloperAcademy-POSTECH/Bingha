//
//  CompleteViewController.swift
//  Bingha
//
//  Created by 이재웅 on 2022/07/15.
//

import UIKit

class CompleteViewController: UIViewController {
    
    //스토리보드 연결
    
    //모달 닫기 버튼
    @IBOutlet weak var exitModalButton: UIButton!
    //상세 데이터 백그라운드 뷰
    @IBOutlet weak var dataView: UIView!
    
    
    //~~동안 산소로 바꾸는 양
    @IBOutlet weak var changeToOxyLabel: UILabel!
    //탄소 배출 저감량
    @IBOutlet weak var reducedCarbonLabel: UILabel!
    //오늘 총 저감량
    @IBOutlet weak var todayReducedCarbonLabel: UILabel!
    //이동거리
    @IBOutlet weak var moveDistanceLabel: UILabel!
    //소요시간
    @IBOutlet weak var timeDurationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rectangleCustom()
        exitButtonCustom()
    }
    
    //dataView 커스텀
    func rectangleCustom() {
        //모서리 radius 20
        dataView.layer.cornerRadius = 20
        //그림자 구현
        dataView.layer.shadowOffset = CGSize(width: 0, height: 2)
        dataView.layer.shadowOpacity = 0.25
        dataView.layer.cornerRadius = 15
    }
    
    //exitModalButton커스텀
    func exitButtonCustom() {
        //버튼 사이즈 조절 필요 44*44pt
    }
}
