//
//  DBError.swift
//  MakeABet
//
//  Created by Olivia Alexander on 10/25/24.
//

import Foundation


enum DBError: Error {
    case registrationFailed(errorMessage: String)
    case loginFailed(errorMessage: String)
    case fetchFailed(errorMessage: String)
}
