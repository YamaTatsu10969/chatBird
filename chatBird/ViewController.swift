//
//  ViewController.swift
//  chatBird
//
//  Created by 山本竜也 on 2019/2/28.
//  Copyright © 2019 山本竜也. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController,GIDSignInUIDelegate {

    @IBOutlet weak var signInButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        
    }
    @IBAction func didTouchedSignInButton(_ sender: Any) {
        transitionToChatroom()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("😈😈😈😈😈error signIn")
            return
        }
        print("😈😈😈😈😈error signIn")

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("😈😈😈😈😈error credential")
                return
            }
            print("🌞🌞🌞🌞🌞🌞成功！！！")
            self.transitionToChatroom()
            
        }
        // ...
    }
    //ListViewControllerへの遷移
    @IBAction func didTouchedButton(_ sender: Any) {
        transitionToChatroom()
    }
    func transitionToChatroom() {
        let storyboard = UIStoryboard(name: "chatRoom", bundle: nil)
        print("😈😈😈😈😈😈😈😈😈😈😈😈")
        // storyboardファイル名称が  "Main"
        let viewcontroller = storyboard.instantiateViewController(withIdentifier: "chatroom")
        // 上記指定したstoryboardの中のVCを指定（storyboardIDでwithIdentifierを指定）
        self.present(viewcontroller, animated: true, completion: nil)
    }


}

