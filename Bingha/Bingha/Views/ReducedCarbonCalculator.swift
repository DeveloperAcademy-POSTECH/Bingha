//
//  CarbonEmissionCalculateUtil.swift
//  Bingha
//
//  Created by Terry Koo on 2022/07/18.
//

import Foundation

internal class ReducedCarbonCalculator {
    public static let shared: ReducedCarbonCalculator = ReducedCarbonCalculator()

    private init(){}
    
    func reducedCarbon(km distance :Double) -> String {
        // 자가용으로 1km 이동 시 약 134g의 탄소 배출이 발생함
        return (distance * 134).formatterWithSeparator + "g"
    }
}

