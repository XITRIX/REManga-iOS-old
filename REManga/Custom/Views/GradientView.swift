//
//  GradientView.swift
//  REManga
//
//  Created by Daniil Vinogradov on 22.02.2021.
//

import UIKit

class GradientView: UIView {
    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    override func awakeFromNib() {
            super.awakeFromNib()

            guard let gradientLayer = self.layer as? CAGradientLayer else { return }
            gradientLayer.colors = [
                UIColor.clear.cgColor,
                UIColor.systemBackground.cgColor
            ]
        }
}
