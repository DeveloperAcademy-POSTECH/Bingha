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
        //내부 이미지 창 레디우스
        imageFrame.layer.cornerRadius = 6
        //셀 전체 레디우스
        layer.cornerRadius = 14
    }
    
    func update(info: Compare) {
        setCorderRadius()
        //string 형태 이미지명 갖고와서 변환해주기
        let compareImage = UIImage(named: info.compareImage)!
        compareImageView.image = compareImage
        compareAmountLabel.text = info.compareAmount
        compareAmountLabel.font = .rounded(ofSize: 20, weight: .semibold)
        compareDescriptionLabel.text = info.compareDescription
    }
}
