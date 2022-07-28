//
//  CompareViewModel.swift
//  Bingha
//
//  Created by HanGyeongjun on 2022/07/28.
//

import Foundation

class CompareViewModel {
    let compareList: [Compare] = [
        Compare(compareImage: "PineTree", compareAmount: "3개월", compareDescription: "소나무 한 그루가 이 정도의 탄소를 산소로 바꾸는 데 걸리는 시간"),
        Compare(compareImage: "Earth", compareAmount: "0.01일", compareDescription: "절감한 탄소로 인해 늘어난 지구의 수명"),
        Compare(compareImage: "Oil", compareAmount: "30ml", compareDescription: "만큼의 석유가 연소하며 배출하는 탄소의 양"),
    ]
    
    var countOfCompareList: Int {
        return compareList.count
    }
    
    func CompareModelInfo(at index: Int) -> Compare {
        return compareList[index]
    }
}
