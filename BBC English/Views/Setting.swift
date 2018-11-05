//
//  Setting.swift
//  SearchBarInNav
//
//  Created by Khong Hai on 11/3/18.
//  Copyright © 2018 Thanh Hai. All rights reserved.
//

import UIKit
import Foundation

class Setting: NSObject {
    let name: SettingName
    let imageName: String
    
    init(name: SettingName, imageName: String){
        self.name = name
        self.imageName = imageName
    }
}
