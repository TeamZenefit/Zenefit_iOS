//
//  PersonalInfoEditViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 1/7/24.
//

import Foundation
import Combine

class PersonalInfoEditViewModel {
    private var cancellable = Set<AnyCancellable>()
    weak var coordinator: SettingCoordinator?
    
    var personalInfoItems = PersonalInfoItem.allCases
    var otherInfoItems = OtherInfoItem.allCases
    
    var errorPublisher = PassthroughSubject<Error, Never>()
    var newUserInfo = CurrentValueSubject<UserInfoDTO?, Never>(nil)
    var currentUserInfo: UserInfoDTO
    var updateSuccess = PassthroughSubject<Void, Never>()
    
    @Published var cities: [String] = []
    @Published var areas: [String] = []
    
    // usecase
    private let fetchCity: FetchCityUseCase
    private let fetchArea: FetchAreaUseCase
    private let updateUserInfoUseCase: UpdateUserInfoUseCase
    
    init(cooridnator: SettingCoordinator? = nil,
         currentUserInfo: UserInfoDTO,
         fetchCity: FetchCityUseCase = .init(),
         fetchArea: FetchAreaUseCase = .init(),
         updateUserInfoUseCase: UpdateUserInfoUseCase = .init()) {
        self.coordinator = cooridnator
        self.currentUserInfo = currentUserInfo
        self.fetchCity = fetchCity
        self.fetchArea = fetchArea
        self.updateUserInfoUseCase = updateUserInfoUseCase
        
        newUserInfo.send(currentUserInfo)
        
        fetchArea.execute()
            .replaceError(with: [])
            .assign(to: \.areas, on: self)
            .store(in: &cancellable)
        
        fetchCity.execute(area: newUserInfo.value?.area ?? "")
            .replaceError(with: [])
            .assign(to: \.cities, on: self)
            .store(in: &cancellable)
        
        
        newUserInfo
            .removeDuplicates(by: {
                $0?.area == $1?.area
            })
            .dropFirst()
            .sink { [weak self] area in
                self?.fetchCities()
                self?.newUserInfo.value?.city = ""
            }.store(in: &cancellable)
    }
    
    func fetchCities() {
        guard let area = newUserInfo.value?.area else { return }
        fetchCity.execute(area: area)
            .replaceError(with: [String]())
            .assign(to: \.cities, on: self)
            .store(in: &cancellable)
    }
    
    func updateUserInfo() {
        guard let newUserInfo = newUserInfo.value else { return }
        
        if newUserInfo.age <= 0 || newUserInfo.age > 99 {
            errorPublisher.send(CommonError.invalidAge)
            return
        }
        
        if newUserInfo.lastYearIncome <= 0 || newUserInfo.lastYearIncome > 9999990000 {
            errorPublisher.send(CommonError.invalidIncome)
            return
        }
        
        if newUserInfo.city.isEmpty {
            errorPublisher.send(CommonError.emptyCity)
            return
        }
        
        updateUserInfoUseCase.execute(newUserInfo: newUserInfo)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorPublisher.send(error)
                }
            }, receiveValue: { [weak self] _ in
                self?.updateSuccess.send()
            }).store(in: &cancellable)
    }
}
