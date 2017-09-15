//
//  PostCell.swift
//  SocialTest
//
//  Created by Sergiy Lyahovchuk on 24.08.17.
//  Copyright © 2017 HardCode. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var ivProfile: CircleImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var ivPost: UIImageView!
    @IBOutlet weak var tvCaption: UITextView!
    
    var post:  Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        self.tvCaption.text = post.caption
        self.lblLikes.text = "\(post.likes)"
        self.lblUserName.text = "TEST_USER"
        
        if image != nil {
            self.ivPost.image = image
        } else {
            let ref = Storage.storage().reference(forURL: post.imagesUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("JESS: Unable to download image from Firebase storage")
                } else {
                    print("JESS: Image downloaded from Firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.ivPost.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imagesUrl as NSString)
                        }
                    }
                }
            })
            
        }
    }


}
