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
        skipToMainVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
    }
    
    private func setAttribute() {
        backgroundCircle.layer.cornerRadius = backgroundCircle.frame.width / 2
        backgroundCircle.layer.masksToBounds = true
        
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
    }
    
    private func skipToMainVC() {
        // 유저디폴트에 저장하기.
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isFirst") != nil {
            defaults.set(false, forKey:"isFirst")
        }
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
}
