//
//  HomeService.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/12/23.
//

import Foundation
import Combine

final class HomeService {
    private let session: URLSessionable
    
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
    
    func fetchHomeInfo() -> AnyPublisher<HomeInfoDTO, Error> {
        let endpoint = Endpoint(method: .GET,
                                paths: "/user/home")
            .setAccessToken()
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<HomeInfoDTO>.self,
                                         responseHandler: { response in
            switch response.statusCode {
                
            case 401:
                KeychainManager.delete(key: ZFKeyType.userId.rawValue)
                KeychainManager.delete(key: ZFKeyType.refreshToken.rawValue)
                KeychainManager.delete(key: ZFKeyType.accessToken.rawValue)
                
                DispatchQueue.main.async {
                    let tabBarCoordinator = SceneDelegate.mainCoordinator?.childCoordinators.first { $0 is TabBarCoordinator }
                    let homeCoordinator = tabBarCoordinator?.childCoordinators.first { $0 is HomeCoordinator }
                    homeCoordinator?.finish()   
                }
                
                throw CommonError.invalidJWT
            default: break
            }
        })
        .tryMap { response -> HomeInfoDTO in
            switch response.code {
            case 200:
                return response.result
            case 500...599:
                throw CommonError.serverError
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
}


