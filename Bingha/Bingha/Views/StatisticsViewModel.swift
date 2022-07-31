//
//  StatisticsViewModel.swift
//  Bingha
//
//  Created by Terry Koo on 2022/07/27.
//

import Foundation

class StatisticsViewModel {
    public static var statisticsList: [Statistics] = [
//        Statistics(reducedCarbon: "10kg", walkingDistance: "5km", walkingTime: "1시간", baseDate: "오늘"),
//        Statistics(reducedCarbon: "20kg", walkingDistance: "7km", walkingTime: "2시간", baseDate: "오늘"),
//        Statistics(reducedCarbon: "30kg", walkingDistance: "44km", walkingTime: "1시간", baseDate: "오늘"),
//        Statistics(reducedCarbon: "40kg", walkingDistance: "2km", walkingTime: "5시간", baseDate: "오늘"),
    ]
    
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
