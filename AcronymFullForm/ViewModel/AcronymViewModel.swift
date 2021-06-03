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
    
    
    func fetchAcronymFullForm(for acronym: String) {
        if acronymModelArr == nil {
            acronymModelArr = [AcronymModel]()
        }
        acronymModelArr!.removeAll()
        
        networkManager.fetchAcronymFullForm(for: acronym) {[weak self] (data, appError) in
            
            if  appError == nil{
                do {
                    let acronymResponse = try JSONDecoder().decode([AcronymModel].self,from:data!)
                    self?.acronymModelArr?.append(contentsOf: acronymResponse)
                    self?.refreshView(with: appError)
                    
                } catch  {
                    let appError = AppError.apiError(reason: AppError.APIErrorReason.apiCallFailed(responseData: nil, errorReason: ErrorMessage.PARAMETER_PARSING_ERROR))
                    self?.refreshView(with: appError)
                    
                }
                
            }
            else{
                self?.refreshView(with: appError)

            }

           
        }
        
    }
    
    func refreshView(with appError: AppError?) {
        DispatchQueue.main.async {
            if appError != nil{
                self.errorString.value = appError!.errorDescription
                self.acronymModel.value = nil
            }
            else{
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
    
}
