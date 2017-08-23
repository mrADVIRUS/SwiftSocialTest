//
//  SignInVC.swift
//  SocialTest
//
//  Created by Sergiy Lyahovchuk on 17.07.17.
//  Copyright © 2017 HardCode. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var tfEmail: FancyField!
    @IBOutlet weak var tfPsw: FancyField!
    
    //MARK: - Lifecycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    //MARK: - IBActions
    
    @IBAction func onBtnFacebookPressed(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("JESS: Unable to authentificate with FB - \(String(describing: error))")
            } else if result?.isCancelled == true {
                print("JESS: User canceled Facebook authentification")
            } else {
                print("JESS: Sucessfully auth with FaceBook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    @IBAction func onBtnSignInPressed(_ sender: Any) {
        if let email = tfEmail.text, let pwd = tfPsw.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("JESS: Email User auth with Firebase")
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("JESS: Unable to auth with Firebase using email")
                        } else {
                            print("JESS: Successfully auth with Firebase")
                        }
                    })
                }
            })
        }
    }

    //MARK: - Private
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("JESS: Unable to authenticate with Firebase - \(String(describing: error))")
            } else {
                print("JESS: Sucessfully authenticate with Firebase")
            }
        }
    }

    }

