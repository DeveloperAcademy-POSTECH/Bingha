//
//  CompareCollectionViewCell.swift
//  Bingha
//
//  Created by HanGyeongjun on 2022/07/28.
//

import UIKit

class CompareCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var compareImageView: UIImageView!
    @IBOutlet weak var compareAmountLabel: UILabel!
    @IBOutlet weak var compareDescriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCardViewCorderRadius() {
    }
    
    func update(info: Compare) {
//        compareImageView.image = info.compareImage
        compareAmountLabel.text = info.compareAmount
        compareDescriptionLabel.text = info.compareDescription
    }
}
