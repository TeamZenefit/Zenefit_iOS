//
//  BaseViewController.swift
//  ZeneFit
//
//  Created by iOS신상우 on 2023/09/28.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    private var keyboardCancellable: AnyCancellable?
    var cancellable = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        addSubView()
        
        configureNavigation()
        configureTabBar()
        layout()
        configureUI()
        setupBinding()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardCancellable?.cancel()
        keyboardCancellable = nil
    }
    
    func configureUI() {
        self.view.backgroundColor = .white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func addSubView() { }
    
    func layout() { }
    
    func configureNavigation() {
        self.navigationItem.hidesBackButton = true
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.shadowColor = .clear
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackButton")?.withRenderingMode(.alwaysOriginal),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(dldClickBackButton))
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func configureTabBar() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .white
        tabBarController?.tabBar.standardAppearance = tabBarAppearance
        tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearance
    }
    
    func setupAttributes() {
        
    }
    
    @objc func dldClickBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func responseToKeyboardHegiht(_ view: UIView) {
        keyboardCancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .sink { notification in
                guard let keyboardInfo = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)
                else { return }
                let visibleHeight = UIScreen.main.bounds.height - keyboardInfo.cgRectValue.origin.y
                
                let radius: CGFloat
                let height: CGFloat
                let inset: CGFloat
                if visibleHeight > 0  {
                    height = -visibleHeight + self.view.safeAreaInsets.bottom
                    radius = 0
                    inset = 0
                } else {
                    height = -20
                    radius = 8
                    inset = 16
                }
                
                view.layer.cornerRadius = radius
                view.snp.updateConstraints {
                    $0.horizontalEdges.equalToSuperview().inset(inset)
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(height)
                }
                
                self.view.layoutIfNeeded()
            }
    }
    
    func setupBinding() { }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
