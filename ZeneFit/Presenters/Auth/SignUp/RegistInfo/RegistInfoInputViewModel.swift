//
//  BasicInfoViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/01.
//

import Foundation
import Combine

final class RegistInfoInputViewModel {
    private var cancellable = Set<AnyCancellable>()
    
    @Published var signUpInfo = SignUpInfo()
    @Published var focusInputNumber = 1
    
    @Published var completionEnable = false
    @Published var cities: [String] = []
    @Published var areas: [String] = []
    
    private let fetchCityUseCase: FetchCityUseCase
    private let fetchAreaUseCase: FetchAreaUseCase
    
    init(fetchCityUseCase: FetchCityUseCase = .init(),
         fetchAreaUseCase: FetchAreaUseCase = .init()) {
        self.fetchCityUseCase = fetchCityUseCase
        self.fetchAreaUseCase = fetchAreaUseCase
        
        bind()
        
        fetchAreaUseCase.execute()
            .replaceError(with: [])
            .assign(to: \.areas, on: self)
            .store(in: &cancellable)
    }
    
    private func bind() {
        $signUpInfo
            .map {
                let age = $0.age ?? ""
                let area = $0.area ?? ""
                let city = $0.city ?? ""
                let income = $0.income ?? ""
                let education = $0.education ?? ""
                let job = $0.job ?? []
                switch self.focusInputNumber {
                case 1,2,3:
                    return age.isNotEmpty && city.isNotEmpty && area.isNotEmpty
                case 4:
                    return age.isNotEmpty && city.isNotEmpty && area.isNotEmpty && income.isNotEmpty
                default:
                    return age.isNotEmpty && city.isNotEmpty && area.isNotEmpty && income.isNotEmpty && education.isNotEmpty && job.isNotEmpty
                }
            }
            .eraseToAnyPublisher()
            .assign(to: \.completionEnable, on: self)
            .store(in: &cancellable)
    }
    
    func fetchCities() {
        guard let area = signUpInfo.area else { return }
        fetchCityUseCase.execute(area: area)
            .replaceError(with: [String]())
            .assign(to: \.cities, on: self)
            .store(in: &cancellable)
    }
    
    func cacluateFocus() {
        let age = signUpInfo.age ?? ""
        let area = signUpInfo.area ?? ""
        let city = signUpInfo.city ?? ""
        let income = signUpInfo.income ?? ""
        let education = signUpInfo.education ?? ""
        let job = signUpInfo.job ?? []
        
        if age.isEmpty {
            focusInputNumber = 1
        } else if area.isEmpty {
            focusInputNumber = 2
        } else if city.isEmpty {
            focusInputNumber = 3
        } else if income.isEmpty {
            focusInputNumber = 4
        } else if education.isEmpty{
            focusInputNumber = 5
        } else if job.isEmpty {
            focusInputNumber = 6
        } else {
            focusInputNumber = 7
        }
    }
}
