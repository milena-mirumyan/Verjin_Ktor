//
//  UIViewExtensions.swift
//  Capstone
//
//  Created by Milena Mirumyan on 10.05.25.
//

import UIKit

extension UIViewController {
    var sceneDelegate: SceneDelegate {
        view.window!.windowScene!.delegate as! SceneDelegate
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func dimissOnTap(view: UIView? = nil) {
        let view = view ?? self.view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delaysTouchesBegan = false
        view?.addGestureRecognizer(tapGesture)
    }
}

extension UIView {
    func addShadow(radius: CGFloat = 8, opacity: Float = 0.4) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }

    func addDashedBorder() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.lineWidth = 2
        
        // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
        shapeLayer.lineDashPattern = [2,3]

        let path = CGMutablePath()
        path.addLines(between: [
            CGPoint(x: 0, y: 0),
            CGPoint(x: self.frame.width, y: 0)
        ])
        
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-16, 16, -12, 12, -8, 8, -4, 4, 0]
        layer.add(animation, forKey: "shake")
    }
}

extension UIImage {
    func imageWith(newSize: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: newSize).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        return image.withRenderingMode(renderingMode)
    }
}

