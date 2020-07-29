//
//  Readwritefiles.swift
//  rcloneOSX
//
//  Created by Thomas Evensen on 25/10/2016.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//
//  let str = "/Rclone/" + serialNumber + profile? + "/scheduleRsync.plist"
//  let str = "/Rclone/" + serialNumber + profile? + "/configRsync.plist"
//  let str = "/Rclone/" + serialNumber + "/config.plist"
//

import Cocoa
import Foundation

class ReadWriteDictionary: NamesandPaths {
    // Function for reading data from persistent store
    func readNSDictionaryFromPersistentStore() -> [NSDictionary]? {
        var data = [NSDictionary]()
        guard self.filename != nil, self.key != nil else { return nil }
        let dictionary = NSDictionary(contentsOfFile: self.filename!)
        let items: Any? = dictionary?.object(forKey: self.key!)
        guard items != nil else { return nil }
        if let arrayofitems = items as? NSArray {
            for i in 0 ..< arrayofitems.count {
                if let item = arrayofitems[i] as? NSDictionary {
                    data.append(item)
                }
            }
        }
        return data
    }

    // Function for write data to persistent store
    func writeNSDictionaryToPersistentStorage(array: [NSDictionary]) -> Bool {
        let dictionary = NSDictionary(object: array, forKey: self.key! as NSCopying)
        guard self.filename != nil else { return false }
        return dictionary.write(toFile: self.filename!, atomically: true)
    }

    init(whattoreadwrite: WhatToReadWrite, profile: String?, configpath: String) {
        super.init(whattoreadwrite: whattoreadwrite, profile: profile, configpath: configpath)
    }
}
