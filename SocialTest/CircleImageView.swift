//
//  CircleImageView.swift
//  SocialTest
//
//  Created by Sergiy Lyahovchuk on 22.08.17.
//  Copyright © 2017 HardCode. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {

    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

}
