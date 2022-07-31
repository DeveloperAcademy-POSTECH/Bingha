//
//  ReducedCarbonCollectionViewModel.swift
//  Bingha
//
//  Created by HanGyeongjun on 2022/07/31.
//

import Foundation

class ReducedCarbonCollectionViewModel {
    let ReducedCarbonList: [ReducedCarbonCollection] = [
        ReducedCarbonCollection(ReducedCarbonPeriod: "오늘 총 탄소배출 저감량", ReducedCarbonAmount: "1073g")
    ]
    
    var countOfReducedCarbonList: Int {
        return ReducedCarbonList.count
    }
    
    func ReducedCarbonModelInfo(at index: Int) -> ReducedCarbonCollection {
        return ReducedCarbonList[index]
    }
}
