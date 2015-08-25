//
//  Lyric.swift
//  addLyrics
//
//  Created by Jun Zhou on 7/14/15.
//  Copyright (c) 2015 Jun Zhou. All rights reserved.
//

import Foundation

class EditableLyrics: Lyrics {
    
    var isTimeAdded: [Bool] = [Bool]()
    
    override init() {
        super.init()
    }
    
    init(original: [String]){
        super.init()
        isTimeAdded = [Bool](count: original.count, repeatedValue: false)
        for i in 0...(original.count-1) {
            self.addLine(TimeNumber(time: 0), str: original[i])
        }
    }
}