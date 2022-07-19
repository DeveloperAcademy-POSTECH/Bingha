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
