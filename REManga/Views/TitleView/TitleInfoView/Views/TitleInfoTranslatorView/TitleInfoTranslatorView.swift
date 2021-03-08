//
//  TitleInfoTranslatorView.swift
//  REManga
//
//  Created by Daniil Vinogradov on 04.03.2021.
//

import UIKit

class TitleInfoTranslatorView: UIView {
    @IBOutlet var root: UIView!
    
    @IBOutlet var name: UILabel!
    @IBOutlet var details: UILabel!
    @IBOutlet var image: UIImageView!
    
    init(model: ReTitlePublisher) {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 0))
        cummonInit()
        
        name.text = model.name
        details.text = model.tagline
        image.kf.setImage(with: URL(string: ReClient.baseUrl + model.img.text))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cummonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        cummonInit()
    }
    
    func cummonInit() {
        Bundle.main.loadNibNamed("TitleInfoTranslatorView", owner: self, options: nil)
        addSubview(root)
        root.fitToParent()
        root.translatesAutoresizingMaskIntoConstraints = true
    }
}
