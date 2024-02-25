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
                                         expect: BaseResponse<Bool?>.self,
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
    
    func unregistUser() async throws {
        let endpoint = Endpoint(method: .DELETE,
                                paths: "/user")
            .setAccessToken()
        
        return try await session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<Bool?>.self,
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
    
    func getNotification(page: Int, dateType: NotiDateType) -> AnyPublisher<NotificationDTO, Error> {
        let parameter: [String : String] = [
            "size" : "10",
            "page" : "\(page)",
            "searchDateType" : dateType.rawValue
        ]
        
        let endpoint = Endpoint(method: .GET,
                                paths: "/notify",
                                queries: parameter)
            .setAccessToken()
        
        LoadingIndicatorView.showLoading()
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<NotificationDTO>.self,
                                         responseHandler: { res in
            LoadingIndicatorView.hideLoading()
            guard (200...299).contains(res.statusCode) ||
                    res.statusCode == 401 else {
                throw CommonError.serverError
            }
        })
        .tryMap { response -> NotificationDTO in
            LoadingIndicatorView.hideLoading()
            switch response.code {
            case 200:
                return response.result
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getNotificationStatus() -> AnyPublisher<NotificationStatusDTO, Error> {
        let endpoint = Endpoint(method: .GET,
                                paths: "/user/notification")
            .setAccessToken()
        
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<NotificationStatusDTO>.self,
                                         responseHandler: nil)
        .tryMap { response -> NotificationStatusDTO in
            switch response.code {
            case 200:
                return response.result
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateNotificationStatus(isAllow: Bool) -> AnyPublisher<Void, Error> {
        let parameter: [String : String] = [
            "pushNotificationStatus" : "\(isAllow)"
        ]
        let endpoint = Endpoint(method: .PATCH,
                                paths: "/user/notification",
                                queries: parameter)
            .setAccessToken()
        
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<String?>.self,
                                         responseHandler: nil)
        .tryMap { response -> Void in
            switch response.code {
            case 200:
                break
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getAgreementInfo() -> AnyPublisher<AgreementInfoDTO, Error> {
        let endpoint = Endpoint(method: .GET,
                                paths: "/user/privacy")
            .setAccessToken()
        
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<AgreementInfoDTO>.self,
                                         responseHandler: nil)
        .tryMap { response -> AgreementInfoDTO in
            switch response.code {
            case 200:
                response.result
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateUserInfo(newUserInfo: UserInfoDTO) -> AnyPublisher<UserInfoUpdateDTO, Error> {
        let parameter = newUserInfo.toEncodable
        let endpoint = Endpoint(method: .PATCH,
                                paths: "/user/modify",
                                bodyWithEncodable: parameter)
            .setAccessToken()
        
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<UserInfoUpdateDTO>.self,
                                         responseHandler: nil)
        .tryMap { response -> UserInfoUpdateDTO in
            switch response.code {
            case 200:
                response.result
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
}
