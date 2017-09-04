 //
//  FeedVC.swift
//  SocialTest
//
//  Created by Sergiy Lyahovchuk on 23.08.17.
//  Copyright © 2017 HardCode. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    var posts: [Post] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? [String: AnyObject] {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                } 
            }
            self.tableView.reloadData()
        })
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onBtnSignOutPressed(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("JESS: TokenID removed from keychain - \(keychainResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "FeedVCToSignInSegue", sender: nil)
    }
}

 extension FeedVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        print("Caption: \(post.caption)")

        return tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostCell
    }
    
 }
