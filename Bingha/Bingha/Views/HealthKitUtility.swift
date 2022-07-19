//
//  HealthKitUtility.swift
//  Bingha
//
//  Created by 이재웅 on 2022/07/19.
//

import Foundation
import HealthKit

var healthStore: HKHealthStore?

func requestHealthKitAuthorization() {
    healthStore = HKHealthStore()
    
    let read = Set([HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!])
    
    // 데이터 사용 권한요청
    healthStore?.requestAuthorization(toShare: nil, read: read) { success, error in
        if success {
            debugPrint("권한이 허락되었습니다.")
        } else {
            debugPrint(error.debugDescription)
        }
    }
}

func getDistanceWalkingRunning(startDate: Date, completion: @escaping (Double) -> (Void)) {
    func convertMileToKM(_ mile: Double) -> Double {
        mile * 1.60934
    }
    
    if HKHealthStore.isHealthDataAvailable() {
        requestHealthKitAuthorization()
        
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else { return }
        
        let now = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            var distance: Double = 0.0
            
            guard let result = result else {
                debugPrint("HealthKit Query 생성 실패")
                return
            }
            guard let sum = result.sumQuantity() else {
                debugPrint("HealthKit Query 결과값 합산 실패")
                return
            }
            
            distance = sum.doubleValue(for: HKUnit.mile())
            
            DispatchQueue.main.async {
                completion(convertMileToKM(distance))
            }
        }
        
        healthStore?.execute(query)
    } else {
        debugPrint("HealthKit 데이터 사용불가")
    }
}
