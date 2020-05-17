//
//  TextViewController.swift
//  CatInABox
//
//  Created by MG on 17.05.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import WebKit
import SwiftyDropbox
import PDFKit

class TextViewController: UIViewController {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var pdfView: PDFView!
    
    @IBAction func sendByEmail(_ sender: UIButton) {
    }
    
    var filename: String?
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = filename
        
        if let filename = self.filename, let client = DropboxClientsManager.authorizedClient {
            
            let destination : (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
                let fileManager = FileManager.default
                let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                
                let UUID = Foundation.UUID().uuidString
                let pathComponent = "\(UUID)-\(String(describing: response.suggestedFilename))"
                return directoryURL.appendingPathComponent(pathComponent)
            }
            
            client.files.getPreview(path: "/\(filename)", destination: destination).response { (response, error) in
                if let (_, url) = response {
                    
                    let pdfDoc = PDFDocument(url: url)
                    
                    self.pdfView.displayMode = .singlePageContinuous
                    self.pdfView.autoScales = true
                    self.pdfView.displayDirection = .vertical
                    self.pdfView.document = pdfDoc
                    
                } else if let error = error {
                    print("Error downloading text from Dropbox \(error)")
                }
            }
        }
        
    }

}
