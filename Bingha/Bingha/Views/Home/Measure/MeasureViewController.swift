//
//  MeasureViewController.swift
//  Bingha
//
//  Created by 이재웅 on 2022/07/15.
//

import UIKit

class MeasureViewController: UIViewController {
    
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var WalkingDistanceView: UIView!
    @IBOutlet weak var ReducedCarbonView: UIView!
    @IBOutlet weak var TotalReducedCarbonLabel: UILabel!
    @IBOutlet weak var WalkingDistanceLabel: UILabel!
    @IBOutlet weak var ReducedCarbonLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewCustom()
        
    }
    
    
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
