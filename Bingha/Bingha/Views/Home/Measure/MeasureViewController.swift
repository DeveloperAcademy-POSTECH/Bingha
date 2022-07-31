//
//  MeasureViewController.swift
//  Bingha
//
//  Created by 이재웅 on 2022/07/15.
//

import UIKit
import Lottie
import SwiftUI
import CoreMotion

class MeasureViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var walkingDistanceView: UIView!
    @IBOutlet weak var reducedCarbonView: UIView!
    @IBOutlet weak var totalReducedCarbonLabel: UILabel!
    @IBOutlet weak var walkingDistanceLabel: UILabel!
    @IBOutlet weak var reducedCarbonLabel: UILabel!
    @IBOutlet weak var walkerImageView: UIImageView!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var timerLabel: UILabel!

    let firebaseController = FirebaseController()
    let walkerAnimationView = AnimationView()
    let measureBackgroundAnimationView = UIHostingController(rootView: MeasureBackgroundAnimation())

    var timer: Timer?
    
    let cmPedometer = CMPedometer()
    let reducedCarbonCalculator: ReducedCarbonCalculator = ReducedCarbonCalculator.shared
    
    var startDate: Date?

    var isTimerOn = false
    var walkingDistance: Double = 0.0
    var totalDistance = 0.0
    var totalSecond: Int = 0
    var todayCarbonDecrease: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.addSubview(self.walkerImageView)
        setTodayTotalCarbonlabel()
        setNotification()
        setAttribute()
    }

    
    // 버튼 눌렀을 때 뷰 스위칭
    @IBAction func buttonTapped(_ sender: UIButton) {
        if CMPedometer.authorizationStatus() == CMAuthorizationStatus.authorized {
            if (sender.tag == 0) {
                totalSecond = 0
                startDate = Date()
                
                startTimer()
                startMeasurement()
                playAnimation()
                changeToEndButton()
                sender.tag = 1
            }
            else if (sender.tag == 1) {
                endTimer()
                stopMeasurement()
                
                saveData()
                totalDistance += walkingDistance
                setDefaultView()
                
                let minutes = (totalSecond % 3600) / 60
                let seconds = (totalSecond % 3600) % 60

                guard let nextVC = self.storyboard?.instantiateViewController(identifier: "CompleteReference") as? CompleteViewController else { return }
                
                nextVC.reducedCarbon = reducedCarbonLabel.text ?? ""
                nextVC.todayReducedCarbon = totalReducedCarbonLabel.text ?? ""
                nextVC.moveDistance = walkingDistance.setOneDemical() + "Km"
                nextVC.timeDuration = String(format: "%02d:%02d", minutes, seconds)
                
                nextVC.modalTransitionStyle = .coverVertical
                nextVC.modalPresentationStyle = .fullScreen
                
                self.present(nextVC, animated: true, completion: nil)
                sender.tag = 0
                
                walkingDistanceLabel.text = "0.0km"
                reducedCarbonLabel.text = "0g"
            }
        } else {
            alertAuthAlert()
        }
    }
    
    // 홈 디폴트 뷰 세팅
    private func setDefaultView(){
        startButton.setTitle("시작",for:.normal)
        startButton.backgroundColor = UIColor(named: "Primary")
        walkerImageView.image = UIImage(named: "StandingMan")
        walkerImageView.frame = CGRect(x: 0, y: 5, width: 58, height: 58)
        walkerAnimationView.isHidden = true
        measureBackgroundAnimationView.view.removeFromSuperview()
    }
    
    // 시작 버튼에서 완료 버튼으로 변환
    private func changeToEndButton(){
        startButton.setTitle("완료",for:.normal)
        startButton.backgroundColor = UIColor(named: "PointOrange")
    }
    
    // lottie 파일 walker 애니메이션
    private func playWalkAnimation() {
        // walker 이미지, 애니메이션 보이기 설정
        imageView.addSubview(walkerAnimationView)
        walkerImageView.image = nil;
        walkerAnimationView.isHidden = false
        
        walkerAnimationView.animation = Animation.named("walker")
        walkerAnimationView.frame = CGRect(x: 0, y: 4, width: 58, height: 58)
        walkerAnimationView.contentMode = .scaleAspectFit
        walkerAnimationView.loopMode = .loop
        walkerAnimationView.backgroundBehavior = .pauseAndRestore
        walkerAnimationView.play()
    }
    
    // background 애니메이션
    private func playBackgroundAnimation() {
        view.insertSubview(measureBackgroundAnimationView.view, at: 0)
        measureBackgroundAnimationView.didMove(toParent: self)
        measureBackgroundAnimationView.view.translatesAutoresizingMaskIntoConstraints = false
        measureBackgroundAnimationView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        measureBackgroundAnimationView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        measureBackgroundAnimationView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        measureBackgroundAnimationView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func playAnimation() {
        playWalkAnimation()
        playBackgroundAnimation()
    }
    
    // 이동거리뷰, 탄소배출 저감량뷰, 시작버튼 커스텀
    private func setAttribute() {
        
        //WalkingDistanceView Custom
        walkingDistanceView.layer.shadowOpacity = 0.2
        walkingDistanceView.layer.shadowOffset = CGSize(width: 0, height: 2)
        walkingDistanceView.layer.shadowColor = UIColor.darkGray.cgColor
        walkingDistanceView.layer.cornerRadius = 20
        
        //ReducedCarbonView Custom
        reducedCarbonView.layer.shadowOpacity = 0.2
        reducedCarbonView.layer.shadowOffset = CGSize(width: 0, height: 2)
        reducedCarbonView.layer.shadowColor = UIColor.darkGray.cgColor
        reducedCarbonView.layer.cornerRadius = 20
        
        //StartButton Custom
        startButton.layer.cornerRadius = startButton.frame.width / 2
        startButton.layer.masksToBounds = true
        startButton.layer.shadowOpacity = 0.2
        startButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        startButton.layer.shadowColor = UIColor.darkGray.cgColor
        startButton.titleLabel?.font = UIFont.rounded(ofSize: 32, weight: .bold)
        
        //글꼴 설정
        walkingDistanceLabel.font = .rounded(ofSize: 36, weight: .bold)
        totalReducedCarbonLabel.font = .rounded(ofSize: 48, weight: .bold)
        reducedCarbonLabel.font = .rounded(ofSize: 36, weight: .bold)
        timerLabel.font = .rounded(ofSize: 15, weight: .medium)
        
    }
    
    private func startMeasurement() {
        walkingDistance = 0.0
        walkingDistanceLabel.text = "0.0km"
        self.reducedCarbonLabel.text = "0g"
        
        if CMPedometer.isDistanceAvailable() {
            cmPedometer.startUpdates(from: Date()) { [weak self] data, error in
                guard let self = self else { return }
                guard let data = data else {
                    if let error = error { print(error.localizedDescription) }
                    return
                }

                DispatchQueue.main.async {
                    let distance  = Double(truncating: data.distance ?? 0) * 0.001

                    self.walkingDistance = distance
                    self.walkingDistanceLabel.text = "\(distance.setOneDemical())km"
                    self.reducedCarbonLabel.text = "\(self.reducedCarbonCalculator.reducedCarbonDouble(km: self.walkingDistance).setOneDemical())g"
                    self.totalReducedCarbonLabel.text = ((self.todayCarbonDecrease + self.reducedCarbonCalculator.reducedCarbonDouble(km: self.walkingDistance)).setOneDemical() + "g")
                }
            }
        }
    }
    
    private func stopMeasurement() {
        cmPedometer.stopUpdates()
    }
    
    private func startTimer() {
        isTimerOn = true
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                
                self.totalSecond += 1
                
                // 타이머표시 Label에서 사용할 변수
                let minutes = (self.totalSecond % 3600) / 60
                let seconds = (self.totalSecond % 3600) % 60
                
                self.timerLabel.text = String(format: "%d:%02d", minutes, seconds)
            }
        }
    }
    
    private func endTimer() {
        isTimerOn = false
        self.timer?.invalidate()
        self.timerLabel.text = "0:00"
    }
    
    private func setNotification() {
        // Background > Foreground
        NotificationCenter.default.addObserver(self, selector: #selector(addBackgroundTime(_:)), name: Notification.Name("sceneWillEnterForeground"), object: nil)
        // Foreground > Background
        NotificationCenter.default.addObserver(self, selector: #selector(stopTimerAndSaveSeconds), name: Notification.Name("sceneDidEnterBackground"), object: nil)
    }
    
    @objc func addBackgroundTime(_ notification: Notification) {
        if isTimerOn {
            let time = notification.userInfo?["time"] as? Int ?? 0
            totalSecond = time
            
            startTimer()
        }
    }
    
    @objc func stopTimerAndSaveSeconds() {
        self.timer?.invalidate()
        UserDefaults.standard.setValue(totalSecond, forKey: "totalSecond")
    }
    
    func alertAuthAlert() {
        let authAlertController = UIAlertController(title: "Motion 데이터 사용 권한이 필요합니다.", message: "Motion 데이터 사용 권한을 허용해야 이동거리 측정이 가능합니다.", preferredStyle: .alert)
        let getAuthAction = UIAlertAction(title: "설정", style: .default) { action in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        let denyAuthAction = UIAlertAction(title: "거부", style: .cancel, handler: nil)
        
        [getAuthAction, denyAuthAction].forEach { authAlertController.addAction($0) }
        
        self.present(authAlertController, animated: true)
    }
    
    private func setTodayTotalCarbonlabel() {
        todayCarbonDecrease = FirebaseController.todayTotalDecreaseCarbon
        totalReducedCarbonLabel.text = todayCarbonDecrease.setOneDemical() + "g"
    }
    
    private func saveData() {
        // 시작시간 있을때만 파이어스토어에 저장.
        if let startDate = startDate {
            updateLocalData()
            firebaseController.saveDecreaseCarbonData(startTime: startDate, endTime: Date(), distance: walkingDistance, decreaseCarbon: reducedCarbonCalculator.reducedCarbonDouble(km: walkingDistance), totalSecond: totalSecond)
            firebaseController.saveWeeklyData(endTime: Date(), distance: walkingDistance, decreaseCarbon: reducedCarbonCalculator.reducedCarbonDouble(km: walkingDistance), totalSecond: totalSecond)
            firebaseController.saveMonthlyData(endTime: Date(), distance: walkingDistance, decreaseCarbon: reducedCarbonCalculator.reducedCarbonDouble(km: walkingDistance), totalSecond: totalSecond)
            firebaseController.saveIcebergData(totalDistance: FirebaseController.carbonModel.totalDistance, totalDecreaseCarbon: FirebaseController.carbonModel.totalDecreaseCarbon)
        }
    }
    
    // 운동 끝날을 때 데이터 업데이트.
    private func updateLocalData() {
        // 오늘 토탈 저감량, 방금 저감량, 방금 운동거리 업데이트.
        FirebaseController.carbonModel.totalDecreaseCarbon += reducedCarbonCalculator.reducedCarbonDouble(km: walkingDistance)
        FirebaseController.carbonModel.totalDistance += walkingDistance
        FirebaseController.todayTotalDecreaseCarbon += reducedCarbonCalculator.reducedCarbonDouble(km: walkingDistance)
        FirebaseController.weeklyTotalDecreaseCarbon += reducedCarbonCalculator.reducedCarbonDouble(km: walkingDistance)
        FirebaseController.monthlyTotalDecreaseCarbon += reducedCarbonCalculator.reducedCarbonDouble(km: walkingDistance)
        // 오늘 운동 추가해주기.
        StatisticsViewModel.todayStatisticsList.append(Statistics(reducedCarbon: reducedCarbonCalculator.reducedCarbonDouble(km: walkingDistance), walkingDistance: walkingDistance, walkingTime: totalSecond, baseDate: "오늘"))
        setTodayTotalCarbonlabel()
        // 주간 운동 로컬에 추가해주기.
        if StatisticsViewModel.weeklyStatisticsList.count > 0 {
            if StatisticsViewModel.weeklyStatisticsList[0].baseDate == "이번 주" {
                // 이번 주 운동이 있으면 업데이트해줘야하는데... 스트링이라서.... 후..
                StatisticsViewModel.weeklyStatisticsList[0].walkingDistance += walkingDistance
                StatisticsViewModel.weeklyStatisticsList[0].reducedCarbon += reducedCarbonCalculator.reducedCarbonDouble(km: walkingDistance)
                StatisticsViewModel.weeklyStatisticsList[0].walkingTime += totalSecond
                
            } else {
                StatisticsViewModel.weeklyStatisticsList.insert(Statistics(reducedCarbon: reducedCarbonCalculator.reducedCarbonDouble(km: walkingDistance), walkingDistance: walkingDistance, walkingTime: totalSecond, baseDate: "이번 주"), at: 0)
            }
            
        } else {
            StatisticsViewModel.weeklyStatisticsList.append(Statistics(reducedCarbon: reducedCarbonCalculator.reducedCarbonDouble(km: walkingDistance), walkingDistance: walkingDistance, walkingTime: totalSecond, baseDate: "이번 주"))
        }
        
        // 월간 운동 로컬에 추가해주기.
        if StatisticsViewModel.monthlyStatisticsList.count > 0 {
            if StatisticsViewModel.monthlyStatisticsList[0].baseDate == "이번 달" {
                // 이번 달 운동이 있으면 업데이트해줘야함..
                StatisticsViewModel.monthlyStatisticsList[0].walkingDistance += walkingDistance
                StatisticsViewModel.monthlyStatisticsList[0].reducedCarbon += reducedCarbonCalculator.reducedCarbonDouble(km: walkingDistance)
                StatisticsViewModel.monthlyStatisticsList[0].walkingTime += totalSecond
            } else {
                StatisticsViewModel.monthlyStatisticsList.insert(Statistics(reducedCarbon: reducedCarbonCalculator.reducedCarbonDouble(km: walkingDistance), walkingDistance: walkingDistance, walkingTime: totalSecond, baseDate: "이번 달"), at: 0)
            }
            
        } else {
            StatisticsViewModel.monthlyStatisticsList.append(Statistics(reducedCarbon: reducedCarbonCalculator.reducedCarbonDouble(km: walkingDistance), walkingDistance: walkingDistance, walkingTime: totalSecond, baseDate: "이번 달"))
        }
    }
}
