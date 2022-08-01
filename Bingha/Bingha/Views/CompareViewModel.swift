//
//  CompareViewModel.swift
//  Bingha
//
//  Created by HanGyeongjun on 2022/07/28.
//

import Foundation

class CompareViewModel {
    public static var compareList: [Compare] = [Compare(compareImage: "PineTree", compareAmount: "0", compareDescription: "소나무 한 그루가\n이 정도의 탄소를\n산소로 바꾸는 데 걸리는 시간"), Compare(compareImage: "Earth", compareAmount: "1", compareDescription: "이만큼의 김이\n흡수한 탄소의 양"), Compare(compareImage: "Oil", compareAmount: "2", compareDescription: "당신의 지킨 빙하의 양")]
//    init(distance: Double){
//        compareList.append(Compare(compareImage: "PineTree", compareAmount: ReducedCarbonCalculator.shared.reducedCarbonToTreeForStat(km: distance), compareDescription: "소나무 한 그루가\n이 정도의 탄소를\n산소로 바꾸는 데 걸리는 시간"))
//        compareList.append(Compare(compareImage: "Earth", compareAmount: ReducedCarbonCalculator.shared.reducedCarbonToSeaweed(km: distance), compareDescription: "이만큼의 김이\n흡수한 탄소의 양"))
//        compareList.append(Compare(compareImage: "Oil", compareAmount: ReducedCarbonCalculator.shared.protectedGlacier(km: distance), compareDescription: "당신의 지킨 빙하의 양"))
//    }
//
    
    
    var countOfCompareList: Int {
        return CompareViewModel.compareList.count
    }
    
    func CompareModelInfo(at index: Int) -> Compare {
        return CompareViewModel.compareList[index]
    }
}
