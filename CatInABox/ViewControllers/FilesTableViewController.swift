//
//  FilesTableViewController.swift
//  CatInABox
//
//  Created by MG on 14.05.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SwiftyDropbox

class FilesTableViewController: UITableViewController {
    
    private var entries: [Files.Metadata]?
    private var selectedEntry: Files.Metadata?
    private var path: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = DropboxClientsManager.authorizedClient
        client?.files.listFolder(path: path ?? "").response { (response, error) in
            guard let result = response else { return }
            self.entries = result.entries
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entries?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self), for: indexPath) as! TableViewCell
        
        guard let entry = entries?[indexPath.row]  else { return UITableViewCell() }
        let entrieModel = Entrie(entrie: entry)

        cell.nameLabel.text = entry.name
        cell.lastModifiedDateLabel?.text = entrieModel.lastModifiedDate

        if entry is Files.FolderMetadata {
            cell.imageCell?.image =  #imageLiteral(resourceName: "FolderIcon.png")
        }

        if entry is Files.FileMetadata {

            if entry.name.hasSuffix(".jpg") || entry.name.hasSuffix(".png") {
                cell.imageCell?.image =  #imageLiteral(resourceName: "ImageIcon.png")
            } else if entry.name.hasSuffix(".mp3") {
                cell.imageCell?.image =  #imageLiteral(resourceName: "AudioIcon.png")
            } else if entry.name.hasSuffix(".mp4") {
                cell.imageCell?.image =  #imageLiteral(resourceName: "VideoIcon.jpg")
            } else if entry.name.hasSuffix(".pdf") || entry.name.hasSuffix(".docx") {
                cell.imageCell?.image =  #imageLiteral(resourceName: "TextIcon.png")
            } else {
                cell.imageCell?.image =  #imageLiteral(resourceName: "CatsAndMoon.jpg")
            }
        }
        return cell
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let entry = selectedEntry else { return }
        
        if let vc = segue.destination as? FilesTableViewController {
            vc.path = entry.pathDisplay
        } else if let vc = segue.destination as? PhotoViewController {
            vc.filename = entry.name
        } else if let vc = segue.destination as? TextViewController {
            vc.filename = entry.name
        }
    }

}

//MARK: - UITableViewDelegate

extension FilesTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let entry = entries?[indexPath.row] else { return }
        selectedEntry = entry
        
        if entry is Files.FolderMetadata {
            self.performSegue(withIdentifier: "DeeperIntoTheFolder", sender: nil)
        }
        
        if entry.name.hasSuffix(".jpg") || entry.name.hasSuffix(".png") {
            self.performSegue(withIdentifier: "ShowImage", sender: nil)
        }
        
        if entry.name.hasSuffix(".pdf") || entry.name.hasSuffix(".docx") {
            self.performSegue(withIdentifier: "ShowText", sender: nil)
        }
        
    }
    
}
