//
//  APIService.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 19/06/2022.
//

import Foundation
import RxSwift
import RxCocoa
import Japx

struct JapxResponse<T: Codable>: Codable {
    let data: T
}

// swiftlint:disable all
public class APIService {
    
    static let shared = APIService()
    
    private var urlSession = URLSession(configuration: .default)
    
    func request<T: JapxCodable>(_ input: BaseRequest) -> Observable<T> {
        
        return Observable.create { observer in
            guard let url = URL(string: input.url) else {
                observer.onCompleted()
                return Disposables.create()
            }
            var request = URLRequest(url: url)
            request.httpMethod = input.requestType.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let payloadData = try? JSONSerialization.data(withJSONObject: input.body ?? [:], options: [])
            request.httpBody = payloadData
            
            print("url: ", request)
            
            let task = self.urlSession.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                    print("statusCode: ", statusCode)
                    do {
                        let sData = data ?? Data()
                        if (200...399).contains(statusCode) {
                            print("data: ", sData)
                            let result = try JapxDecoder().decode(JapxResponse<T>.self, from: sData)
                            observer.onNext(result.data)
                        } else if let errorResponseArray = try? JSONDecoder().decode(ErrorResponseArray.self,
                                                                                     from: sData),
                                  let errorResponse = errorResponseArray.errors.first {
                            observer.onError(SNError.apiError(errorResponse))
                        }
                    } catch {
                        observer.onError(error)
                    }
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
