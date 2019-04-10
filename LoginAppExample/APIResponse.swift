//
//  APIResponses.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import UIKit

enum APIResultType {
    case success
    case failure
    case serverError
}

enum APIType: String {
    case error = "Error"
    case pokemon = "Pokemon"
    case register = "User"
    case login = "Token"
    
    func getType() -> Decodable.Type {
        switch self {
        case .error:
            return Error.self
        case .login:
            return Token.self
        case .register:
            return User.self
        case .pokemon:
            return [Pokemon].self
        }
    }
}

class APIResponse<T : Decodable>: NSObject {
    
    var code: Int = 0
    var type: APIResultType = .failure
    ///To get content value, you have to cast it with as! ModelType.
    var content: [OutputModel] = [OutputModel]()
    
    init(_ jsonData: Data, code: Int, contentType: APIType) {
        super.init()
        setCode(code)
        prepareContent(contentType, from: jsonData)
    }
    
    required init(code: Int?, error: String = "") {
        super.init()
        content = [OutputModel]()
        setCode(code ?? 0)
        if error != "" {
            self.content.append(Error(error: true, reason: error))
        }
    }
    
    func prepareContent(_ contentType: APIType, from jsonData: Data) {
        let modelType = contentType.getType()
        content = [OutputModel]()
        switch contentType {
        case .pokemon:
            let pokemons =  try! JSONDecoder.init().decode(modelType as! [T].Type, from: jsonData)
            content = pokemons as? [OutputModel] ?? [OutputModel]()
        case .error:
            let object = try! JSONDecoder.init().decode(Error.self, from: jsonData)
            content.append(object)
        default:
            let object = try! JSONDecoder.init().decode(modelType as! T.Type, from: jsonData)
            content.append(object as! OutputModel)
            
        }
    }
    
    class func failure() -> Self {
        return self.init(code: 0)
    }
    
    class func success() -> Self {
        return self.init(code: 200)
    }
    
    
    fileprivate func setCode(_ code: Int) {
        self.code = code
        switch code {
        case 200..<300:
            self.type = .success
        case 404:
            self.type = .serverError
            self.content.append(Error(error: true, reason: "No data found"))
        case 408, 504, 599, 598:
            self.type = .serverError
            self.content.append(Error(error: true, reason: "Time out"))
        case 500:
            self.type = .serverError
            self.content.append(Error(error: true, reason: "Service Unavailable"))
        default:
            self.type = .failure
            self.content.append(Error(error: true, reason: "Something went wrong"))
        }
    }
}
