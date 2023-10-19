//
//  AuthService.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/16.
//

import Foundation
import Combine

final class AuthService {
    private let session: URLSessionable
    
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
    
    func signIn(oauthType: OAuthType,
                token: String,
                nickname: String?) -> AnyPublisher<SignInResponse, Error> {
        let endpoint = Endpoint(method: .POST,
                                paths: "/auth/login",
                                body: ["providerType" : oauthType.rawValue,
                                       "token" : token,
                                       "nickname" : nickname ?? ""])
        
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<SignInResponse>.self,
                                         responseHandler: { res in
            guard (200...299).contains(res.statusCode) ||
                    res.statusCode == 401 else {
                throw CommonError.serverError
            }
        })
        .tryMap { response -> SignInResponse in
            switch response.code {
            case 200:
                return response.result
            case 2001, 2005:
                throw CommonError.tempUser(response.result.userId ?? "")
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchAreaInfo() -> AnyPublisher<[String], Error> {
        let endpoint = Endpoint(paths: "/user/area")
        
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<[String]>.self,
                                         responseHandler: { res in
            guard (200...299).contains(res.statusCode) else {
                throw CommonError.serverError
            }
            
        })
        .tryMap { response -> [String] in
            switch response.code {
            case 200:
                return response.result
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchCityInfo(area: String) -> AnyPublisher<[String], Error> {
        let endpoint = Endpoint(paths: "/user/city",
                                queries: ["area" : area])
        
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<[String]>.self,
                                         responseHandler: { res in
            guard (200...299).contains(res.statusCode) else {
                throw CommonError.serverError
            }
            
        })
        .tryMap { response -> [String] in
            switch response.code {
            case 200:
                return response.result
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }

    func signUp(signUpInfo: SignUpInfo)-> AnyPublisher<SignUpResponse, Error> {
        let endpoint = Endpoint(method: .PATCH,
                                paths: "/user/signup",
                                body: ["userId" : signUpInfo.userId ?? "",
                                       "age" : Int(signUpInfo.age ?? "") ?? 0,
                                       "areaCode" : signUpInfo.area ?? "",
                                       "cityCode" : signUpInfo.city ?? "",
                                       "lastYearInComde" : Int(signUpInfo.income ?? "") ?? 0,
                                       "educationType" : signUpInfo.education ?? "",
                                       "jobs" : signUpInfo.job ?? [],
                                       "marketingStatus" : signUpInfo.marketingAgree])
        
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<SignUpResponse>.self,
                                         responseHandler: { res in
            guard (200...299).contains(res.statusCode) else {
                throw CommonError.serverError
            }
        })
        .tryMap { response -> SignUpResponse in
            switch response.code {
            case 200:
                return response.result
            case 1003, 1004:
                print("이메일, 또는 닉네임, 소셜타입 에러")
                throw CommonError.otherError
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
}
