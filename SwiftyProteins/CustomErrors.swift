//
//  CustomErrors.swift
//  SwiftyProteins
//
//  Created by Дмитрий on 04.02.2021.
//  Copyright © 2021 home. All rights reserved.
//

import Foundation

enum CustomError: Error {
    
    case invalidURL
    case invalidFile
    case fileNotExist
    case invalidConverting
}

extension CustomError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("invalidURL", value: "Can't convert string into URL", comment: "")
        case .invalidFile:
            return NSLocalizedString("invalidFile", value: "File can't be retrived or parsed", comment: "")
        case .fileNotExist:
            return NSLocalizedString("fileNotExist", value: "Retrived file doesn't exist", comment: "")
        case .invalidConverting:
            return NSLocalizedString("invalidConverting", value: "Can't convert retrived data into string", comment: "")
        }
    }
    
}
