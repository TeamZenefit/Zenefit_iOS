//
//  PolicyService.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import Foundation
import Combine

class PolicyService {
    private let session: URLSessionable
    
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
    
    func getRecommendWelfareList() -> AnyPublisher<RecommendWelFareDTO, Error> {
        let endpoint = Endpoint(method: .GET,
                                paths: "/policy/recommend/count")
            .setAccessToken()
    
            
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<RecommendWelFareDTO>.self,
                                         responseHandler: nil)
        .tryMap { response -> RecommendWelFareDTO in
            switch response.code {
            case 200:
                return response.result
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getBookmarkPolicyList(page: Int) -> AnyPublisher<BookmarkPolicyListDTO, Error> {
        let endpoint = Endpoint(method: .GET,
                                paths: "/user/policy",
                                queries: ["page" : "\(page)",
                                            "size" : "\(10)"])
            .setAccessToken()
    
            
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<BookmarkPolicyListDTO>.self,
                                         responseHandler: nil)
        .tryMap { response -> BookmarkPolicyListDTO in
            switch response.code {
            case 200:
                return response.result
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getBenefitPolicyList(page: Int) -> AnyPublisher<BenefitPolicyListDTO, Error> {
        let endpoint = Endpoint(method: .GET,
                                paths: "/user/policy/apply",
                                queries: ["page" : "\(page)",
                                            "size" : "\(7)"])
            .setAccessToken()
    
            
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<BenefitPolicyListDTO>.self,
                                         responseHandler: nil)
        .tryMap { response -> BenefitPolicyListDTO in
            switch response.code {
            case 200:
                return response.result
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getWelfareMainInfo() -> AnyPublisher<WelfareMainInfoDTO, Error> {
        let endpoint = Endpoint(method: .GET,
                                paths: "/policy/recommend")
            .setAccessToken()
    
            
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<WelfareMainInfoDTO>.self,
                                         responseHandler: nil)
        .tryMap { response -> WelfareMainInfoDTO in
            switch response.code {
            case 200:
                return response.result
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getPolicyInfo(page: Int,
                       supportPolicyType: SupportPolicyType,
                       policyType: PolicyType,
                       sortType: WelfareSortType,
                       keyword: String) -> AnyPublisher<PolicyListDTO, Error> {
        let query: [String : String] = ["page" : "\(page)",
                                        "size" : "\(10)",
                                        "sortField" : sortType.rawValue,
                                        "sortOrder" : "asc"]
        
        let parameter: [String : Any] = [
            "supportPolicyType" : supportPolicyType.rawValue,
            "policyType" : policyType.rawValue,
            "keyword" : keyword]
        
        
        let endpoint = Endpoint(method: .POST,
                                paths: "/policy/search",
                                queries: query,
                                body: parameter) // TODO: 수정
            .setAccessToken()
    
            
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<PolicyListDTO>.self,
                                         responseHandler: nil)
        .tryMap { response -> PolicyListDTO in
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
    
    func getPolicyInfo(page: Int,
                       supportPolicyType: SupportPolicyType,
                       policyType: PolicyType,
                       sortType: WelfareSortType) -> AnyPublisher<PolicyListDTO, Error> {
        let query: [String : String] = ["page" : "\(page)",
                                        "size" : "\(10)",
                                        "sortField" : sortType.rawValue,
                                        "sortOrder" : "asc"]
        
        let parameter: [String : Any] = [
            "supportPolicyType" : supportPolicyType.rawValue,
            "policyType" : policyType.rawValue]
        
        let endpoint = Endpoint(method: .POST,
                                paths: "/policy",
                                queries: query,
                                body: parameter) // TODO: 수정
            .setAccessToken()
    
            
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<PolicyListDTO>.self,
                                         responseHandler: nil)
        .tryMap { response -> PolicyListDTO in
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
    
    
    func getPolicyDetailInfo(policyId: Int) -> AnyPublisher<PolicyDetailDTO, Error> {
        let endpoint = Endpoint(method: .GET,
                                paths: "/policy/\(policyId)")
            .setAccessToken()
    
            
        return session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<PolicyDetailDTO>.self,
                                         responseHandler: nil)
        .tryMap { response -> PolicyDetailDTO in
            switch response.code {
            case 200:
                return response.result
            default:
                throw CommonError.otherError
            }
        }
        .eraseToAnyPublisher()
    }
    
    func addInterestPolicy(policyId: Int) async throws -> Bool {
        let endpoint = Endpoint(method: .POST,
                                paths: "user/policy/\(policyId)")
            .setAccessToken()
    
            
        return try await session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<Bool?>.self) { res in
            if res.statusCode == 401 {
                throw CommonError.alreadyInterestingPolicy
            }     
        }
        .tryMap { response -> Bool in
            switch response.code {
            case 200:
                return true
            case 4002:
                return false
            default:
                throw CommonError.otherError
            }
        }.asyncThrows
    }
    
    func removeInterestPolicy(policyId: Int) async throws -> Bool {
        let endpoint = Endpoint(method: .DELETE,
                                paths: "user/policy/\(policyId)")
            .setAccessToken()
    
            
        return try await session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<Bool?>.self) { res in
        }
        .tryMap { response -> Bool in
            switch response.code {
            case 200:
                return true
            case 4002:
                return false
            default:
                throw CommonError.otherError
            }
        }.asyncThrows
    }
    
    func addApplyingPolicy(policyId: Int) async throws -> Bool {
        let endpoint = Endpoint(method: .POST,
                                paths: "user/policy/apply/\(policyId)")
            .setAccessToken()
    
            
        return try await session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<Bool?>.self) { res in
            if res.statusCode == 401 {
                throw CommonError.alreadyInterestingPolicy
            }
        }
        .tryMap { response -> Bool in
            switch response.code {
            case 200:
                return true
            case 4002:
                return false
            default:
                throw CommonError.otherError
            }
        }.asyncThrows
    }
    
    func removeApplyingPolicy(policyId: Int) async throws -> Bool {
        let endpoint = Endpoint(method: .DELETE,
                                paths: "user/policy/apply/\(policyId)")
            .setAccessToken()
    
            
        return try await session.dataTaskPublisher(urlRequest: endpoint.request,
                                         expect: BaseResponse<Bool?>.self) { res in
        }
        .tryMap { response -> Bool in
            switch response.code {
            case 200:
                return true
            case 4002:
                return false
            default:
                throw CommonError.otherError
            }
        }.asyncThrows
    }
}
