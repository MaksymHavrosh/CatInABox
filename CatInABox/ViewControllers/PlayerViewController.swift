//
//  PlayerViewController.swift
//  CatInABox
//
//  Created by MG on 17.05.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import AVKit
import WebKit
import SwiftyDropbox;

class PlayerViewController: UIViewController {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction private func sendByEmail(_ sender: UIButton) {
    }
    
    var filename: String?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        nameLabel.text = filename
        
        guard let filename = (filename), let client = DropboxClientsManager.authorizedClient else { return }
        
        client.files.getTemporaryLink(path: "\(filename)").response { (response, error) in
            if let response = response, let url = URL(string: response.link) {
                let player = AVPlayer(url: url)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                
                self.present(playerViewController, animated: true) {
                    self.activityIndicator.stopAnimating()
                    player.play()
                }
            } else if let error = error {
                print("Error downloading video from Dropbox \(error)")
            }
        }
    }
    
}
