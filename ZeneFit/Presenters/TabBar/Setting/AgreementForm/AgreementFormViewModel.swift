//
//  AgreementFormViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/3/23.
//

import Foundation
import Combine

final class AgreementFormViewModel {
    private var cancellable = Set<AnyCancellable>()
    weak var coordinator: SettingCoordinator?
    
    @Published var agreementInfo = AgreementInfoDTO.init(termsOfServiceDate: "",
                                                         privacyDate: "",
                                                         marketingDate: "",
                                                         termsOfServiceUrl: "",
                                                         privacyUrl: "",
                                                         marketingUrl: "")
    
    // usecase
    private let getAgreementInfoUseCase: GetAgreementInfoUseCase
    
    init(coordinator: SettingCoordinator? = nil,
         getAgreementInfoUseCase: GetAgreementInfoUseCase = .init()) {
        self.coordinator = coordinator
        self.getAgreementInfoUseCase = getAgreementInfoUseCase
    }
    
    func getAgreement() {
        getAgreementInfoUseCase.execute()
            .sink(receiveCompletion: { completion in
                if case let  .failure(error) = completion {
                    print(error)
                }
            }, receiveValue: { [weak self] info in
                self?.agreementInfo = info
            }).store(in: &cancellable)
    }
}
