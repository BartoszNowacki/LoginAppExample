//
//  APIClient.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import UIKit
import Alamofire

open class APIClient: NSObject {
    
    lazy fileprivate var manager: Alamofire.SessionManager = SessionManager()
    static let shared = APIClient()
    static var baseURLString: String {
        if let info = Bundle.main.infoDictionary,
            let url = info["API URL"] as? String {
            return url
        } else {
            return ""
        }
    }
    
    // MARK: -
    
    fileprivate func handleResponse<T>(_ response: DataResponse<Data>, contentType: APIType) -> APIResponse<T> {
        debugPrint(response)
        if response.response?.statusCode == 200, response.result.isFailure { log.info("tbdc got to this statement"); return APIResponse<T>.success() }
        let code = response.response?.statusCode ?? 0
        let jsonData = response.result.value ?? nil
        switch code {
        case 200..<300:
            return APIResponse<T>(jsonData!, code: code, contentType: contentType)
        default:
            debugPrint(response)
            log.error("\(response.request?.description ?? String(describing: code)): \(String(describing: jsonData))")
            if let jsonData = jsonData {
                return APIResponse<T>(jsonData, code: code, contentType: .error)
            } else {
                return APIResponse<T>(code: code)
            }
        }
    }
    
    // MARK: -
    
    /// A generic function used to make Api Call.
    /// - parameter T: Type of data model for output data
    /// - parameter type: enum APIType, which informs of type of the API Call
    /// - parameter data: data passed to call as an input
    
    func makeCall<T>(type: APIType, for data: InputModel, complete: @escaping (APIResponse<T>) -> Void) {
        var request: Router
        switch type {
        case .login:
            request = .login(login: data as! Login)
        case .pokemon:
            let token = data as! Token
            Router.OAuthToken = token.token
            request = .pokemons
        case .register:
            request = .registerNewUser(profile: data as! Profile)
        case .error:
            fatalError()
        }
        manager.request(request).responseData { response in
            complete(self.handleResponse(response, contentType: type))
        }
    }
    
    enum Router: URLRequestConvertible {
        static var OAuthToken: String?
        
        case registerNewUser(profile: Profile)
        case login(login: Login)
        case pokemons
        
        // MARK: - URLRequestConvertible
        
        var method: Alamofire.HTTPMethod {
            switch self {
            case .pokemons:
                return .get
            default:
                return .post
            }
        }
        
        func asURLRequest() throws -> URLRequest {
            let path: String = {
                switch self {
                case .registerNewUser:
                    return "\(baseURLString)users"
                case .login:
                    return "\(baseURLString)login"
                case .pokemons:
                    return "\(baseURLString)pokemons"
                }
            }()
            let params: [String: AnyObject]? = {
                switch self {
                case .registerNewUser(let profile):
                    return ["name": profile.name as AnyObject,
                            "email": profile.email as AnyObject,
                            "password": profile.password as AnyObject]
                case .login(let login):
                    return ["email": login.email as AnyObject,
                            "password": login.password as AnyObject]
                default:
                    return nil
                }
            }()
            
            let URL = Foundation.URL(string: path) ?? Foundation.URL(string: "https://")!
            var request = URLRequest(url: URL)
            request.httpMethod = String(method.rawValue)
            request.timeoutInterval = 15.0
        
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let token = Router.OAuthToken {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            if let params = params {
                do {
                    switch self {
                    case .login:
                        let email = params["email"] as! String
                        let password = params["password"] as! String
                        let loginString = String(format: "%@:%@", email, password)
                        let loginData = loginString.data(using: String.Encoding.utf8)!
                        let base64LoginString = loginData.base64EncodedString()
                        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
                        return request
                    default:
                        return try Alamofire.JSONEncoding.default.encode(request, with: params)
                    }
                } catch {
                    log.error("Alamofire.JSONEncoding.default.encode error")
                    return request
                }
            } else {
                return request
            }
        }
    }
}
