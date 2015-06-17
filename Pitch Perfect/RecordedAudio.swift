//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Christopher Burgess on 3/5/15.
//  Copyright (c) 2015 Christopher Burgess. All rights reserved.
//

import Foundation
import AVFoundation

// used to save the path and title of the recorded audio file
class RecordedAudio: NSObject{

    var filePathUrl: NSURL!
    var title: String!
    
    // default constructor 
    init(filePathURL:NSURL, title:String)
    {
        self.filePathUrl = filePathURL
        self.title = title
    }
}

