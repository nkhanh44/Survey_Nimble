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
    
    func request<T: JapxCodable>(_ input: BaseRequest) -> Observable<T> {
        
        return Observable.create { observer in
            guard let url = URL(string: input.url) else {
                observer.onCompleted()
                return Disposables.create()
            }
            var request = URLRequest(url: url)
            request.httpMethod = input.requestType.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let accessToken = KeychainAccess.userInfo?.accessToken, !accessToken.isEmpty {
                request.addValue("Authorization", forHTTPHeaderField: "Bearer " + accessToken)
            }
            
            let payloadData = try? JSONSerialization.data(withJSONObject: input.body ?? [:], options: [])
            request.httpBody = payloadData
            
            print("url: ", request)
            
            let task = self.urlSession.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    print("statusCode: ", statusCode)
                    
                    do {
                        let sData = data ?? Data()
                        switch statusCode {
                        case (200...399):
                            let result = try JapxDecoder().decode(JapxResponse<T>.self, from: sData)
                            observer.onNext(result.data)
                        default:
                            if let errorResponseArray = try? JSONDecoder().decode(ErrorResponseArray.self,
                                                                                  from: sData),
                               let errorResponse = errorResponseArray.errors.first {
                                observer.onError(SNError.apiError(errorResponse))
                            } else if let error = error {
                                observer.onError(error)
                            }
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
    
    func requestList<T: JapxCodable>(_ input: BaseRequest) -> Observable<([T], Meta)> {
        
        return Observable.create { observer in
            guard let url = URL(string: input.url) else {
                observer.onCompleted()
                return Disposables.create()
            }
            var request = URLRequest(url: url)
            request.httpMethod = input.requestType.rawValue
            
            if let accessToken = KeychainAccess.userInfo?.accessToken, !accessToken.isEmpty {
                print("accessToken: ", accessToken)
                request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
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
                        case 404:
                            observer.onError(SNError.notFound)
                        default:
                            if let errorResponseArray = try? JSONDecoder().decode(ErrorResponseArray.self,
                                                                                  from: sData),
                               let errorResponse = errorResponseArray.errors.first {
                                observer.onError(SNError.apiError(errorResponse))
                            } else if error != nil {
                                observer.onError(SNError.apiError(ErrorResponse(detail: error?.localizedDescription ?? "",
                                                                                code: "")))
                            }
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
                    return self.renewToken(error).do(onError: { sError in
                        guard let convertedError = sError as? SNError,
                              convertedError == .expiredRefreshToken else {
                            return
                        }
                        self.backToLogin()
                    }).flatMapLatest { response -> Observable<Error> in
                        KeychainAccess.remove()
                        KeychainAccess.userInfo = response
                        return Observable.just(error)
                    }
                }
        }
    }
    
    func renewToken(_ error: Error) -> Observable<User> {
        return Observable.create { observer in
            
            // check only unauthen error allows to go through
            guard let convertedError = error as? SNError,
                  convertedError == .unauthentication else {
                observer.onError(error)
                return Disposables.create {}
            }
            
            let input = RefreshTokenRequest()
            guard let url = URL(string: input.url) else {
                observer.onCompleted()
                return Disposables.create()
            }
            var request = URLRequest(url: url)
            request.httpMethod = input.requestType.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let accessToken = KeychainAccess.userInfo?.accessToken, !accessToken.isEmpty {
                request.addValue("Authorization", forHTTPHeaderField: "Bearer " + accessToken)
            }
            
            let payloadData = try? JSONSerialization.data(withJSONObject: input.body ?? [:], options: [])
            request.httpBody = payloadData
            
            print("url: ", request)
            let task = self.urlSession.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    print("statusCode: ", statusCode)
                    
                    do {
                        let sData = data ?? Data()
                        switch statusCode {
                        case (200...399):
                            let result = try JapxDecoder().decode(JapxResponse<User>.self, from: sData)
                            observer.onNext(result.data)
                        case 400:
                            observer.onError(SNError.expiredRefreshToken)
                        default:
                            if let errorResponseArray = try? JSONDecoder().decode(ErrorResponseArray.self,
                                                                                  from: sData),
                               let errorResponse = errorResponseArray.errors.first {
                                observer.onError(SNError.apiError(errorResponse))
                            } else if error != nil {
                                observer.onError(SNError.apiError(ErrorResponse(detail: error?.localizedDescription ?? "",
                                                                                code: "")))
                            }
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
    }
    
    // This request's used to decode response by JSONDecoder instead of JapxDecoder
    func requestNoReply<T: Codable>(_ input: BaseRequest) -> Observable<T> {
        
        return Observable.create { observer in
            guard let url = URL(string: input.url) else {
                observer.onCompleted()
                return Disposables.create()
            }
            var request = URLRequest(url: url)
            request.httpMethod = input.requestType.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let accessToken = KeychainAccess.userInfo?.accessToken, !accessToken.isEmpty {
                request.addValue("Authorization", forHTTPHeaderField: "Bearer " + accessToken)
            }
            
            let payloadData = try? JSONSerialization.data(withJSONObject: input.body ?? [:], options: [])
            request.httpBody = payloadData
            
            print("url: ", request)
            
            let task = self.urlSession.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    print("statusCode: ", statusCode)
                    
                    do {
                        let sData = data ?? Data()
                        switch statusCode {
                        case (200...399):
                            let result = try JSONDecoder().decode(NoReply.self, from: sData)
                            print("message:", result.meta.message)
                            guard let res = result.meta as? T else { return }
                            observer.onNext(res)
                        default:
                            if let errorResponseArray = try? JSONDecoder().decode(ErrorResponseArray.self,
                                                                                  from: sData),
                               let errorResponse = errorResponseArray.errors.first {
                                observer.onError(SNError.apiError(errorResponse))
                            } else {
                                observer.onError(error!)
                            }
                        }
                    } catch {
                        observer.onError(error)
                    }
                } else if error != nil {
                    observer.onError(SNError.apiError(ErrorResponse(detail: error?.localizedDescription ?? "lost connection",
                                                                    code: "")))
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

// MARK: Private methods

extension APIService {
    
    private func backToLogin() {
        DispatchQueue.main.async {
            let loginVC = LoginViewController()
            let navigationController = UINavigationController(rootViewController: loginVC)
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.window?.rootViewController = navigationController
        }
    }
}
