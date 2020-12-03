//
//  TinkoffAnimation.swift
//  TFS Chat
//
//  Created by dmitry on 26.11.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showTinkoffAnimation(sender: UILongPressGestureRecognizer, layer: CAEmitterLayer) {
        //TODO how to avoid copypaste for each controller? how to get rid of layer as a param?
        if sender.state == .began {
            let location = sender.location(in: sender.view)
            showTinkoffAnimation(at: location, layer: layer)
        } else if sender.state == .ended {
            stopTinkoffAnimation(layer: layer)
        }
    }
    
    private func tinkoffCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "tinkoff")?.cgImage
        cell.scale = 0.75
        cell.scaleRange = 0.5
        cell.emissionRange = .pi
        cell.lifetime = 3.0
        cell.birthRate = 2
        cell.velocity = 50
        return cell
    }
    
    private func showTinkoffAnimation(at position: CGPoint, layer: CAEmitterLayer) {
        let cell = tinkoffCell()
        layer.lifetime = 1.0
        layer.emitterPosition = position
        layer.emitterShape = CAEmitterLayerEmitterShape.circle
        layer.beginTime = CACurrentMediaTime()
        layer.emitterCells = [cell]
        view.layer.addSublayer(layer)
    }
    
    private func stopTinkoffAnimation(layer: CAEmitterLayer) {
        layer.lifetime = 0
    }
    
}
