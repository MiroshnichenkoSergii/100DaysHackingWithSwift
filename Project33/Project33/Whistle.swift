//
//  Whistle.swift
//  Project33
//
//  Created by Sergii Miroshnichenko on 23.08.2022.
//

import CloudKit
import UIKit

class Whistle: NSObject {
    var recordID: CKRecord.ID!
    var genre: String!
    var comments: String!
    var audio: URL!
}
