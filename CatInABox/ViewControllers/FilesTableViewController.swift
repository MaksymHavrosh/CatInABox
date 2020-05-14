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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = DropboxClientsManager.authorizedClient
        client?.files.listFolder(path: "").response { (response, error) in
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
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        
        guard let entry = entries?[indexPath.row]  else { return UITableViewCell() }
        let entrieModel = Entrie(entrie: entry)

        cell.textLabel?.text = entry.name
        cell.detailTextLabel?.text = entrieModel.lastModifiedDate

        if entry is Files.FolderMetadata {
            cell.imageView?.image =  #imageLiteral(resourceName: "FolderIcon.png")
        }

        if entry is Files.FileMetadata {

            if entry.name.hasSuffix(".jpg") || entry.name.hasSuffix(".png") {
                cell.imageView?.image =  #imageLiteral(resourceName: "ImageIcon.png")
            } else if entry.name.hasSuffix(".mp3") {
                cell.imageView?.image =  #imageLiteral(resourceName: "AudioIcon.png")
            } else if entry.name.hasSuffix(".mp4") {
                cell.imageView?.image =  #imageLiteral(resourceName: "VideoIcon.jpg")
            } else if entry.name.hasSuffix(".pdf") || entry.name.hasSuffix(".txt") {
                cell.imageView?.image =  #imageLiteral(resourceName: "TextIcon.png")
            } else {
                cell.imageView?.image =  #imageLiteral(resourceName: "CatsAndMoon.jpg")
            }
        }
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self), for: indexPath) as! TableViewCell
//        cell.nameLabel.text = entry.name

        return cell
    }

}
