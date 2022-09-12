//
//  EmassiApiResponse.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 12.09.2022.
//

import Foundation
struct EmassiApiResponse: Codable{
    let status: Int
    let message: String
    let data: Data?
    
    enum CodingKeys: CodingKey{
        case status
        case message
        case data
    }
    
    var statusMessage: EmassiApiStatus?{
        return .init(rawValue: status)
    }
    
    enum EmassiApiStatus: Int{
        case NO_ERRORS = 0
        case INVALID_API_KEY = 10
        case INVALID_TOKEN
        case INVALID_SIGN
        case INVALID_EMAIL
        case INVALID_PHONENUMBER
        case INVALID_PIN_CODE
        case INVALID_PASSWORD
        case TOO_SMALL_PASSWORD
        case TOO_LONG_PASSWORD
        case INVALID_TYPE
        case INVALID_USERNAME_DATA
        case INVALID_ADDRESS_DATA
        case INVALID_PARAMS
        case FILE_UPLOAD_ERROR = 30
        case FILE_TOO_LARGE
        case FILE_MIME_TYPE_ERROR
        case PASSWORD_DO_NOT_MATCH = 40
        case SIGN_CHECK_ERROR
        case PIN_CODE_CHECK_ERROR
        case ACCOUNT_NOT_FOUND = 50
        case ACCOUNT_NOT_FOUND_OR_TOKEN_EXPIRED
        case ACCOUNT_ALREADY_EXISTS
        case CUSTOMER_NOT_FOUND = 60
        case PERFORMER_NOT_FOUND = 70
        case TOO_MANY_DOCS
        case WORK_NOT_FOUND = 80
        case WORK_IN_PROCESS
        case PRIVATE_WORK
        case PHOTO_NOT_FOUND
        case TOO_MANY_PHOTOS
        case CONTACT_NOT_FOUND = 90
        case MESSAGE_NOT_FOUND
        case EMPTY_TEXT
        case FEEDBACK_ALREADY_EXISTS = 100
        case HTTP_404_NOT_FOUND = 404
        case HTTP_500_INTERNAL_SERVER_ERROR = 500
    }
}
