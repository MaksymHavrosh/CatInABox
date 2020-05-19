//
//  PhotoViewController.swift
//  CatInABox
//
//  Created by MG on 14.05.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SwiftyDropbox

class PhotoViewController: MailViewController {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    var filename: String?
    var url: URL?
    
    @IBAction private func sendByEmail(_ sender: UIButton) {
        guard let filename = filename, let url = url else { return }
        showMailVC(filename: filename, url: url)
    }
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = false
        nameLabel.text = filename
        
        getImage()
    } 
}

//MARK: - Private

private extension PhotoViewController {
    
    func getImage() {
        guard let filename = self.filename, let client = DropboxClientsManager.authorizedClient else { return }
        client.files.getTemporaryLink(path: "\(filename)").response { response, error in
            
            if let response = response, let url = URL(string: response.link), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                self.url = url
                self.imageView.image = image
                self.activityIndicator.isHidden = true
                
            } else if let error = error {
                print("Error downloading image from Dropbox: \(error)")
            }
        }
    }
}

