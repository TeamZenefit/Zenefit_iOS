//
//  HomeRepositable.swift
//  ZeneFit
//
//  Created by iOS신상우 on 11/12/23.
//

import Foundation
import Combine

protocol HomeRepositoryProtocol {
    func fetchHomeInfo() -> AnyPublisher<HomeInfoDTO, Error>
}
