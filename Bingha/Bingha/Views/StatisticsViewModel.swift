//
//  StatisticsViewModel.swift
//  Bingha
//
//  Created by Terry Koo on 2022/07/27.
//

import Foundation

class StatisticsViewModel {
    public static var statisticsList: [Statistics] = []
    public static var todayStatisticsList: [Statistics] = []
    public static var weeklyStatisticsList: [Statistics] = []
    public static var monthlyStatisticsList: [Statistics] = []
    
    var countOfStatisticsList: Int {
        return StatisticsViewModel.statisticsList.count
    }
    
    func statisticsInfo(at index: Int) -> Statistics {
        return StatisticsViewModel.statisticsList[index]
    }
}
