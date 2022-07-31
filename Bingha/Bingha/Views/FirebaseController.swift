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
    func saveDecreaseCarbonData(startTime: Date, endTime: Date, distance: Double, decreaseCarbon: Double, totalSecond: Int) {
        // 버튼 누른 시간 기점으로 들어감.
        let dayToString = endTime.changeDayToString()
        let timeToString = endTime.changeTimeToString()
        // firestore db 컬렉션 및 다큐멘트 경로.
        let path = database.document("\( UIDevice.current.identifierForVendor!.uuidString + "-daily")/\(dayToString)")
        // 경로가 존재한다면? 필드만 추가해줌.
        path.getDocument { (document, error) in
            if let document = document, document.exists {
                path.updateData(["\(timeToString)": [
                    "startTime": startTime,
                    "endTime": endTime,
                    "distance": distance,
                    "decreaseCarbon": decreaseCarbon,
                    "totalSecond": totalSecond
                ]])
                // 근데 경로가 없다면? 생성해준다!
            } else {
                // 시작시간, 끝 시간, 거리, 탄소 저감량 저장.
                path.setData([ "\(timeToString)": [
                    "startTime": startTime,
                    "endTime": endTime,
                    "distance": distance,
                    "decreaseCarbon": decreaseCarbon,
                    "totalSecond": totalSecond
                ]])
            }
        }
    }
    
    // 오늘 총 이동 거리, 탄소 저감량 로드 (최초 앱 들어올때!, 측정 완료시 확인용?)
    func loadTodayCarbonData() async throws {
        let todayToString = Date().changeDayToString()
        // 파이어 스토어 데이터 경로
        let path = database.document("\( await UIDevice.current.identifierForVendor!.uuidString+"-daily")/\(todayToString)")
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
                      let decreaseCarbon = parsedDictionary["decreaseCarbon"] as? Double,
//                      let totalSecond = parsedDictionary["totalSecond"] as? Int,
//                      let endTime = parsedDictionary["endTime"] as? Timestamp,
                      let distance = parsedDictionary["distance"] as? Double
                else {
                    return }
                todayTotalDecreseCarbon += decreaseCarbon
                StatisticsViewModel.todayStatisticsList.append(Statistics(reducedCarbon: String(format: "%02d", decreaseCarbon) + "kg", walkingDistance: String(distance) + "km", walkingTime: "오늘", baseDate: "오늘"))
                
            }
            FirebaseController.carbonModel.todayTotalDecreaseCarbon = todayTotalDecreseCarbon
            print("오늘 총 저감한 탄소량 : \(FirebaseController.carbonModel.todayTotalDecreaseCarbon)")
            print("오늘 총 모델: \(StatisticsViewModel.todayStatisticsList)")
        } else {
            print("데이터 없음")
        }
    }
    
    // 총 이동거리, 총 탄소 저감량 저장
    func saveIcebergData(totalDistance: Double, totalDecreaseCarbon: Double) {
        let path = database.document("\( UIDevice.current.identifierForVendor!.uuidString + "-total")/total")
        // 레벨 데이터 저장.
        path.setData([
            "totalDistance": totalDistance,
            "totalDecreaseCarbon": totalDecreaseCarbon
        ])
    }
    
    // 총 이동거리, 총 탄소 저감량 저장
    func loadIcebergData() async throws {
        let path = database.document("\( await UIDevice.current.identifierForVendor!.uuidString + "-total")/total")
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
        let startDay = endTime.findMonday()
        let startDayToString = startDay.changeDayToString()
        print("이번주 월요일 날짜?? : \(startDayToString)")
        
        let path = database.document("\( UIDevice.current.identifierForVendor!.uuidString + "-weekly")/\(startDayToString)")
        
        path.getDocument { (document, error) in
            if let document = document?.data(), document.count != 0 {
                guard let weeklyDistance = document["weeklyDistance"] as? Double,
                      let weeklyDecrease = document["weeklyDecreaseCarbon"] as? Double
                else { return }
                path.setData([
                    "weeklyDistance": distance + weeklyDistance,
                    "weeklyDecreaseCarbon": decreaseCarbon + weeklyDecrease
                ])
                // 근데 경로가 없다면? 생성해준다!
            } else {
                print("여기????")
                // 시작시간, 끝 시간, 거리, 탄소 저감량 저장.
                path.setData([
                    "weeklyDistance": distance,
                    "weeklyDecreaseCarbon": decreaseCarbon
                ])
            }
        }
    }
    // 주간 걸은 거리, 탄소 저감량 로드
    func loadWeeklyData() async throws {
        // 이번주 월요일 날짜 계산하기.
        let today = Date()
        // 이번주, 지난주, 2주전, 3주전. 불러오기.
        for i in 0...4 {
            let interval = Double(i * 7)
            let pastMonday = today.findPastMonday(interval: interval)
            let pastMondayToString = pastMonday.changeDayToString()
            let path = database.document("\( await UIDevice.current.identifierForVendor!.uuidString + "-weekly")/\(pastMondayToString)")
            let snapshot = try await path.getDocument()
            
            if let document = snapshot.data(), document.count != 0 {
                //MARK: 얘네 저장만 해주면 끝
                guard let weeklyDistance = document["weeklyDistance"] as? Double,
                      let weeklyDecreaseCarbon = document["weeklyDecreaseCarbon"] as? Double
                else { return }
                print(weeklyDistance)
                print(weeklyDecreaseCarbon)
            }
            
        }
    }
    
    // 월간 데이터 저장.
    func saveMonthlyData(endTime: Date, distance: Double, decreaseCarbon: Double) {
        let today = Date()
        let presentMonth = today.findMonth()
        let path = database.document("\( UIDevice.current.identifierForVendor!.uuidString + "-monthly")/\(presentMonth)")
        
        path.getDocument { (document, error) in
            if let document = document?.data(), document.count != 0 {
                guard let weeklyDistance = document["monthlyDistance"] as? Double,
                      let weeklyDecrease = document["monthlyDecreaseCarbon"] as? Double
                else { return }
                path.setData([
                    "monthlyDistance": distance + weeklyDistance,
                    "monthlyDecreaseCarbon": decreaseCarbon + weeklyDecrease
                ])
            } else {
                path.setData([
                    "monthlyDistance": distance,
                    "monthlyDecreaseCarbon": decreaseCarbon
                ])
            }
        }
    }
    
    // 월간 데이터 로드
    func loadMonthlyData() async throws {
        let today = Date()
        let presentMonth = today.findMonth().components(separatedBy: "-").map({(value : String) -> Int in return Int(value)!})
        // 이번달, 지난달, 2달 전, 3달 전 데이터 가져오기.
        for i in 0...4 {
            let interval = Int(i)
            var currentMonth = presentMonth[1] - interval
            var currentYear = presentMonth[0]
            if currentMonth < 1 {
                currentMonth = 12
                currentYear -= 1
            }
            let currentMonthToString = String(format: "%02d", currentMonth)
            let presentTime = "\(currentYear)-\(currentMonthToString)"
            let path = database.document("\( await UIDevice.current.identifierForVendor!.uuidString + "-monthly")/\(presentTime)")
            let snapshot = try await path.getDocument()
            if let document = snapshot.data(), document.count != 0 {
                //MARK: 얘네 저장만 해주면 끝
                guard let monthlyDistance = document["monthlyDistance"] as? Double,
                      let monthlyDecreaseCarbon = document["monthlyDecreaseCarbon"] as? Double
                else { return }
                print(monthlyDistance)
                print(monthlyDecreaseCarbon)
            }
            
        }
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
    
    func findMonday() -> Date {
        // 오늘 날짜로부터 월요일날짜 구하기.
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM-dd-e-EEEE"
        let day = formatter.string(from: self)
        var today = day.components(separatedBy: "-")
        // 일요일 = 1, 월요일 = 2, .... 토요일: 7
        if today[2] == "1" {
            today[2] = "8"
            //일요일일 경우 8로 계산해야 월 ~ 일까지의 주기가 맞춰진다.
        }
        guard let interval = Double(today[2]) else { return Date()}
        // 시작 날짜를 어떻게 잡을까..? 월요일이면 그대로, 화요일이면
        // 월요일 -> interval = 2 -> interval - 1
        let startDay = Date(timeIntervalSinceNow: -(86400) * (interval-2))
        return startDay
    }
    
    func findPastMonday(interval: Double) -> Date {
        // 이번주 월요일 불러오기
        let monday = Date().findMonday()
        let pastMonday = Date(timeInterval: -(86400) * interval, since: monday)
        return pastMonday
    }
    
    func findMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        let monthToString = formatter.string(from: self)
        return monthToString
    }
    
}
