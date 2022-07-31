//
//  CircilarProgressBarView.swift
//  Bingha
//
//  Created by Terry Koo on 2022/07/20.
//

import UIKit

class CircularProgressBarView: UIView {
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func createCircularPath(distance: Double) {
        let endPoint: CGFloat
        switch distance {
        case 0 :
            endPoint = CGFloat(-Double.pi / 2)
            break
            case 0..<2:
            print("[레벨1]")
            endPoint = CGFloat(-Double.pi / 2 + 2 * Double.pi * distance / 2)
            case 2..<8:
            print("[레벨2]")
            endPoint = CGFloat(-Double.pi / 2 + 2 * Double.pi * distance / 8)
            case 8..<32:
            print("[레벨3]")
            endPoint = CGFloat(-Double.pi / 2 + 2 * Double.pi * distance / 32)
            case 32..<64:
            print("[레벨4]")
            endPoint = CGFloat(-Double.pi / 2 + 2 * Double.pi * distance / 64)
            default:
            print("[레벨 MAX]")
            endPoint = CGFloat(3 * Double.pi / 2)
        }
        
        let outterCircularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 35, startAngle: startPoint, endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)
        let innerCircularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 35, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        circleLayer.path = outterCircularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 11.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.systemGray6.cgColor
        layer.addSublayer(circleLayer)
        progressLayer.path = innerCircularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 8.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor(named: "Primary")?.cgColor
        layer.addSublayer(progressLayer)
    }
    
    func progressAnimation(duration: TimeInterval) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
