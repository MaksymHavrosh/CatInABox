//
//  SceneDelegate.swift
//  CatInABox
//
//  Created by MG on 14.05.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SwiftyDropbox

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        
        if let authResult = DropboxClientsManager.handleRedirectURL(url) {
            switch authResult {
            case .success:
                print("Success! User is logged into Dropbox.")
            case .cancel:
                print("Authorization flow was manually canceled by user!")
            case .error(_, let description):
                print("Error: \(description)")
            }
        }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        if DropboxClientsManager.authorizedClient != nil {
            guard let mainVC = window?.rootViewController else { return }
            let nav = UINavigationController(rootViewController: FilesTableViewController())
            nav.modalPresentationStyle = .fullScreen
            mainVC.present(nav, animated: false)
        }
    }

}

