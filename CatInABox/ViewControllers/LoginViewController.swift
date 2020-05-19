//
//  LoginViewController.swift
//  CatInABox
//
//  Created by MG on 14.05.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SwiftyDropbox

class LoginViewController: UIViewController {
    
    @IBAction func loginButton(_ sender: UIButton) {
        DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: self) { (url: URL) -> Void in
            UIApplication.shared.open(url)
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
        if DropboxClientsManager.authorizedClient != nil {
            dismiss(animated: true, completion: nil)
        }
    }

}

