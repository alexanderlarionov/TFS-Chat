//
//  Animations.swift
//  TFS Chat
//
//  Created by dmitry on 24.11.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import Foundation
import UIKit

class Animations {
    
    static func shake(view: UIView) {
        let positionX = CABasicAnimation(keyPath: "position")
        positionX.fromValue = CGPoint(x: view.center.x + 5, y: view.center.y)
        positionX.toValue = CGPoint(x: view.center.x - 5, y: view.center.y)
        
        let positionY = CABasicAnimation(keyPath: "position")
        positionY.fromValue = CGPoint(x: view.center.x, y: view.center.y + 5)
        positionY.toValue = CGPoint(x: view.center.x, y: view.center.y - 5)
        positionY.beginTime = 0.1
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = -Double.pi / 10
        rotation.toValue = Double.pi / 10
        positionY.beginTime = 0.2
        
        let group = CAAnimationGroup()
        group.duration = 0.3
        group.repeatCount = .infinity
        group.autoreverses = true
        group.animations = [positionX, positionY, rotation]
        
        view.layer.add(group, forKey: "shake")
    }
    
    static func stopShaking(view: UIView) {
        view.layer.removeAllAnimations()
        view.subviews.forEach({ $0.layer.removeAllAnimations() })
    }
}

extension UIViewController {
    
    private func tinkoffCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "tinkoff")?.cgImage
        cell.scale = 0.5
        cell.scaleRange = 0.5
        cell.emissionRange = .pi
        cell.lifetime = 3.0
        cell.birthRate = 3
        cell.velocity = 30
        return cell
    }
    
    func showTinkoffAnimation(at position: CGPoint, layer: CAEmitterLayer) {
        let cell = tinkoffCell()
        layer.lifetime = 1.0
        layer.emitterPosition = position
        layer.emitterShape = CAEmitterLayerEmitterShape.point
        layer.beginTime = CACurrentMediaTime()
        layer.emitterCells = [cell]
        view.layer.addSublayer(layer)
    }
    
    func stopTinkoffAnimation(layer: CAEmitterLayer) {
        layer.lifetime = 0
    }
}
