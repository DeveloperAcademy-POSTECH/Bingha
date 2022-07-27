//
//  StatisticsCollectionViewCell.swift
//  Bingha
//
//  Created by Terry Koo on 2022/07/27.
//

import UIKit

class StatisticsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var reducedCarbonLabel: UILabel!
    @IBOutlet weak var walkingDistance: UILabel!
    @IBOutlet weak var walkingTime: UILabel!
    @IBOutlet weak var baseDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCardViewCorderRadius() {
        cardView.layer.cornerRadius = 20
        cardView.backgroundColor = UIColor.red
    }
    
    func update(info: Statistics) {
        setCardViewCorderRadius()
        reducedCarbonLabel.text = info.reducedCarbon
        walkingDistance.text = info.walkingDistance
        walkingTime.text = info.walkingTime
        baseDate.text = info.baseDate
    }

}
