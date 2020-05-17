//
//  Entrie.swift
//  CatInABox
//
//  Created by MG on 14.05.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SwiftyDropbox

struct Entrie {
    
    var name: String
    var lastModifiedDate: String?
    
    init(entrie: Files.Metadata) {
        self.name = entrie.name
        let pairs = entrie.description.components(separatedBy: ";")
        
        for pair in pairs {
            let values = pair.components(separatedBy: "=")
            
            if values.count == 2, let key = values.first, let value = values.last {
                
                if key.contains("server_modified") {
                    
                    let offset = value.index(value.startIndex, offsetBy: 12)
                    let firstIndex = value.index(value.startIndex, offsetBy: 2)
                    lastModifiedDate = String(value[firstIndex..<offset])
                }
                
            }
        }
        
    }

}
