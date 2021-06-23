//
//  UIView+gradientBackground.swift
//  WeatherApp
//
//  Created by SERGEY VOROBEV on 18.06.2021.
//

import Foundation
import UIKit

extension UIView {
    func setGradientBackground(from top: UIColor, to bottom: UIColor) {
        let layer = CAGradientLayer()
        layer.colors = [top.cgColor, bottom.cgColor]
        layer.frame = self.bounds
        
        self.layer.insertSublayer(layer, at: 0)
    }
}
