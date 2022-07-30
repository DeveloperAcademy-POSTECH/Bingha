//
//  RequestAccessViewController.swift
//  Bingha
//
//  Created by seungyeon oh on 2022/07/31.
//

import UIKit

class RequestAccessViewController: UIViewController {
    
    @IBOutlet weak var backgroundCircle: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBAction func startButtonTapped(_ sender: Any) {
        SkipToMainVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttribute()
    }
    
    private func setAttribute() {
    backgroundCircle.layer.cornerRadius = backgroundCircle.frame.width / 2
    backgroundCircle.layer.masksToBounds = true
    
    startButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
    }
    
    private func SkipToMainVC() {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
}
