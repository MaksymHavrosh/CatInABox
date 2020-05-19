//
//  PlayerViewController.swift
//  CatInABox
//
//  Created by MG on 17.05.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import AVKit
import SwiftyDropbox;

class PlayerViewController: MailViewController {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction private func sendByEmail(_ sender: UIButton) {
        guard let filename = filename, let url = url else { return }
        showMailVC(filename: filename, url: url)
    }
    
    var filename: String?
    var url: URL?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        nameLabel.text = filename
        
        getMedia()
    } 
}

//MARK: - Private

private extension PlayerViewController {
    
    func getMedia() {
        guard let filename = (filename), let client = DropboxClientsManager.authorizedClient else { return }
        
        client.files.getTemporaryLink(path: "\(filename)").response { (response, error) in
            if let response = response, let url = URL(string: response.link) {
                
                self.url = url
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
