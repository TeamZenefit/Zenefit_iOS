//
//  BenefitViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/11/02.
//

import Foundation
import Combine

final class BenefitViewModel {
    private var cancellable = Set<AnyCancellable>()
    weak var coordinator: HomeCoordinator?
    
    @Published var isEditMode: Bool = false
    @Published var totalPolicy: Int = 0
    
    var error = PassthroughSubject<Error, Never>()
    var policyList = CurrentValueSubject<[BenefitPolicy], Never>([])
    
    private let benefitPolicyUseCase: BenefitPolicyUseCase
    private let deleteApplyUseCase: RemoveApplyingPolicyUseCase
    
    private var currentPage = 0
    private var isPaging: Bool = false
    private var isLastPage: Bool = false
    
    init(coordinator: HomeCoordinator? = nil,
         benefitPolicyUseCase: BenefitPolicyUseCase = .init(),
         deleteApplyUseCase: RemoveApplyingPolicyUseCase = .init()) {
        self.coordinator = coordinator
        self.deleteApplyUseCase = deleteApplyUseCase
        self.benefitPolicyUseCase = benefitPolicyUseCase
    }
    
    func getbenefitList() {
        benefitPolicyUseCase.getBenefitPolicyList(page: currentPage)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.isPaging = false
                    self?.error.send(error)
                case .finished: break
                }
            }, receiveValue: { [weak self] res in
                self?.policyList.send(res.content)
                self?.totalPolicy = res.totalElements
                self?.isLastPage = res.last
                self?.isPaging = false
            }).store(in: &cancellable)
    }
    
    func deleteApplying(policyId: Int?) {
        Task {
            do {
                try await deleteApplyUseCase.execute(policyId: policyId)
                policyList.value.removeAll(where: { $0.policyID == policyId })
                if policyId == nil {
                    totalPolicy = 0
                } else {
                    totalPolicy -= 1
                }
            } catch {
                self.error.send(error)
            }
        }
    }
    
    
    func didScroll(offsetY: CGFloat, contentHeight: CGFloat, frameHeight: CGFloat) {
        if offsetY > (contentHeight - frameHeight) {
            if self.isPaging == false && !isLastPage { self.paging() }
        }
    }
}

private extension BenefitViewModel {
    func paging() {
        isPaging = true
        currentPage += 1
        benefitPolicyUseCase.getBenefitPolicyList(page: currentPage)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error.send(error)
                case .finished: break
                }
            },
                  receiveValue: { [weak self] res in
                self?.policyList.value.append(contentsOf: res.content)
                self?.totalPolicy = res.totalElements
                self?.isLastPage = res.last
                self?.isPaging = false
            }).store(in: &cancellable)
    }
}
