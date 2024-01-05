//
//  BookmarkViewModel.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/30.
//

import Foundation
import Combine

final class BookmarkViewModel {
    private var cancellable = Set<AnyCancellable>()
    weak var coordinator: HomeCoordinator?
    
    @Published var isEditMode: Bool = false
    @Published var totalPolicy: Int = 0
    
    var error = PassthroughSubject<Error, Never>()
    var bookmarkList = CurrentValueSubject<[BookmarkPolicy], Never>([])
    
    private let bookmarkPolicyUseCase: BookmarkPolicyUseCase
    private let deleteBookmark: RemoveInterestPolicyUseCase
    
    private var currentPage = 0
    private var isPaging: Bool = false
    private var isLastPage: Bool = false
    
    init(coordinator: HomeCoordinator? = nil,
         bookmarkPolicyUseCase: BookmarkPolicyUseCase = .init(),
         deleteBookmark: RemoveInterestPolicyUseCase = .init()) {
        self.coordinator = coordinator
        self.bookmarkPolicyUseCase = bookmarkPolicyUseCase
        self.deleteBookmark = deleteBookmark
    }
    
    func getBookmarkList() {
        currentPage = 0
        bookmarkPolicyUseCase.getBookmarkPolicyList(page: currentPage)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error.send(error)
                case .finished: break
                }
            }, receiveValue: { [weak self] res in
                self?.bookmarkList.send(res.content)
                self?.totalPolicy = res.totalElements
                self?.isLastPage = res.last
                self?.isPaging = false
            }).store(in: &cancellable)
    }
    
    func deleteBookmark(policyId: Int?) {
        Task {
            do {
                try await deleteBookmark.execute(policyId: policyId)
                
                if policyId == nil {
                    totalPolicy = 0
                    bookmarkList.send([])
                } else {
                    bookmarkList.value.removeAll(where: { $0.policyID == policyId })
                    totalPolicy = bookmarkList.value.count
                }
            } catch {
                self.error.send(error)
            }
        }
    }
    
    func didScroll(offsetY: CGFloat, contentHeight: CGFloat, frameHeight: CGFloat) {
        if offsetY != 0 && offsetY > (contentHeight - frameHeight) {
            if self.isPaging == false && !isLastPage { self.paging() }
        }
    }
}

private extension BookmarkViewModel {
    func paging() {
        isPaging = true
        currentPage += 1
        bookmarkPolicyUseCase.getBookmarkPolicyList(page: currentPage)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.isPaging = false
                    self?.error.send(error)
                case .finished: break
                }
            }, receiveValue: { [weak self] res in
                guard let self else { return }
                
                let newBookmakrList = bookmarkList.value + res.content
                bookmarkList.send(newBookmakrList)
                totalPolicy = res.totalElements
                isLastPage = res.last
                isPaging = false
            }).store(in: &cancellable)
    }
}
