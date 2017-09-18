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
    @IBOutlet weak var ivLike: UIImageView!
    
    var post:  Post!
    var likesRef: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeHeartTapped))
        tap.numberOfTapsRequired = 1
        ivLike.addGestureRecognizer(tap)
        ivLike.isUserInteractionEnabled = true
    }

    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.tvCaption.text = post.caption
        self.lblLikes.text = "\(post.likes)"
        self.lblUserName.text = "@_testUser"
        
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
        
        likesRef.observeSingleEvent(of: .value, with: { snapshot in
            if let _ = snapshot.value as? NSNull {
                self.ivLike.image = UIImage(named: "empty-heart")
            } else {
                self.ivLike.image = UIImage(named: "filled-heart")
            }
        })
        
        
    }
    
    func likeHeartTapped(sender: UITapGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value, with: { snapshot in
            if let _ = snapshot.value as? NSNull {
                self.ivLike.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                self.ivLike.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
    }


}
