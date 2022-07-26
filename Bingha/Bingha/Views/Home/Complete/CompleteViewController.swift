//
//  CompleteViewController.swift
//  Bingha
//
//  Created by 이재웅 on 2022/07/15.
//

import UIKit

class CompleteViewController: UIViewController {
    
    @IBAction func tapExitModalButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var exitModalButton: UIButton!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var icebergLevelAlertView: UIView!
    
    @IBOutlet weak var changeToOxyLabel: UILabel!
    @IBOutlet weak var reducedCarbonLabel: UILabel!
    @IBOutlet weak var todayReducedCarbonLabel: UILabel!
    @IBOutlet weak var moveDistanceLabel: UILabel!
    @IBOutlet weak var timeDurationLabel: UILabel!
    
    var reducedCarbon: String = ""
    var todayReducedCarbon: String = ""
    var moveDistance: String = ""
    var timeDuration: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //View 커스텀
        viewCornerAndShadowCustom(viewName: icebergLevelAlertView) //빙하 레벨업
        viewCornerAndShadowCustom(viewName: dataView) //상세 데이터
        exitButtonCustom()
        
        //Label 폰트 커스텀
        
        //데이터 연결
        self.reducedCarbonLabel.text = reducedCarbon
        self.todayReducedCarbonLabel.text = todayReducedCarbon
        self.moveDistanceLabel.text = moveDistance
        self.timeDurationLabel.text = timeDuration
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
    
    // TODO: Label 폰트 커스텀 함수
    func setRoundedFont(labelName: UILabel) {
//        UILabel.font.UIFont(descriptor: rounded, size: 0)
        
    }
    
    // TODO: exitModalButton커스텀
    func exitButtonCustom() {
        //버튼 사이즈 조절 필요 44*44pt
    }
}
