//
//  PhotoViewController.swift
//  CatInABox
//
//  Created by MG on 14.05.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SwiftyDropbox
import MessageUI

class PhotoViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    var filename: String?
    
    @IBAction private func sendByEmail(_ sender: UIButton) {
    }
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = false
        nameLabel.text = filename
        
        if let filename = self.filename, let client = DropboxClientsManager.authorizedClient {
            
            let destination : (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
                let fileManager = FileManager.default
                let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                
                let UUID = Foundation.UUID().uuidString
                let pathComponent = "\(UUID)-\(String(describing: response.suggestedFilename))"
                return directoryURL.appendingPathComponent(pathComponent)
            }
            
            client.files.getThumbnail(path: "/\(filename)", format: .png, size: .w1024h768, destination: destination).response { response, error in
                if let (_, url) = response, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    
                    self.imageView.image = image
                    self.activityIndicator.isHidden = true
                    
                } else if let error = error {
                    print("Error downloading file from Dropbox: \(error)")
                }
            }
        }
    }
    
}

