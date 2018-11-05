//
//  XMLManager.swift
//  BBC English
//
//  Created by Khong Hai on 11/5/18.
//  Copyright © 2018 Thanh Hai. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Item: NSObject {
    
    var title: String = ""
    var descriptions: String = ""
    var link: String = ""
    var guid: String = ""
    var urlMedia: String = ""
    var isFavorited: Bool = false
    var isExistedInCoreData: Bool = false
    
    //Hàm khởi tạo cho Item
    init(title: String, description: String, link: String, guid: String, urlMedia: String, isFavorited: Bool, isExistedInCoreData: Bool) {
        
        self.title = title
        self.descriptions = description
        self.link = link
        self.guid = guid
        self.urlMedia = urlMedia
        self.isFavorited = isFavorited
        self.isExistedInCoreData = isExistedInCoreData
    }
}

class XMLDataModel: NSObject, XMLParserDelegate {
    
    var xmlParser: XMLParser!
    var dataList: [Item] = [Item]()
    
    //Bien luu thong tin cua node hien tai
    var currentParserElement: String = ""
    
    //Biem tam chua du lieu khi doc cua mot node
    var tmpItem = Item(title: "", description: "", link: "", guid: "", urlMedia: "", isFavorited: false, isExistedInCoreData: false)
    
    //Co danh dau cho biet dang xu ly o Item hay khong
    var inItemNode: Bool = false
    
    init(urlRSSFeed: String) {
        super.init()
        //Khoi tao URL dung cho Request
        let url = URL(string: urlRSSFeed)
        
        xmlParser = XMLParser(contentsOf: url!)
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    //MARK:- Cai dat cac ham CallBack cua XMLParser
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        //Neu gap Item thi dung co de danh dau
        
        if (elementName == "item"){
            inItemNode = true
            tmpItem = Item(title: "", description: "", link: "", guid: "", urlMedia: "", isFavorited: false, isExistedInCoreData: false)
        }
        if(inItemNode){
            print("Bắt đầu thẻ: \(elementName)")
            //Luu thong tin the hien tai
            currentParserElement = elementName
            
            switch(elementName){
            case "title":
                tmpItem.title = ""
            case "description":
                tmpItem.descriptions = ""
            case "link":
                tmpItem.link = ""
            case "guid":
                tmpItem.guid = ""
            case "media:thumbnail":
                
                //Lấy url ảnh của Item
                if let urlImageItem = attributeDict["url"]{
                    print(urlImageItem)
                    tmpItem.urlMedia = urlImageItem
                }
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if(inItemNode){
            switch(currentParserElement){
            case "title":
                tmpItem.title += string
                var editedTitle = tmpItem.title
                //Loại bỏ khoảng trống và ký tự không phù hợp cho Title
                editedTitle = editedTitle.replacingOccurrences(of: "BBC Learning English - English at Work / ", with: "")
                editedTitle = editedTitle.replacingOccurrences(of: "\n      ", with: "")
                tmpItem.title = editedTitle
            case "description":
                tmpItem.descriptions += string
            case "link":
                tmpItem.link += string
            case "guid":
                tmpItem.guid += string
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if(inItemNode){
            print("Kết thúc thẻ :\(elementName)")
            switch(elementName){
            case "item":
                //Reset lai cac bien tham chieu
                dataList.append(tmpItem)
                inItemNode = false
                currentParserElement = ""
            default:
                break
            }
        }
    }
}
