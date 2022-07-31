//
//  ReducedCarbonCollectionView.swift
//  Bingha
//
//  Created by HanGyeongjun on 2022/07/31.
//

import UIKit

class ReducedCarbonCollectionView: UICollectionViewCell {
    
    @IBOutlet weak var ReducedCarbonPeriodLabel: UILabel!
    @IBOutlet weak var ReducedCarbonAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func roundedFont() {
        ReducedCarbonAmountLabel.font = .rounded(ofSize: 36, weight: .semibold)
    }
    
    func update(info: ReducedCarbonCollection) {
        roundedFont()
        ReducedCarbonAmountLabel.text = info.reducedCarbonAmount
        ReducedCarbonPeriodLabel.text = info.reducedCarbonPeriod
    }
}

