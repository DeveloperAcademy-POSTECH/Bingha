//
//  IcebergViewController.swift
//  Bingha
//
//  Created by 이재웅 on 2022/07/15.
//

import UIKit
import SwiftUI

class IcebergViewController: UIViewController {
    @IBOutlet var roundedRectangle: UIView!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var reducedCarbonLabel: UILabel!
    @IBOutlet var informationLabel: UILabel!
    
    let firebaseController = FirebaseController()
    let icebergLevelCalculator: IcebergLevelCalculator = IcebergLevelCalculator.shared
    let reducedCarbonCalculator: ReducedCarbonCalculator = ReducedCarbonCalculator.shared
    let circularViewDuration: TimeInterval = 2
    let icebergBackgroundAnimationView = UIHostingController(rootView: IcebergBackgroundAnimation())

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAttribute()
        fetchTotalDistance()
        playBackgroundAnimation()
    }
    
    private func setAttribute() {
        setRoundedRectangle()
        setInformationLabel()
    }
    
    private func fetchTotalDistance() {
        setLevelLabel(level: IcebergLevelCalculator.shared.requestIcebergLevel(distance: FirebaseController.carbonModel.totalDistance))
        setReducedCarbonLabel(distance: FirebaseController.carbonModel.totalDistance)
        setUpCircularProgressBarView(distance: FirebaseController.carbonModel.totalDistance)
    }
    
    private func playBackgroundAnimation() {
        view.insertSubview(icebergBackgroundAnimationView.view, at: 0)
        icebergBackgroundAnimationView.didMove(toParent: self)
        icebergBackgroundAnimationView.view.translatesAutoresizingMaskIntoConstraints = false
        icebergBackgroundAnimationView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        icebergBackgroundAnimationView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        icebergBackgroundAnimationView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        icebergBackgroundAnimationView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func setRoundedRectangle() {
        roundedRectangle.layer.cornerRadius = 20
    }
    
    // TODO: - 경험치에 따라 levelLabel 동적으로 변하게
    private func setLevelLabel(level: String) {
        levelLabel.text = "Lv. \(level)"
        levelLabel.font = .rounded(ofSize: 20, weight: .bold)
        levelLabel.textColor = UIColor(named: "Primary")
    }
    
    private func setReducedCarbonLabel(distance: Double) {
        reducedCarbonLabel.text = reducedCarbonCalculator.reducedCarbon(km: distance)
        reducedCarbonLabel.font = .rounded(ofSize: 48, weight: .bold)
    }
    
    private func setInformationLabel() {
        informationLabel.font = .rounded(ofSize: 16, weight: .bold)
    }
    
    private func setUpCircularProgressBarView(distance: Double = 0.0) {
        let circularProgressBarView: CircularProgressBarView = CircularProgressBarView(frame: .zero)
        circularProgressBarView.createCircularPath(distance: distance)
        // TODO: - center로 맞췄는데도 불구하고 중심이 안맞음 추후에 수정 필요
        circularProgressBarView.center = levelLabel.center
        circularProgressBarView.progressAnimation(duration: circularViewDuration)
        view.addSubview(circularProgressBarView)
   }
}

