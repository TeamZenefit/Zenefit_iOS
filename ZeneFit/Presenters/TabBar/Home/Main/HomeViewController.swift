//
//  HomeViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/10/22.
//

import UIKit

final class HomeViewController: BaseViewController {
    private let viewModel: HomeViewModel
    
    private let notiItem = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "alarm_off")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private let topBGView = UIImageView(image: .init(named: "img_bg"))
    
    private let nameLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .textNormal
        $0.font = .pretendard(.title1)
        $0.text = "상우님은\n부자되세요"
    }
    
    private let imageView = UIImageView(image: .init(named: "m-smart"))
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(KeychainManager.read("accessToken"))
    }
    
    override func setupBinding() {
        
    }
    
    override func configureUI() {
        view.backgroundColor = .backgroundPrimary
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIImageView(image: .init(named: "logotype")))
        navigationItem.standardAppearance?.backgroundColor = .backgroundPrimary
        navigationItem.scrollEdgeAppearance?.backgroundColor = .backgroundPrimary
        
        let manualItem = UIButton().then {
            $0.setImage(UIImage(named: "manual_on")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        manualItem.tapPublisher
            .sink { [weak self] in
                self?.viewModel.coordinator?.presentToMenual()
            }.store(in: &cancellable)

        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 8

        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: notiItem),
                                                   spacer,
                                                   UIBarButtonItem(customView: manualItem)]
    }
    
    override func addSubView() {
        [topBGView, nameLabel, imageView].forEach {
            view.addSubview($0)
        }
    }
    
    override func layout() {
        topBGView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view.snp.height).multipliedBy(0.1)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(40)
            $0.top.equalTo(topBGView.snp.bottom).offset(8)
        }
        
        imageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-40)
            $0.height.width.equalTo(120)
            $0.bottom.equalTo(nameLabel)
        }
    }
}
