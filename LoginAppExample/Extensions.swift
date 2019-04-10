//
//  UIView.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import UIKit
import Cheetah
import SVProgressHUD

extension UIView {
    
    func shake(withForce force: Double = 0.10, duration: Double = 0.5) {
        if force >= 0 && force <= 1 {
            self.cheetah
                .rotate(-(Double.pi / 2) * force).duration(duration).easeOutElastic
                .rotate((Double.pi / 2) * (force * 2)).duration(duration * 2).easeOutElastic
                .rotate(-(Double.pi / 2) * force).duration(duration).easeOutElastic.run()
        }
    }
    
    func addShadow(offset: Int, color: UIColor, radius: CGFloat, alpha: CGFloat = 1) {
        self.layer.shadowOffset = CGSize(width: 0, height: offset)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = Float(alpha)
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
}

extension UIButton {
    func setup(title: String) {
        self.backgroundColor = UIColor.white
        self.tintColor = UIColor.white
        self.setTitleColor(.blue, for: .normal)
        self.setTitle(title, for: .normal)
    }
}

extension String {
    
    var uppercase: String {
        return NSLocalizedString(self, comment: "").uppercased()
    }
    
    var lowercase: String {
        return NSLocalizedString(self, comment: "").lowercased()
    }
    
    var regular: String {
        return NSLocalizedString(self, comment: "")
    }
}
