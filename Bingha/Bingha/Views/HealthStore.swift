//
//  HealthStore.swift
//  Bingha
//
//  Created by 이재웅 on 2022/07/19.
//

import Foundation
import HealthKit

internal class HealthStore {
    public static var shared: HealthStore = HealthStore()
    
    private init() { }
    
    enum Authority {
        case notAuthorized
        case approved
        case rejected
    }
    
    private var healthStore: HKHealthStore?
    
    // enum을 던져주고 VC에서 didset으로 상태에 따라 함수를 실행하도록 (completionHandler를 이용할 시)
    // or combine을 사용한다며
    func requestAuthorization(completion: @escaping (Bool) -> ()) {
        HealthStore.shared.healthStore = HKHealthStore()

        let read = Set([HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!])

        // 데이터 사용 권한요청
        HealthStore.shared.healthStore?.requestAuthorization(toShare: nil, read: read) { success, error in
            if success {
                debugPrint("건강데이터 접근 권한 승인.")
            } else {
                print("건강데이터 접근 권한 거부.")
                debugPrint(error.debugDescription)
            }
            completion(success)
        }
    }

    func requestDistanceWalkingRunning(startDate: Date, completion: @escaping (Double) -> (Void)) {
        if HKHealthStore.isHealthDataAvailable() {
            
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
                
                distance = sum.doubleValue(for: HKUnit.meter())
                
                DispatchQueue.main.async {
                    completion((distance * 0.001))
                }
            }
            
            HealthStore.shared.healthStore?.execute(query)
        } else {
            debugPrint("HealthKit 데이터 사용불가")
        }
    }

}
