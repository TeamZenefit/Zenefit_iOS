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
                                         responseHandler: nil)
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


