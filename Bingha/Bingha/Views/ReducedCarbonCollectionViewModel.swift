//
//  ReducedCarbonCollectionViewModel.swift
//  Bingha
//
//  Created by HanGyeongjun on 2022/07/31.
//

import Foundation

class ReducedCarbonCollectionViewModel {
    let reducedCarbonList: [ReducedCarbonCollection] = [
        ReducedCarbonCollection(reducedCarbonPeriod: "오늘 총 탄소배출 저감량", reducedCarbonAmount: "1073g")
    ]
    
    var countOfReducedCarbonList: Int {
        return reducedCarbonList.count
    }
    
    func ReducedCarbonModelInfo(at index: Int) -> ReducedCarbonCollection {
        return reducedCarbonList[index]
    }
}
