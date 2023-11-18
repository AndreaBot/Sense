//
//  CustomUIButton.swift
//  Sense
//
//  Created by Andrea Bottino on 18/11/2023.
//

import UIKit

class CustomUIButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        frame = CGRect(x: 0, y: 5, width: 30, height: 30)
        setImage(UIImage(systemName: "eye.slash"), for: .normal)
        tintColor = .black
    }
}
