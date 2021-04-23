//
//  BaseUIView.swift
//  CreateBackgoundIphone
//
//  Created by Nguyễn Trung on 4/20/21.
//  Copyright © 2021 Nguyễn Trung. All rights reserved.
//

import Foundation
import UIKit

class BaseUIView: UIView {
    
    var containerView: UIView?
    
    var isFirst = true
    
    @IBOutlet weak var rotateView: UIView!
    @IBOutlet weak var panView: UIView!
    @IBOutlet weak var scaleHView: UIView!
    @IBOutlet weak var scaleVView: UIView!
    @IBOutlet weak var scaleView: UIView!
    
    var xPan: CGFloat = 0
    var yPan: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setPan()
        
    }
    
    private func setPan() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
        
        let rotatePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanRotate(_:)))
        
        self.rotateView.addGestureRecognizer(rotatePanGestureRecognizer)
        
        let scaleHGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanScaleH(_:)))
        self.scaleHView.addGestureRecognizer(scaleHGestureRecognizer)
        
        let scaleVGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanScaleV(_:)))
        self.scaleVView.addGestureRecognizer(scaleVGestureRecognizer)
        
        let scaleGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanScale(_:)))
        self.scaleView.addGestureRecognizer(scaleGestureRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @objc private func handlePanScaleH(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        let newHeight = self.bounds.size.height - translation.y
        
        if newHeight < 100 {
            return
        }
        
        if newHeight > self.containerView?.frame.size.height ?? 0 {
            return
        }
        gesture.setTranslation(.zero, in: self)
        
        self.bounds.size = CGSize(width: self.bounds.size.width, height: newHeight)
        
    }
    
    @objc private func handlePanScaleV(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        let newWidth = self.bounds.size.width + translation.x
        
        if newWidth < 100 {
            return
        }
        
        if newWidth > self.containerView?.frame.size.width ?? 0 {
            return
        }
        
        gesture.setTranslation(.zero, in: self)
        
        self.bounds.size = CGSize(width: newWidth, height: self.bounds.size.height)
        
    }
    
    @objc private func handlePanScale(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        let newHeight = self.bounds.size.height + translation.y
        
        if newHeight < 100 {
            return
        }
        
        if newHeight > self.containerView?.frame.size.height ?? 0 {
            return
        }
        
        
        let newWidth = self.bounds.size.width + translation.x
        
        if newWidth < 100 {
            return
        }
        
        if newWidth > self.containerView?.frame.size.width ?? 0 {
            return
        }
        
        self.bounds.size = CGSize(width: newWidth, height: newHeight)
        gesture.setTranslation(.zero, in: self)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        let gestureView = self
        
        if xPan == 0 {
            xPan = gestureView.center.x
        }
        if yPan == 0 {
            yPan =  gestureView.center.y
        }
        
        let angle = self.transform.angle
        
        xPan = gestureView.center.x + translation.x * cos(angle) - translation.y * sin(angle)
        yPan = gestureView.center.y + translation.y * cos(angle) + translation.x * sin(angle)
        
        if xPan < 0 {
            print("xPan")
            return
        }
        
        if xPan > containerView?.bounds.width ?? 0 {
            print("xPan2")
            return
        }
        
        if yPan < 0 {
            print("yPan")
            return
        }
        
        if yPan > containerView?.bounds.height ?? 0 {
            print("yPan2")
            return
        }
        
        gestureView.center = CGPoint(
            x: xPan,
            y: yPan
        )
        
        gesture.setTranslation(.zero, in: self)
        
        guard gesture.state == .ended else {
            xPan = 0
            yPan = 0
            return
        }
    }
    
    private var origin: CGPoint = CGPoint(x: 0, y: 0)
    
    @objc private func handlePanRotate(_ gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            origin = gesture.location(in: self)
            break
        case .changed:
            let screenCenter = self.center
            let firstTouch = self.origin
            let point = gesture.location(in: self)
            
            let radian = CGPointAngleATan2(mp: screenCenter,sp: firstTouch,p: point)
            
            self.transform = self.transform.rotated(by: CGFloat(radian))
            print(self.transform.angleInDegrees)
            
            break
        case .ended:
            break
        default: break
        }
    }
    
    private func CGPointAngleATan2(mp: CGPoint, sp: CGPoint, p: CGPoint) -> CGFloat {
        let sAngle = atan2(sp.y - mp.y, sp.x - mp.x)
        let pAngle = atan2(p.y - mp.y, p.x - mp.x)
        return pAngle-sAngle
    }
    
}


extension CGAffineTransform {
    var angle: CGFloat { return atan2(-self.c, self.a) }
    
    var angleInDegrees: CGFloat { return self.angle * 180 / .pi }
    
    var scaleX: CGFloat {
        let angle = self.angle
        return self.a * cos(angle) - self.c * sin(angle)
    }
    
    var scaleY: CGFloat {
        let angle = self.angle
        return self.d * cos(angle) + self.b * sin(angle)
    }
}
