//
//  ReducedCarbonCollectionViewModel.swift
//  Bingha
//
//  Created by HanGyeongjun on 2022/07/31.
//

import Foundation

class ReducedCarbonCollectionViewModel {
    public static var reducedCarbonList: [ReducedCarbonCollection] = [
        ReducedCarbonCollection(reducedCarbonPeriod: "오늘 총 탄소배출 저감량", reducedCarbonAmount: 0.0)
    ]
    
    var countOfReducedCarbonList: Int {
        return ReducedCarbonCollectionViewModel.reducedCarbonList.count
    }
    
    func ReducedCarbonModelInfo(at index: Int) -> ReducedCarbonCollection {
        return ReducedCarbonCollectionViewModel.reducedCarbonList[index]
    }
}
