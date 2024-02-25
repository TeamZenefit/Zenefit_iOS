//
//  WelfareListViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/05.
//

import Foundation
import Combine

final class WelfareListViewModel {
    private var cancellable = Set<AnyCancellable>()
    weak var coordinator: WelfareCoordinator?
    
    let type: SupportPolicyType
    let categories = PolicyType.allCases
    
    var error = PassthroughSubject<Error, Never>()
    var policyList = CurrentValueSubject<[PolicyInfoDTO], Never>([])
    
    var keyword = CurrentValueSubject<String, Never>("")
    var sortType = CurrentValueSubject<WelfareSortType, Never>(.applyEndDate)
    var selectedCategory = CurrentValueSubject<PolicyType, Never>(.none)
    var showSkeleton = PassthroughSubject<Bool, Never>()
    
    private var currentPage = 0
    private var isPaging: Bool = false
    private var isLastPage: Bool = false
    
    // usecase
    private let policyListUseCase: PolicyListUseCase
    private let addInterestPolicyUseCase: AddInterestPolicyUseCase
    private let removeInterestPolicyUseCase: RemoveInterestPolicyUseCase
    private let addApplyingPolicyUseCase: AddApplyingPolicyUseCase
    private let removeApplyingPolicyUseCase: RemoveApplyingPolicyUseCase
    
    init(coordinator: WelfareCoordinator? = nil,
         type: SupportPolicyType,
         policyListUseCase: PolicyListUseCase = .init(),
         removeInterestPolicyUseCase: RemoveInterestPolicyUseCase = .init(),
         addInterestPolicyUseCase: AddInterestPolicyUseCase = .init(),
         addApplyingPolicyUseCase: AddApplyingPolicyUseCase = .init(),
         removeApplyingPolicyUseCase: RemoveApplyingPolicyUseCase = .init()
    ) {
        self.coordinator = coordinator
        self.type = type
        self.policyListUseCase = policyListUseCase
        self.removeInterestPolicyUseCase = removeInterestPolicyUseCase
        self.addInterestPolicyUseCase = addInterestPolicyUseCase
        self.removeApplyingPolicyUseCase = removeApplyingPolicyUseCase
        self.addApplyingPolicyUseCase = addApplyingPolicyUseCase
        
        bind()
    }
    
    private func bind() {
        sortType
            .dropFirst()
            .sink { [weak self] _ in
                self?.getPolicyInfo()
            }.store(in: &cancellable)
        
        selectedCategory
            .dropFirst()
            .sink { [weak self] _ in
                self?.getPolicyInfo()
            }.store(in: &cancellable)
    }
    
    func getPolicyInfo() {
        showSkeleton.send(true)
        policyListUseCase.getPolicyInfo(page: currentPage,
                                        supportPolicyType: type,
                                        policyType: selectedCategory.value,
                                        sortType: sortType.value,
                                        keyword: keyword.value)
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished: break
            case .failure(let error):
                self?.error.send(error)
                self?.showSkeleton.send(false)
            }
        }, receiveValue: { [weak self] res in
            self?.policyList.send(res.policyListInfoResponseDto.content)
            self?.isLastPage = res.last
            self?.showSkeleton.send(false)
        }).store(in: &cancellable)
    }
    
    func didScroll(offsetY: CGFloat, contentHeight: CGFloat, frameHeight: CGFloat) {
        if offsetY > 0 && offsetY > (contentHeight - frameHeight) {
            if self.isPaging == false && !isLastPage { self.paging() }
        }
    }
    
    @discardableResult
    func addInterestPolicy(policyId: Int) async throws -> Bool {
        let isSuccess = try await addInterestPolicyUseCase.execute(policyId: policyId)
        policyList.value.filter { $0.policyId == policyId }.first?.interestFlag = true
        
        return isSuccess
    }
    
    @discardableResult
    func removeInterestPolicy(policyId: Int) async throws -> Bool {
        let isSuccess = try await removeInterestPolicyUseCase.execute(policyId: policyId)
        policyList.value.filter { $0.policyId == policyId }.first?.interestFlag = false
        
        return isSuccess
    }
    
    @discardableResult
    func addApplyingPolicy(policyId: Int) async throws -> Bool {
        let isSuccess = try await addApplyingPolicyUseCase.execute(policyId: policyId)
        policyList.value.filter { $0.policyId == policyId }.first?.applyFlag = true
        
        return isSuccess
    }
    
    @discardableResult
    func removeApplyingPolicy(policyId: Int) async throws -> Bool {
        let isSuccess = try await removeApplyingPolicyUseCase.execute(policyId: policyId)
        policyList.value.filter { $0.policyId == policyId }.first?.applyFlag = false
        
        return isSuccess
    }
}

private extension WelfareListViewModel {
    func paging() {
        showSkeleton.send(true)
        isPaging = true
        currentPage += 1
        policyListUseCase.getPolicyInfo(page: currentPage,
                                        supportPolicyType: type,
                                        policyType: selectedCategory.value,
                                        sortType: sortType.value,
                                        keyword: keyword.value)
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.isPaging = false
                self?.error.send(error)
                self?.showSkeleton.send(false)
            case .finished: break
            }
        }, receiveValue: { [weak self] res in
            self?.showSkeleton.send(false)
            self?.policyList.value.append(contentsOf: res.policyListInfoResponseDto.content)
            self?.isLastPage = res.last
            self?.isPaging = false
        }).store(in: &cancellable)
    }
}
