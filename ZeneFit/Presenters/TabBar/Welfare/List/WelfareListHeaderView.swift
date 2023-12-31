//
//  WelfareListHeaderView.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/29/23.
//

import UIKit
import Combine

final class WelfareListHeaderView: BaseView {
    private var cancellable = Set<AnyCancellable>()
    var updateHeightHandler: (()->Void)?
    lazy var searchBar = WelfareSearchBar().then {
        $0.searchTextField.attributedPlaceholder = .init(string: "찾으시려는 복지를 검색하세요.",
                                                         attributes: [.foregroundColor : UIColor.textAlternative,
                                                                      .font : UIFont.pretendard(.body1)])
    }
    
    lazy var categoryCollectionView = UICollectionView(frame: .zero,
                                                            collectionViewLayout: createLayout()).then {
        $0.showsHorizontalScrollIndicator = false
        $0.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        $0.backgroundColor = .white
        $0.bounces = false
    }
    
    let sortButton = WelfareSortButton(title: "수혜금액")
    
    private let sortContentView = WelfareSortContentView().then {
        $0.backgroundColor = .backgroundPrimary
    }
    
    override func setupBinding() {
        sortContentView.$selectedSortType
            .receive(on: RunLoop.main)
            .sink { [weak self] type in
                self?.sortButton.title = type.description
            }.store(in: &cancellable)
        
        sortButton.tapPublisher
            .sink { [weak self] _ in
                self?.sortContentView.isOpen.toggle()
            }.store(in: &cancellable)
        
        sortContentView.$isOpen
            .sink { [weak self] isOpen in
                let image: UIImage? = isOpen ? .init(named: "i-fol-20") : .init(named: "i-op-20")
                self?.sortButton.configuration?.image = image
            }.store(in: &cancellable)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateHeightHandler?()
    }
    
    override func addSubView() {
        [searchBar, categoryCollectionView, sortButton, sortContentView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.height.equalTo(40)
        }
        
        sortButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(8)
            $0.height.equalTo(32)
        }
        
        sortContentView.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.top.equalTo(sortButton.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(12)
        }
    }
}

extension WelfareListHeaderView {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        return layout
    }
}
