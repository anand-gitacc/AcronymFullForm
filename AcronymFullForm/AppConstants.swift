//
//  AppConstants.swift
//  AcronymFullForm
//
//  Created by hscuser on 01/06/21.
//

import Foundation
struct Constants{
    
    struct ApiURL {
        static let baseURL = "http://www.nactem.ac.uk/software/acromine/dictionary.py"
        
    }
    
}


enum AppError: Error{
    enum APIErrorReason {
        case apiCallFailed(responseData: Data?, errorReason: String?)
    }
    case apiError(reason: APIErrorReason)
}

extension AppError: LocalizedError{
    public var errorDescription: String? {
        switch self {
        case .apiError(let reason):
            return reason.localizedDescription
        }
    }
}

extension AppError.APIErrorReason{
    var localizedDescription: String?{
        switch self {
        case .apiCallFailed( _, let errorReason):
            return errorReason
        }
    }
    
}
struct ErrorMessage{
    
    static let RESPONSE_NIL = "Response data is not available"
    static let PARAMETER_PARSING_ERROR = "Parameter Parsing Error"
    
    static let RESPONSE_ERROR = "Response Error"
    
    
    static let REQUEST_ENCODING_DOMAIN = "Request Encoding Error"
    static let REQUEST_ERROR = "Request Error"
}



