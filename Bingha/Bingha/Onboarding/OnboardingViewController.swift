//
//  OnboardingViewController.swift
//  Bingha
//
//  Created by Terry Koo on 2022/07/28.
//

import UIKit

class OnboardingViewController: UIViewController {
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    let pages: [OnboardingDataModel] = [
        OnboardingDataModel(image: #imageLiteral(resourceName: "OnBoardingFourth"), title: "걸어서 지구를 살린다고?", description: "차를 타는 대신 걷는 것 만으로도\n탄소배출을 줄여\n지구의 수명을 늘릴 수 있어요."),
        OnboardingDataModel(image: #imageLiteral(resourceName: "OnBoardingSecond"), title: "매년 녹고 있는 빙하", description: "남은 지구의 온도는 단 1.5도!\n지구 온난화로 인해\n매년 한국 크기만한 빙하가 녹고 있어요."),
        OnboardingDataModel(image: #imageLiteral(resourceName: "OnBoardingFirst"), title: "탄소 배출 줄이기 함께해요", description: "차로 출퇴근하는 직장인이 배출하는 탄소는\n하루 평균 7.2kg.\n이는 한 그루의 소나무가\n하루 동안 산소로 바꿀 수 있는 양이에요."),
        OnboardingDataModel(image: #imageLiteral(resourceName: "OnBoardingThird"), title: "시작해볼까요", description: "당신의 선택으로 지구를 살릴 수 있어요.\n오늘은 차 대신 걸어보는 건 어떨까요?")
    ]
    var currentPage = 0 {
        didSet {
            pageController.currentPage = currentPage
            if currentPage != 3 {
                confirmButton.isHidden = true
                skipButton.isHidden = false
            }
            else {
                confirmButton.isHidden = false
                skipButton.isHidden = true
            }
        }
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        skipToAccessVC()
    }
    @IBAction func confirmButtonTapped(_ sender: Any) {
        skipToAccessVC()
    }
}
// MARK: - View Life Cycle

extension OnboardingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
    }
}

//MARK: - Functions
extension OnboardingViewController {
    private func skipToAccessVC() {
        let storyboard = UIStoryboard(name: "RequestAccessView", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RequestAccessView") as! RequestAccessViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    private func setAttribute() {
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        confirmButton.isHidden = true
    }
}

//MARK: - CollectionView Delegate and Datasource
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath)
        as! OnboardingCollectionViewCell
        cell.setup(pages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    //페이지 컨트롤러 변환
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageController.currentPage = currentPage
    }
}
