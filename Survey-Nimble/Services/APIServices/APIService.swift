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

// swiftlint:disable all
public class APIService {
    
    static let shared = APIService()
    let cache = NSCache<NSString, UIImage>()
    private var urlSession = URLSession(configuration: .default)
    
    func request<T: Decodable & Encodable>(_ input: BaseRequest,
                                           decoder: SNDecoderType = .japxDecoder,
                                           heldError: Error? = nil) -> Observable<T> {
        
        return Observable.create { observer in
            guard heldError as? SNError == .unauthentication || heldError == nil else {
                observer.onError(heldError!)
                return Disposables.create {}
            }
            
            guard let request = input.transformToURLRequest() else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            print("url: ", request)
            let task = self.urlSession.dataTask(with: request) { data, response, error in
                
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    print("statusCode: ", statusCode)
                    
                    do {
                        let sData = data ?? Data()
                        switch statusCode {
                        case (200...399):
                            
                            if decoder == .japxDecoder {
                                let result = try JapxDecoder().decode(JapxResponse<T>.self, from: sData)
                                observer.onNext(result.data)
                            } else {
                                let result = try JSONDecoder().decode(NoReply.self, from: sData)
                                print("message:", result.meta.message)
                                guard let res = result.meta as? T else { return }
                                observer.onNext(res)
                            }
                            
                        default:
                            observer.onError(self.handleResponseError(response: response, data: data, error: error, input: input))
                        }
                    } catch {
                        observer.onError(error)
                    }
                } else if error != nil {
                    observer.onError(SNError.apiError(ErrorResponse(detail: error?.localizedDescription ?? "lost connection", code: "")))
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func requestList<T: JapxCodable>(_ input: BaseRequest, decoder: SNDecoderType = .japxDecoder) -> Observable<([T], Meta)> {
        
        return Observable.create { observer in
            
            guard let request = input.transformToURLRequest() else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            print("url: ", request)
            
            let task = self.urlSession.dataTask(with: request) { data, response, error in
                
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    print("statusCode: ", statusCode)
                    
                    guard statusCode != 401 else {
                        observer.onError(SNError.unauthentication)
                        return
                    }
                    
                    do {
                        let sData = data ?? Data()
                        switch statusCode {
                        case (200...399):
                            let result = try JapxDecoder().decode(JapxResponseArray<T>.self, from: sData)
                            observer.onNext((result.data ?? [], result.meta))
                        default:
                            observer.onError(self.handleResponseError(response: response, data: data, error: error, input: input))
                        }
                    } catch {
                        observer.onError(error)
                    }
                } else if error != nil {
                    observer.onError(SNError.apiError(ErrorResponse(detail: error?.localizedDescription ?? "",
                                                                    code: "")))
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
        .retry { error -> Observable<Error> in
            return error
                .flatMapLatest { error -> Observable<Error> in
                    
                    return self.refreshToken(error).flatMapLatest { response -> Observable<Error> in
                        KeychainAccess.remove()
                        KeychainAccess.userInfo = response
                        return Observable.just(error)
                    }
                }
        }
    }
    
    private func refreshToken(_ error: Error) -> Observable<User> {
        let input = RefreshTokenRequest()
        return self.request(input,
                            heldError: error).do(onError: { sError in
            guard let convertedError = sError as? SNError,
                  convertedError == .expiredRefreshToken else {
                return
            }
            self.backToLogin()
        })
    }
}

// MARK: Private methods

extension APIService {
    
    // Handling errors
    private func handleResponseError(response: URLResponse? , data: Data?, error: Error?, input: BaseRequest) -> SNError {
        if let httpResponse = response as? HTTPURLResponse {
            let statusCode = httpResponse.statusCode
            print("statusCode: ", statusCode)
            
            switch statusCode {
            case 400 where input is RefreshTokenRequest :
                return SNError.expiredRefreshToken
            default:
                let sData = data ?? Data()
                if let errorResponseArray = try? JSONDecoder().decode(ErrorResponseArray.self,
                                                                      from: sData),
                   let errorResponse = errorResponseArray.errors.first {
                    return SNError.apiError(errorResponse)
                } else if let error = error {
                    return SNError.apiError(ErrorResponse(detail: error.localizedDescription ,
                                                          code: ""))
                }
                
            }
        }
        return SNError.apiError(ErrorResponse(detail: error?.localizedDescription ?? "",
                                              code: ""))
    }
    
    private func backToLogin() {
        DispatchQueue.main.async {
            let loginVC = LoginViewController()
            let navigationController = UINavigationController(rootViewController: loginVC)
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.window?.rootViewController = navigationController
        }
    }
}
