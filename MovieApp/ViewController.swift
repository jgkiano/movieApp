//
//  ViewController.swift
//  MovieApp
//
//  Created by Julius Kiano on 3/10/17.
//  Copyright © 2017 Julius Kiano. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var isLoggedIn :Bool = false
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        button.publishPermissions = ["publish_actions"]
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if((FBSDKAccessToken.current()) != nil){
            isLoggedIn = true
        }else {
            view.addSubview(loginButton)
            loginButton.center = view.center
            loginButton.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (isLoggedIn) {
            performSegue(withIdentifier: "movieListView", sender: nil)
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        performSegue(withIdentifier: "movieListView", sender: nil)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

}

