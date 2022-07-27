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
    
    let firebaseController = FirebaseController()
    let icebergLevelCalculator: IcebergLevelCalculator = IcebergLevelCalculator.shared
    let reducedCarbonCalculator: ReducedCarbonCalculator = ReducedCarbonCalculator.shared
    let circularViewDuration: TimeInterval = 2
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAttribute()
        fetchTotalDistance()
    }
    
    private func setAttribute() {
        setRoundedRectangle()
        setInformationLabel()
    }
    
    private func fetchTotalDistance() {
        Task {
            try await firebaseController.loadIcebergData()
            setLevelLabel(level: IcebergLevelCalculator.shared.requestIcebergLevel(distance: FirebaseController.carbonModel.totalDistance))
            setReducedCarbonLabel(distance: FirebaseController.carbonModel.totalDistance)
            setUpCircularProgressBarView(distance: FirebaseController.carbonModel.totalDistance)
        }
    }
    
    private func setRoundedRectangle() {
        roundedRectangle.layer.cornerRadius = 20
    }
    
    // TODO: - 경험치에 따라 levelLabel 동적으로 변하게
    private func setLevelLabel(level: String) {
        levelLabel.text = "Lv. \(level)"
        levelLabel.font = .rounded(ofSize: 20, weight: .bold)
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

