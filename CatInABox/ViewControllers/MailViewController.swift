//
//  MailViewController.swift
//  CatInABox
//
//  Created by MG on 19.05.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import MessageUI

class MailViewController: UIViewController, MFMailComposeViewControllerDelegate {

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

//MARK: - Show vc

extension MailViewController {
    
    func showMailVC(filename: String, url: URL) {
        if MFMailComposeViewController.canSendMail() {
            
            do {
                let data = try Data(contentsOf: url)
                let mailComposer = MFMailComposeViewController()
                mailComposer.mailComposeDelegate = self
                mailComposer.addAttachmentData(data, mimeType: "image/jpeg", fileName: filename)
                
                self.present(mailComposer, animated: true, completion: nil)
                
            } catch {
                print("We have encountered error \(error.localizedDescription)")
            }
            
        } else {
            showEmailAlert()
        }
    }
    
    func showEmailAlert() {
        let alert = UIAlertController(title: "Error", message: NSLocalizedString("Email is not configured in settings app or we are not able to send an email", comment: ""), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            alert.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:])
            }
        }))
        
        show(alert, sender: nil)
    }
    
}

//MARK:- MailcomposerDelegate

extension PhotoViewController {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("User cancelled")
            break
            
        case .saved:
            print("Mail is saved by user")
            break
            
        case .sent:
            print("Mail is sent successfully")
            break
            
        case .failed:
            print("Sending mail is failed")
            break
        default:
            break
        }
        controller.dismiss(animated: true)
    }
}
