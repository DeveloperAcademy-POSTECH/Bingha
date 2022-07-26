//
//  FirebaseController.swift
//  Bingha
//
//  Created by ryu hyunsun on 2022/07/17.
//

import Foundation
import FirebaseFirestore
import UIKit

class FirebaseController {
    let database = Firestore.firestore()
    public static var carbonModel: CarbonModel = CarbonModel(todayTotalDecreaseCarbon: 0.0, totalDistance: 0.0, totalDecreaseCarbon: 0.0)

    // 탄소 저감량 저장 (종료 버튼 눌렀을때)
    func saveDecreaseCarbonData(startTime: Date, endTime: Date, distance: Double, decreaseCarbon: Double) {
        // 버튼 누른 시간 기점으로 들어감.
        let dayToString = endTime.changeDayToString()
        let timeToString = endTime.changeTimeToString()
        // firestore db 컬렉션 및 다큐멘트 경로.
        let path = database.document("\( UIDevice.current.identifierForVendor!.uuidString + "-carbon")/\(dayToString)")
        // 경로가 존재한다면? 필드만 추가해줌.
        path.getDocument { (document, error) in
            if let document = document, document.exists {
                path.updateData(["\(timeToString)": [
                    "startTime": startTime,
                    "endTime": endTime,
                    "distance": distance,
                    "decreaseCarbon": decreaseCarbon
                ]])
                // 근데 경로가 없다면? 생성해준다!
            } else {
                // 시작시간, 끝 시간, 거리, 탄소 저감량 저장.
                path.setData([ "\(timeToString)": [
                    "startTime": startTime,
                    "endTime": endTime,
                    "distance": distance,
                    "decreaseCarbon": decreaseCarbon
                ]])
            }
        }
    }
    
    // 오늘 총 이동 거리, 탄소 저감량 로드 (최초 앱 들어올때!, 측정 완료시 확인용?)
    func loadTodayCarbonData() async throws {
        let todayToString = Date().changeDayToString()
        // 파이어 스토어 데이터 경로
        let path = database.document("\( await UIDevice.current.identifierForVendor!.uuidString+"-carbon")/\(todayToString)")
        // 데이터 불러오기
        print(path)
        let snapshot = try await path.getDocument()
        print("snapshot")
        print(snapshot)
        if let document = snapshot.data(), document.count != 0 {
            FirebaseController.carbonModel.todayTotalDecreaseCarbon = 0.0
            let values = document.values
            var todayTotalDecreseCarbon = 0.0
            for value in values {
                guard let parsedDictionary = value as? [String: Any],
                        let decreaseCarbon = parsedDictionary["decreaseCarbon"] as? Double
                else { return }
                todayTotalDecreseCarbon += decreaseCarbon
            }
            FirebaseController.carbonModel.todayTotalDecreaseCarbon = todayTotalDecreseCarbon
            print("오늘 총 저감한 탄소량 : \(FirebaseController.carbonModel.todayTotalDecreaseCarbon)")
        } else {
            print("데이터 없음")
        }
    }
    
    // 총 이동거리, 총 탄소 저감량 저장
    func saveIcebergData(totalDistance: Double, totalDecreaseCarbon: Double) {
        let path = database.document("\( UIDevice.current.identifierForVendor!.uuidString + "-iceberg")/icebergInfo")
        // 레벨 데이터 저장.
        path.setData([
            "totalDistance": totalDistance,
            "totalDecreaseCarbon": totalDecreaseCarbon
        ])
    }
    
    // 총 이동거리, 총 탄소 저감량 저장
    func loadIcebergData() async throws {
        let path = database.document("\( await UIDevice.current.identifierForVendor!.uuidString + "-iceberg")/icebergInfo")
        print(await UIDevice.current.identifierForVendor!.uuidString)
        let snapshot = try await path.getDocument()
        if let document = snapshot.data(), document.count != 0 {
            guard let totalDistance = document["totalDistance"] as? Double,
                  let totalDecreaseCarbon = document["totalDecreaseCarbon"] as? Double
            else { return }
            FirebaseController.carbonModel.totalDistance = totalDistance
            FirebaseController.carbonModel.totalDecreaseCarbon = totalDecreaseCarbon
            print("지금까지 총 저감한 탄소량 : \(FirebaseController.carbonModel.totalDistance)")
            print("지금까지 총 이동 거리 : \(FirebaseController.carbonModel.totalDecreaseCarbon)")
        }
    }
    
    // 주간 데이터 저장. 운동 끝나는 시간 넣을까?
    func saveWeeklyData(endTime: Date, distance: Double, decreaseCarbon: Double) {
        // 오늘 날짜로부터 월요일날짜 구하기.
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM-dd-e-EEEE"
        
        let day = formatter.string(from: endTime)
        var today = day.components(separatedBy: "-")
        print(today)
        // 일요일 = 1, 월요일 = 2, .... 토요일: 7
        if today[2] == "1" {
            today[2] = "8"
            //일요일일 경우 8로 계산해야 월 ~ 일까지의 주기가 맞춰진다.
        }
        guard let interval = Double(today[2]) else { return }
        // 시작 날짜를 어떻게 잡을까..? 월요일이면 그대로, 화요일이면
        // 월요일 -> interval = 2 -> interval - 1
        let startDay = Date(timeIntervalSinceNow: -(86400) * (interval-2))
        let startDayToString = formatter.string(from: startDay).components(separatedBy: "-")
        print("이번주 월요일 날짜?? : \(startDayToString)")
        
    }
    
}


extension Date {
    func changeDayToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dayToString = formatter.string(from: self)
        return dayToString
    }
    func changeTimeToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let timeToString = formatter.string(from: self)
        return timeToString
    }
}
