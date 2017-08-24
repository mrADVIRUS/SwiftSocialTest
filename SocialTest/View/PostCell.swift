//
//  PostCell.swift
//  SocialTest
//
//  Created by Sergiy Lyahovchuk on 24.08.17.
//  Copyright © 2017 HardCode. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var ivProfile: CircleImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var ivPost: UIImageView!
    @IBOutlet weak var tvCaption: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
