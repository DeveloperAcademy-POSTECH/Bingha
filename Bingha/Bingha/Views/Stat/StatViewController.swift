//
//  StatViewController.swift
//  Bingha
//
//  Created by Terry Koo on 2022/07/27.
//

import UIKit

class StatViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let compareViewModel: CompareViewModel = CompareViewModel()
    let statisticsViewModel: StatisticsViewModel = StatisticsViewModel()
    let compareID: String = "CompareCollectionViewCell"
    let statisticsID: String = "StatisticsCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "StatisticsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: statisticsID)
        collectionView.register(UINib(nibName: "CompareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: compareID)

    }
}

extension StatViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //컬랙션뷰 개수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    //컬랙션뷰 섹션당 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            //세그먼트 컨트롤 섹션
        case 0: return 1
            //해당 기간 탄소 절감량 섹션
        case 1: return 1
            //비교 섹션
        case 2: return compareViewModel.countOfCompareList
            //걷기 모음 섹션
        case 3: return statisticsViewModel.countOfStatisticsList
        default:
            return 0
        }
    }
    
    //컬랙션뷰 섹션별로 셀 가져와서 업데이트
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: compareID, for: indexPath) as! CompareCollectionViewCell
            let compareInfo = compareViewModel.CompareModelInfo(at: indexPath.item)
            cell.update(info: compareInfo)
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: statisticsID, for: indexPath) as! StatisticsCollectionViewCell
            let statisticInfo = statisticsViewModel.statisticsInfo(at: indexPath.item)
            cell.update(info: statisticInfo)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: statisticsID, for: indexPath) as! StatisticsCollectionViewCell
            let statisticInfo = statisticsViewModel.statisticsInfo(at: indexPath.item)
            cell.update(info: statisticInfo)
            return cell
        }
    }
    
    //컬랙션뷰 간 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 || section == 2 {
            return CGSize(width: collectionView.bounds.width, height: 50)
        }
        return CGSize()
    }
    
    //컬랙션뷰 셀 사이 거리
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 10
        let width: CGFloat = (collectionView.bounds.width - itemSpacing) / 2.2
        return CGSize(width: width, height: width)
    }
    
    //컬랙션뷰 내부 인셋
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
    }
}


