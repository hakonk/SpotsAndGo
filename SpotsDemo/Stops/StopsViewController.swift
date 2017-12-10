//
//  ViewController.swift
//  SpotsDemo
//
//  Created by Håkon Knutzen on 10/12/2017.
//  Copyright © 2017 Håkon Knutzen. All rights reserved.
//

import UIKit
import Foundation
import Spots

final class StopsViewController: SpotsController {


    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAndDisplay()
//        reloadIfNeeded(viewModel.components, withAnimation: .none, completion: completion)
    }

    private func fetchAndDisplay() {
        let webService = WebService(url: "http://127.0.0.1:8080/v1/renderedStops/")
        webService.fetch { [weak self] (result: RequestResult<StopsComponentModel>) in
            switch result {
            case .success(let model):
                self?.display(model: model)
            case .failure(let error):
                print(error)
            }
        }
    }

    private func display(model: StopsComponentModel) {

    }


}

