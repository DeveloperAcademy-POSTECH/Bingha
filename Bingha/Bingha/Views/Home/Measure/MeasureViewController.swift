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
    
    var timer: Timer?
    
    var startDate = Calendar.current.startOfDay(for: Date())
    
    var startDistance: Double = 0.0
    var endDistance: Double = 0.0
    var distanceDiff: Double = 0.0
    
    var isTimerOn = false
    
    var totalSecond: Int = 0
    var updateSecond: Int = 0
    
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
    
    private func startMeasurement() {
        HealthStore.shared.requestDistanceWalkingRunning(startDate: startDate) { [weak self] distance in
            guard let self = self else { return }
            
            self.startDistance = distance
            self.distanceDiff = 0.0
        }
    }
    
    private func endMeasurement() {
        HealthStore.shared.requestDistanceWalkingRunning(startDate: startDate) { [weak self] distance in
            guard let self = self else { return }
            
            self.endDistance = distance
            self.distanceDiff = (self.endDistance - self.startDistance)
        }
    }
    
    private func startTimer() {
        isTimerOn = true
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.totalSecond += 1
            self.updateSecond += 1
            
            if self.updateSecond == 30 {
                self.updateSecond = 0
            }
            
//            let hour = self.totalSecond / 3600
//            let minutes = (self.totalSecond % 3600) / 60
//            let seconds = (self.totalSecond % 3600) % 60
        }
    }
    
    private func endTimer() {
        isTimerOn = false
        
        self.timer?.invalidate()
    }
}
