//
//  AcronymViewModel.swift
//  AcronymFullForm
//
//  Created by hscuser on 01/06/21.
//

import Foundation

public class AcronymViewModel {
    
    private var acronymModelArr: [AcronymModel]?
    private let networkManager = NetworkManger()
    var acronymModel: Box<AcronymModel?> = Box(nil)
    var errorString: Box<String?> = Box(nil)
    
    func errorHandling(errorDescription: String?) {
        if errorDescription != nil {
            self.errorString.value = errorDescription
            self.acronymModel.value = nil
        }
       
    }
    
    func validateEnteredAcronym(acronym: String) -> Bool {
        let trimmedString = acronym.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        do {
            let regex =  try NSRegularExpression(pattern: ".*[^A-Za-z].*", options: [])
            if regex.firstMatch(in: trimmedString, options: [], range: NSMakeRange(0, trimmedString.count)) != nil {
                self.errorHandling(errorDescription: "Input Validation failed")
                return false
            }
        
        } catch  {
            self.errorHandling(errorDescription: error.localizedDescription)
            print(error)
            return false
        }
        
        return true
        
    }
    
    func fetchAcronymFullForm(for acronym: String) {
        let trimmedString = acronym.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if acronymModelArr == nil {
            acronymModelArr = [AcronymModel]()
        }
        acronymModelArr!.removeAll()
        
        networkManager.fetchAcronymFullForm(for: trimmedString) {[weak self] (data, appError) in
            
            if  appError == nil{
                do {
                    let acronymResponse = try JSONDecoder().decode([AcronymModel].self,from:data!)
                    self?.acronymModelArr?.append(contentsOf: acronymResponse)
                    self?.refreshView(with: appError)
                    
                } catch  {
                    let appError = AppError.apiError(reason: AppError.APIErrorReason.apiCallFailed(responseData: nil, errorReason: ErrorMessage.PARAMETER_PARSING_ERROR))
                    self?.errorHandling(errorDescription: appError.errorDescription)
                    
                }
                
            }
            else{
                self?.errorHandling(errorDescription: appError!.errorDescription)

            }

           
        }
        
    }
    
    func refreshView(with appError: AppError?) {
        DispatchQueue.main.async {
            if self.acronymModelArr?.count != 0{
                let acromineModel = self.acronymModelArr![0]
                self.acronymModel.value = acromineModel
                
            }
            else{
                self.acronymModel.value = nil
            }
            
        }
        
        
    }
    
}
