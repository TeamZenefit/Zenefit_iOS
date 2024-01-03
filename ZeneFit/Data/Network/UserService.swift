//
//  UserService.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/10/23.
//

import Foundation
import Combine

final class UserService {
    private let session: URLSessionable
    
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
    
    func getUserInfo() -> AnyPublisher<UserInfoDTO, Error> {
        let endpoint = Endpoint(method: .GET,
                                paths: "/user")
            .setAccessToken()
        
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<UserInfoDTO>.self,
                                         responseHandler: { res in
            guard (200...299).contains(res.statusCode) ||
                    res.statusCode == 401 else {
                throw CommonError.serverError
            }
        })
        .tryMap { response -> UserInfoDTO in
            switch response.code {
            case 200:
                return response.result
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    func getSocialInfo() -> AnyPublisher<SocialInfoDTO, Error> {
        let endpoint = Endpoint(method: .GET,
                                paths: "/user/social")
            .setAccessToken()
        
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<SocialInfoDTO>.self,
                                         responseHandler: { res in
            guard (200...299).contains(res.statusCode) ||
                    res.statusCode == 401 else {
                throw CommonError.serverError
            }
        })
        .tryMap { response -> SocialInfoDTO in
            switch response.code {
            case 200:
                return response.result
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateFCMToken(fcmToken: String) async throws {
        let endpoint = Endpoint(method: .PATCH,
                                paths: "/user/fcm_token",
                                queries: ["fcmToken" : fcmToken])
            .setAccessToken()
        
        return try await session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<SocialInfoDTO>.self,
                                         responseHandler: { res in
            guard (200...299).contains(res.statusCode) else {
                throw CommonError.serverError
            }
        })
        .tryMap { response in
            switch response.code {
            case 200:
                break
            default:
                throw CommonError.otherError
            }
        }.asyncThrows
    }
    
    
}
