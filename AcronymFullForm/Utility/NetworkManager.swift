//
//  NetworkManger.swift
//  AcronymFullForm
//
//  Created by hscuser on 01/06/21.
//

import Foundation
class NetworkManger: NSObject, URLSessionDelegate{
   typealias apiResponseCompletion = (_ responseData:Data?,_ responseError:AppError?) -> Void
    private let sessionConfig =  URLSessionConfiguration.default
    private var session: URLSession?{
        return  URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)

    }
    private func handleURLRequest(urlRequest:URLRequest, completion: @escaping (_ responseData:Data?,_ responseObject: URLResponse?,_ responseError:Error?)->Void) {
        
      let sessionDataTask = session!.dataTask(with: urlRequest , completionHandler: { (data, response, error) in
//        print("Asyncrhonous url request is \(urlRequest)")
      
        completion(data, response, error)
        })
        sessionDataTask.resume()
    }
    
    private func apiRequest(urlRequest : URLRequest?, completion:@escaping apiResponseCompletion){
        guard urlRequest != nil else {
            let appError = AppError.apiError(reason: AppError.APIErrorReason.apiCallFailed(responseData: nil, errorReason: ErrorMessage.REQUEST_ERROR))
            return completion(nil,appError)
        }
        handleURLRequest(urlRequest: urlRequest!) { (responseData, urlResponse, errorObject) in
            if urlResponse != nil{
                let responseCode = (urlResponse as! HTTPURLResponse).statusCode
                if responseCode != 200 {
                    let appError = AppError.apiError(reason: AppError.APIErrorReason.apiCallFailed(responseData: responseData, errorReason: errorObject?.localizedDescription))
                    return completion(nil,appError)
                }
                
                guard responseData != nil else {
                    
                    let appError = AppError.apiError(reason: AppError.APIErrorReason.apiCallFailed(responseData: responseData, errorReason: ErrorMessage.RESPONSE_NIL))
                    return completion(nil,appError)
                }
                
                return completion(responseData!, nil)

                
            } else{

                let appError = AppError.apiError(reason: AppError.APIErrorReason.apiCallFailed(responseData: responseData, errorReason: errorObject?.localizedDescription ?? ErrorMessage.RESPONSE_ERROR))
                return completion(nil,appError)
            }
        
    }
}
    
   
    
    func fetchAcronymFullForm(for acronym: String , completion:@escaping apiResponseCompletion){
        var mutableURLRequest: URLRequest?
        let urlString = Constants.ApiURL.baseURL
        var urlComponent: URLComponents? = URLComponents(string: urlString)
        guard urlComponent != nil else {
            let appError = AppError.apiError(reason: AppError.APIErrorReason.apiCallFailed(responseData: nil, errorReason: ErrorMessage.REQUEST_ERROR))
            return completion(nil,appError)
        }
        urlComponent!.queryItems = [URLQueryItem(name: "sf", value: acronym)]
        mutableURLRequest = URLRequest(url: urlComponent!.url!)
        apiRequest(urlRequest: mutableURLRequest, completion: completion)

    }
    
    
    
    
    
}
