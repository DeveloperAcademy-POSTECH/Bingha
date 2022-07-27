//
//  MeasureViewController.swift
//  Bingha
//
//  Created by 이재웅 on 2022/07/15.
//

import UIKit
import Lottie

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
    let backgroundAnimationView = AnimationView()

    var timer: Timer?
    
    let healthStore: HealthStore = HealthStore.shared
    
    var anchorDate = Calendar.current.startOfDay(for: Date())
    var startDate: Date?
    
    var startDistance: Double = 0.0
    var endDistance: Double = 0.0
    var distanceDiff: Double = 0.0
    
    var isTimerOn = false
    var totalDistance = 0.0
    var totalSecond: Int = 0
    
    var todayCarbonDecrease: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.addSubview(self.walkerImageView)
        
        setNotification()
        setAttribute()

        // 비동기 처리. 파이어베이스에서 오늘 총 탄소 저감량 데이터 불러와서 라벨에 매핑.
        loadTodayCarbondata()
    }
    
    // 버튼 눌렀을 때 뷰 스위칭
    @IBAction func buttonTapped(_ sender: UIButton) {
        if (sender.tag == 0) {
            totalSecond = 0
            startDate = Date()
            
            startTimer()
            measureStartDistance()
            playAnimation()
            changeToEndButton()
            sender.tag = 1
        }
        else if (sender.tag == 1) {
            endTimer()
            measureEndDistance()
            
            saveData()
            totalDistance += distanceDiff
            
            setDefaultView()
            
            let minutes = (totalSecond % 3600) / 60
            let seconds = (totalSecond % 3600) % 60

            guard let nextVC = self.storyboard?.instantiateViewController(identifier: "CompleteReference") as? CompleteViewController else { return }
            
            nextVC.reducedCarbon = reducedCarbonLabel.text ?? ""
            nextVC.todayReducedCarbon = totalReducedCarbonLabel.text ?? ""
            nextVC.moveDistance = distanceDiff.setOneDemical() + "Km"
            nextVC.timeDuration = String(format: "%02d:%02d", minutes, seconds)
            
            nextVC.modalTransitionStyle = .coverVertical
            nextVC.modalPresentationStyle = .fullScreen
            
            self.present(nextVC, animated: true, completion: nil)
            sender.tag = 0
        }
    }
    
    // 홈 디폴트 뷰 세팅
    private func setDefaultView(){
        startButton.setTitle("시작",for:.normal)
        startButton.backgroundColor = UIColor(named: "Primary")
        walkerImageView.image = UIImage(named: "StandingMan")
        walkerAnimationView.isHidden = true
        view.backgroundColor = .white
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
    
    // background 애니메이션 (임시)
    private func playBackgroundAnimation() {
        view.backgroundColor = UIColor(displayP3Red: 0.87, green: 0.93, blue: 0.93, alpha: 1)
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
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 32.0, weight: .bold)
    }
    
    private func measureStartDistance() {
        healthStore.requestDistanceWalkingRunning(startDate: anchorDate) { [weak self] distance in
            guard let self = self else { return }
            
            self.startDistance = distance
            self.distanceDiff = 0.0
        }
    }
    
    private func measureEndDistance() {
        healthStore.requestDistanceWalkingRunning(startDate: anchorDate) { [weak self] distance in
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
            
            if (self.totalSecond % 30) == 0 {
                self.measureEndDistance()
                self.totalReducedCarbonLabel.text = ((self.todayCarbonDecrease + ReducedCarbonCalculator.shared.reducedCarbonDouble(km: self.distanceDiff)).setOneDemical() + "g")
            }
            
            // 타이머표시 Label에서 사용할 변수
            let minutes = (self.totalSecond % 3600) / 60
            let seconds = (self.totalSecond % 3600) % 60
            self.timerLabel.text = String(format: "%d:%02d", minutes, seconds)
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
            
            // endMeasurement를 실행할 경우 이동거리 업데이트
            measureEndDistance()
            startTimer()
        }
    }
    
    @objc func stopTimerAndSaveSeconds() {
        self.timer?.invalidate()
        UserDefaults.standard.setValue(totalSecond, forKey: "totalSecond")
    }
    
    private func loadTodayCarbondata() {
        Task {
            try await firebaseController.loadTodayCarbonData()
            todayCarbonDecrease = FirebaseController.carbonModel.todayTotalDecreaseCarbon
            totalReducedCarbonLabel.text = todayCarbonDecrease.setOneDemical() + "g"
        }
    }
    
    private func saveData() {
        // 시작시간 있을때만 파이어스토어에 저장.
        // 주간 데이터 업데이트.
//        firebaseController.saveWeeklyData(endTime: Date(), distance: 3.0, decreaseCarbon: 3.0)
        
        if let startDate = startDate {
            firebaseController.saveDecreaseCarbonData(startTime: startDate, endTime: Date(), distance: distanceDiff, decreaseCarbon: ReducedCarbonCalculator.shared.reducedCarbonDouble(km: distanceDiff))
        }
        
        Task {
            try await firebaseController.loadIcebergData()
            firebaseController.saveIcebergData(totalDistance: FirebaseController.carbonModel.totalDistance + distanceDiff, totalDecreaseCarbon: ReducedCarbonCalculator.shared.reducedCarbonDouble(km: FirebaseController.carbonModel.totalDistance + distanceDiff))
            // 주간 데이터 로드
//            try await firebaseController.loadWeeklyData()
        }
    }
    
}
