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
        if DropboxClientsManager.authorizedClient != nil {
            let nav = UINavigationController(rootViewController: FilesTableViewController())
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false)
        }
    }

}

