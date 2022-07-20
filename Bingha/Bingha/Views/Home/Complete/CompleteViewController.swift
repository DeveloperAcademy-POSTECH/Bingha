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
    //빙하 레벨업 알림 뷰
    @IBOutlet weak var icebergLevelAlertView: UIView!
    
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
        
        //View 커스텀
        viewCornerAndShadowCustom(viewName: icebergLevelAlertView) //빙하 레벨업
        viewCornerAndShadowCustom(viewName: dataView) //상세 데이터
        exitButtonCustom()
        
        //Label 폰트 커스텀
        
        //데이터 연결
        
        
        
    }
    
    //View 커스텀 함수
    func viewCornerAndShadowCustom(viewName: UIView) {
        //모서리 radius 20
        viewName.layer.cornerRadius = 20
        //그림자 구현
        viewName.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewName.layer.shadowOpacity = 0.25
        viewName.layer.cornerRadius = 15
    }
    
    //Label 폰트 커스텀 함수
    func setRoundedFont(labelName: UILabel) {
        UILabel.font.UIFont(descriptor: rounded, size: 0)
        
    }
    
    //exitModalButton커스텀
    func exitButtonCustom() {
        //버튼 사이즈 조절 필요 44*44pt
    }
}
