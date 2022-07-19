//
//  IcebergViewController.swift
//  Bingha
//
//  Created by 이재웅 on 2022/07/15.
//

import UIKit

class IcebergViewController: UIViewController {
    @IBOutlet var roundedRectangle: UIView!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var reducedCarbonLabel: UILabel!
    @IBOutlet var informationLabel: UILabel!
    
    var circularProgressBarView: CircularProgressBarView!
    var circularViewDuration: TimeInterval = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRoundedRectangle()
        setUpCircularProgressBarView()
        setLevelLabel()
        setReducedCarbonLabel()
        setInformationLabel()
    }
    
    func setRoundedRectangle() {
        roundedRectangle.layer.cornerRadius = 20
    }
    
    // TODO: - 경험치에 따라 levelLabel 동적으로 변하게
    func setLevelLabel() {
        levelLabel.text = "Lv.1"
        levelLabel.font = .rounded(ofSize: 20, weight: .bold)
    }
    
    func setReducedCarbonLabel() {
        reducedCarbonLabel.font = .rounded(ofSize: 48, weight: .bold)
    }
    
    func setInformationLabel() {
        informationLabel.font = .rounded(ofSize: 16, weight: .bold)
    }
    
    func setUpCircularProgressBarView() {
        circularProgressBarView = CircularProgressBarView(frame: .zero)
        // TODO: - 경험치에 맞게 endPoint 파라미터 넣어주기
        circularProgressBarView.createCircularPath(endPoint: CGFloat(2 * Double.pi / 2))
        // TODO: - center로 맞췄는데도 불구하고 중심이 안맞음 추후에 수정 필요
        circularProgressBarView.center = levelLabel.center
        circularProgressBarView.progressAnimation(duration: circularViewDuration)
        view.addSubview(circularProgressBarView)
   }
}
