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
    @IBOutlet weak var exitButton: UIImageView!
    //상세 데이터 백그라운드 뷰
    @IBOutlet weak var dataBackground: UIView!
    
    //~~동안 산소로 바꾸는 양
    @IBOutlet weak var oxygenChangeAmount: UILabel!
    //탄소 배출 저감량
    @IBOutlet weak var reducedCarbon: UILabel!
    //오늘 총 저감량
    @IBOutlet weak var todayReducedCarbon: UILabel!
    //이동거리
    @IBOutlet weak var moveDistance: UILabel!
    //소요시간
    @IBOutlet weak var timeDuration: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataBackground.layer.cornerRadius = 20
        
    }
}
