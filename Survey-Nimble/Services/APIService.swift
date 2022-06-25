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
                        if (200...399).contains(statusCode) {
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
                        if (200...399).contains(statusCode) {
                            let result = try JapxDecoder().decode(JapxResponseArray<T>.self, from: sData)
                            observer.onNext((result.data ?? [], result.meta))
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
        }.retry { error -> Observable<Error> in
            return error.flatMapLatest { error -> Observable<Error> in
                return self.renewToken().do(onError: { sError in
                    self.backToLogin()
                }).flatMapLatest { response -> Observable<Error> in
                    KeychainAccess.remove()
                    KeychainAccess.userInfo = response
                    return Observable.just(error)
                }
            }
        }
    }
    
    func renewToken() -> Observable<User> {
        return Observable.create { observer in
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
                        if (200...399).contains(statusCode) {
                            let result = try JapxDecoder().decode(JapxResponse<User>.self, from: sData)
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
                        if (200...399).contains(statusCode) {
                            let result = try JSONDecoder().decode(NoReply.self, from: sData)
                            print("message:", result.meta.message)
                            guard let res = result.meta as? T else { return }
                            observer.onNext(res)
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
