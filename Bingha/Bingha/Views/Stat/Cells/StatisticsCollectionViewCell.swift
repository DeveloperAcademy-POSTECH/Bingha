//
//  StatisticsCollectionViewCell.swift
//  Bingha
//
//  Created by Terry Koo on 2022/07/27.
//

import UIKit

class StatisticsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var reducedCarbonLabel: UILabel!
    @IBOutlet weak var walkingDistanceLabel: UILabel!
    @IBOutlet weak var walkingTime: UILabel!
    @IBOutlet weak var baseDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCardViewCorderRadius() {
        cardView.layer.cornerRadius = 14
    }
    
    func update(info: Statistics) {
        setCardViewCorderRadius()
        titleLabel.font = .rounded(ofSize: 14, weight: .medium)
        reducedCarbonLabel.text = info.reducedCarbon.reducedCarbonToString()
        reducedCarbonLabel.font = .rounded(ofSize: 28, weight: .semibold)
        reducedCarbonLabel.textColor = UIColor(named: "Primary")
        walkingDistanceLabel.text = info.walkingDistance.walkingDistanceToString()
        walkingDistanceLabel.font = .rounded(ofSize: 18, weight: .regular)
        walkingTime.text = info.walkingTime.walkingTimeToString()
        walkingTime.font = .rounded(ofSize: 18, weight: .medium)
        baseDate.text = info.baseDate
        baseDate.font = .rounded(ofSize: 14, weight: .regular)
    }

}

extension Double {
    // 탄소 저감량 스트링으로 변환. 라벨에 매핑을 위해
    func reducedCarbonToString() -> String {
        return String(format: "%.1", self) + "g"
    }
    // 이동 거리 스트링으로 변환. 라벨에 매핑을 위해
    func walkingDistanceToString() -> String {
        return String(format: "%.1", self) + "km"
    }
}
extension Int {
    // 이동 시간 초 -> 분으로 변환. 라벨 매핑을 위해.
    func walkingTimeToString() -> String {
        let minutes = Double(self) / Double(60)
        return String(format: "%.1", minutes) + "분"
    }
}
