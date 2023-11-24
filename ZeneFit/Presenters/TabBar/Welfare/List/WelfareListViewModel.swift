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
    
    let items = ["1","2","3","4","5","6","7","8"]
    
    var error = PassthroughSubject<Error, Never>()
    var policyList = CurrentValueSubject<[PolicyInfoDTO], Never>([])
    @Published var selectedCategory: PolicyType = .none
    
    private var currentPage = 0
    private var isPaging: Bool = false
    private var isLastPage: Bool = false
    
    // usecase
    private let policyListUseCase: PolicyListUseCase
    
    init(coordinator: WelfareCoordinator? = nil,
         type: SupportPolicyType,
         policyListUseCase: PolicyListUseCase = .init()) {
        self.coordinator = coordinator
        self.type = type
        self.policyListUseCase = policyListUseCase
    }
    
    //TODO: API수정 요청 필요
    func getPolicyInfo() {
        policyListUseCase.getPolicyInfo(page: currentPage,
                                        supportPolicyType: type,
                                        policyType: selectedCategory)
        .sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished: break
            case .failure(let error):
                self?.error.send(error)
            }
        }, receiveValue: { [weak self] res in
            self?.policyList.send(res.content)
            self?.isLastPage = res.last
        }).store(in: &cancellable)
    }
    
    func didScroll(offsetY: CGFloat, contentHeight: CGFloat, frameHeight: CGFloat) {
        if offsetY > (contentHeight - frameHeight) {
            if self.isPaging == false && !isLastPage { self.paging() }
        }
    }
}

private extension WelfareListViewModel {
    func paging() {
        isPaging = true
        currentPage += 1
        policyListUseCase.getPolicyInfo(page: currentPage,
                                        supportPolicyType: type,
                                        policyType: selectedCategory)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.isPaging = false
                    self?.error.send(error)
                case .finished: break
                }
            }, receiveValue: { [weak self] res in
                self?.policyList.value.append(contentsOf: res.content)
                self?.isLastPage = res.last
                self?.isPaging = false
            }).store(in: &cancellable)
    }
}
