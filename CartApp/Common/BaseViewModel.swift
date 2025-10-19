//
//  BaseViewModel.swift
//  CartApp
//
//  Created by Kacper Wysocki on 15/10/2025.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

enum ViewModelState: Equatable {
    case idle
    case loading
    case error(String = "Check your internet connection and try again")
}

class BaseViewModel {
    let state = BehaviorRelay<ViewModelState>(value: .idle)
    let disposeBag = DisposeBag()
}
