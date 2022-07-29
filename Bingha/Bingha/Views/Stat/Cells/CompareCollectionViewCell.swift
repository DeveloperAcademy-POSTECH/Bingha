//
//  CompareCollectionViewCell.swift
//  Bingha
//
//  Created by HanGyeongjun on 2022/07/28.
//

import UIKit

class CompareCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionViewCell: UIView!
    @IBOutlet weak var imageFrame: UIView!
    @IBOutlet weak var compareImageView: UIImageView!
    @IBOutlet weak var compareAmountLabel: UILabel!
    @IBOutlet weak var compareDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCorderRadius() {
        imageFrame.layer.cornerRadius = 6
        layer.cornerRadius = 14
    }
    
    func update(info: Compare) {
        setCorderRadius()
//        compareImageView.image = info.compareImage
        compareAmountLabel.text = info.compareAmount
        compareDescriptionLabel.text = info.compareDescription
    }
}
