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
        reducedCarbonLabel.text = info.reducedCarbon
        reducedCarbonLabel.font = .rounded(ofSize: 28, weight: .semibold)
        reducedCarbonLabel.textColor = UIColor(named: "Primary")
        walkingDistanceLabel.text = info.walkingDistance
        walkingDistanceLabel.font = .rounded(ofSize: 18, weight: .regular)
        walkingTime.text = info.walkingTime
        walkingTime.font = .rounded(ofSize: 18, weight: .medium)
        baseDate.text = info.baseDate
        baseDate.font = .rounded(ofSize: 14, weight: .regular)
    }

}
