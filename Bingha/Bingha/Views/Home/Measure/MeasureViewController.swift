//
//  MeasureViewController.swift
//  Bingha
//
//  Created by 이재웅 on 2022/07/15.
//

import UIKit
import Lottie

class MeasureViewController: UIViewController {
    
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var WalkingDistanceView: UIView!
    @IBOutlet weak var ReducedCarbonView: UIView!
    @IBOutlet weak var TotalReducedCarbonLabel: UILabel!
    @IBOutlet weak var WalkingDistanceLabel: UILabel!
    @IBOutlet weak var ReducedCarbonLabel: UILabel!
    @IBOutlet weak var WalkerImageView: UIImageView!
    @IBOutlet weak var ImageView: UIView!

    let walkerAnimationView = AnimationView()
    let backgroundAnimationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ImageView.addSubview(self.WalkerImageView)
        ViewCustom()
    }
    
    // 홈 디폴트 뷰 세팅
       private func defaultView(){
           StartButton.setTitle("시작",for:.normal)
           StartButton.backgroundColor = UIColor(named: "Primary")
           WalkerImageView.image = UIImage(named: "StandingMan")
           walkerAnimationView.isHidden = true
           self.view.backgroundColor = .white
       }
    
    // lottie 파일 walker 애니메이션
    private func WalkerAnimation() {
        // walker 이미지, 애니메이션 보이기 설정
        self.ImageView.addSubview(self.walkerAnimationView)
        WalkerImageView.image = nil;
        walkerAnimationView.isHidden = false
        
        walkerAnimationView.animation = Animation.named("walker")
        walkerAnimationView.frame = CGRect(x: 0, y: 4, width: 58, height: 58)
        walkerAnimationView.contentMode = .scaleAspectFit
        walkerAnimationView.loopMode = .loop
        walkerAnimationView.play()
    }
    
    // background 애니메이션 (임시)
    private func backgroundAnimation() {
        self.view.backgroundColor = UIColor(displayP3Red: 0.87, green: 0.93, blue: 0.93, alpha: 1)
    }

    
    // 이동거리뷰, 탄소배출 저감량뷰, 시작버튼 커스텀
    private func ViewCustom() {
        
    //WalkingDistanceView Custom
        WalkingDistanceView.layer.shadowOpacity = 0.2
        WalkingDistanceView.layer.shadowOffset = CGSize(width: 0, height: 2)
        WalkingDistanceView.layer.shadowColor = UIColor.darkGray.cgColor
        WalkingDistanceView.layer.cornerRadius = 20
        
    //ReducedCarbonView Custom
        ReducedCarbonView.layer.shadowOpacity = 0.2
        ReducedCarbonView.layer.shadowOffset = CGSize(width: 0, height: 2)
        ReducedCarbonView.layer.shadowColor = UIColor.darkGray.cgColor
        ReducedCarbonView.layer.cornerRadius = 20
        
    //StartButton Custom
        StartButton.layer.cornerRadius = StartButton.frame.width / 2
        StartButton.layer.masksToBounds = true
        StartButton.layer.shadowOpacity = 0.2
        StartButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        StartButton.layer.shadowColor = UIColor.darkGray.cgColor
        StartButton.titleLabel?.font = UIFont.systemFont(ofSize: 32.0, weight: .bold)
    }
}
