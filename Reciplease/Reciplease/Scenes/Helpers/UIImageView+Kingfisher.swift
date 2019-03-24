//
//  UIImageView+Kingfisher.swift
//  Reciplease
//
//  Created by Christophe Bugnon on 24/03/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Kingfisher
import UIKit

extension UIImageView {
    func setImage(withUrl urlString: String, placeholder: UIImage? = #imageLiteral(resourceName: "placeholder"), options: [KingfisherOptionsInfoItem]? = nil) {
        guard let url = URL(string: urlString) else {
            return
        }

        var kingfisherOptions: [KingfisherOptionsInfoItem] = [.transition(ImageTransition.fade(0.2)), .cacheOriginalImage]
        if let options = options {
            kingfisherOptions += options
        }

        kf.setImage(with: url, placeholder: placeholder, options: kingfisherOptions, progressBlock: nil) { result in
            switch result {
            case let .success(imageResult):
                self.contentMode = .scaleAspectFill
                self.image = imageResult.image
            default: break
            }
        }
    }
}
