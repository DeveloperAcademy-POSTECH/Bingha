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
    @IBOutlet weak var timerLabel: UILabel!
    
    let walkerAnimationView = AnimationView()
    let backgroundAnimationView = AnimationView()
    let firebaseController = FirebaseController()
    var timer: Timer?
    
    var startDate = Calendar.current.startOfDay(for: Date())
    
    var startDistance: Double = 0.0
    var endDistance: Double = 0.0
    // 이동거리 표시 Label에서 사용할 변수
    var distanceDiff: Double = 0.0
    
    var isTimerOn = false
    var alldistance = 0.0
    var totalSecond: Int = 0
    var updateSecond: Int = 0
    
    //완료화면 모달용 더미데이터
    var todayCarbonDecrease: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNotification()
        self.ImageView.addSubview(self.WalkerImageView)
        ViewCustom()
        // 비동기 처리. 파이어베이스에서 오늘 총 탄소 저감량 데이터 불러와서 라벨에 매핑.
        loadTodayCarbondata()

    }
    
    // 버튼 눌렀을 때 뷰 스위칭
    @IBAction func buttonTapped(_ sender: UIButton) {
        if (sender.tag == 0) {
            self.totalSecond = 0
            self.startTimer()
            self.startMeasurement()
            WalkerAnimation()
            backgroundAnimation()
            ChangeToEndButton()
            sender.tag = 1
        }
        else if (sender.tag == 1) {
            self.endTimer()
            self.endMeasurement()
            firebaseController.saveDecreaseCarbonData(startTime: startDate, endTime: Date(), distance: distanceDiff, decreaseCarbon: ReducedCarbonCalculator.shared.reducedCarbonDouble(km: distanceDiff))
            
            firebaseController.loadIcebergData { totaldistance in
                self.alldistance = totaldistance
            }
            firebaseController.saveIcebergData(totalDistance: self.alldistance + self.distanceDiff, totalDecreaseCarbon: ReducedCarbonCalculator.shared.reducedCarbonDouble(km: self.alldistance + self.distanceDiff))
            self.alldistance += self.distanceDiff
            
            defaultView()
            
            //완료버튼 눌렀을 때 결과화면으로 데이터 전달
            
            let minutes = (self.totalSecond % 3600) / 60
            let seconds = (self.totalSecond % 3600) % 60
            //완료버튼 눌렀을 때 결과 화면 모달 띄우기
            guard let nextVC = self.storyboard?.instantiateViewController(identifier: "CompleteReference") as? CompleteViewController else { return }
            
            nextVC.reducedCarbon = self.ReducedCarbonLabel.text ?? ""
            nextVC.todayReducedCarbon = self.TotalReducedCarbonLabel.text ?? ""
            nextVC.moveDistance = distanceDiff.setOneDemical() + "Km"
            nextVC.timeDuration = String(format: "%02d:%02d", minutes, seconds)
            
            nextVC.modalTransitionStyle = .coverVertical
            nextVC.modalPresentationStyle = .fullScreen
            
            self.present(nextVC, animated: true, completion: nil)
            sender.tag = 0
        }
    }
    
    // 홈 디폴트 뷰 세팅
    private func defaultView(){
        StartButton.setTitle("시작",for:.normal)
        StartButton.backgroundColor = UIColor(named: "Primary")
        WalkerImageView.image = UIImage(named: "StandingMan")
        walkerAnimationView.isHidden = true
        self.view.backgroundColor = .white
    }
    
    // 시작 버튼에서 완료 버튼으로 변환
    private func ChangeToEndButton(){
        StartButton.setTitle("완료",for:.normal)
        StartButton.backgroundColor = UIColor(named: "PointOrange")
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
        walkerAnimationView.backgroundBehavior = .pauseAndRestore
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
                self.endMeasurement()
                self.TotalReducedCarbonLabel.text = ((self.todayCarbonDecrease + ReducedCarbonCalculator.shared.reducedCarbonDouble(km: self.distanceDiff)).setOneDemical() + "g")
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
            endMeasurement()
            startTimer()
        }
    }
    
    @objc func stopTimerAndSaveSeconds() {
        self.timer?.invalidate()
        UserDefaults.standard.setValue(totalSecond, forKey: "totalSecond")
    }
    
    private func loadTodayCarbondata() {
        Task {
            let firebaseController = FirebaseController()
            try await firebaseController.loadTodayCarbonData()
            self.todayCarbonDecrease = FirebaseController.carbonModel.todayTotalDecreaseCarbon
            self.TotalReducedCarbonLabel.text = self.todayCarbonDecrease.setOneDemical()
        }
    }
    
}
