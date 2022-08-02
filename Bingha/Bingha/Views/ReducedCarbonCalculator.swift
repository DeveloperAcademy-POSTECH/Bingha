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
    
    // 내가 걸은 거리만큼 계산했을 때 탄소 배출이 얼마나 감소했을까
    func reducedCarbon(km distance: Double) -> String {
        // 자가용으로 1km 이동 시 약 134g의 탄소 배출이 발생함
        return (distance * 134).formatterWithSeparator + "g"
    }
    
    // 내가 걸은 거리만큼 계산했을 때 빙하가 얼마나 지켜졌을까
    func protectedGlacier(carbon: Double) -> String {
        // 자가용으로 1km 이동 시 약 2kg의 빙하가 소멸 -> 1km를 걸어갔을 경우 2kg의 빙하를 지킴
        // 134g 탄소를 저감했다 -> 2kg의 빙하를 지킴
        return (carbon/134 * 2).formatterWithSeparator + "kg"
//        return (carbon * 2).formatterWithSeparator + "kg"
    }
    

    func reducedCarbonDouble(km distance: Double) -> Double {
        return (distance * 134)
    }
    
    // 30년 소나무 1년에 6.6kg의 탄소를 흡수함
    func reducedCarbonToTree(carbon: Double) -> String {
        if carbon <= 2.0 {
            return "거의 아무 일도 하지 않은 양이에요"
        }
        if carbon < 12.0 {
            return "한나절 이내로 산소로 바꿀 수 있는 양이에요"
        }
        else if carbon < 18.0 {
            return "약 하루 동안 산소로 바꿀 수 있는 양이에요"
        }
        return String(Int(carbon/18.0)) + "일 동안 산소로 바꿀 수 있는 양이에요"
    }
    
    // 하루에 나무가 18g의 탄소를 흡수함 1일
    // 30년 소나무 1년에 6.6kg의 탄소를 흡수함
    func reducedCarbonToTreeForStat(carbon: Double) -> String {
        if carbon <= 12.0 {
            return "0일"
        } else if carbon < 18.0 {
            return "약 1일"
        }
        return String(Int(carbon/18.0)) + "일"
    }

    // 1km 걸으면 김 13.7kg 재배함
    // 탄소배출량 134g ->  김 13.7kg 필요
    // 김 1kg당 탄소 흡수량 -> 1.37kg
    // 해초 1kg당 탄소 흡수량 -> 961g
    // 961g -> 1kg
    func reducedCarbonToSeaweed(carbon: Double) -> String {
        return (carbon/961 * 1.0).formatterWithSeparator + "kg"
    }
}

