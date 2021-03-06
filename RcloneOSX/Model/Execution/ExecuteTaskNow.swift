//
//  ExecuteTaskNow.swift
//  rcloneosx
//
//  Created by Thomas Evensen on 22/08/2019.
//  Copyright © 2019 Thomas Evensen. All rights reserved.
//
// swiftlint:disable line_length

import Foundation

protocol DeinitExecuteTaskNow: AnyObject {
    func deinitexecutetasknow()
}

final class ExecuteTaskNow: SetConfigurations {
    weak var setprocessDelegate: SendOutputProcessreference?
    weak var startstopindicators: StartStopProgressIndicatorSingleTask?
    weak var deinitDelegate: DeinitExecuteTaskNow?
    var outputprocess: OutputProcess?
    var index: Int?

    init(index: Int) {
        self.index = index
        self.setprocessDelegate = ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllerMain
        self.startstopindicators = ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllerMain
        self.deinitDelegate = ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllerMain
        if let arguments = self.configurations?.arguments4rclone(index: index, argtype: .arg) {
            let process = Rclone(arguments: arguments)
            self.outputprocess = OutputProcess()
            process.setdelegate(object: self)
            process.executeProcess(outputprocess: self.outputprocess)
            self.startstopindicators?.startIndicatorExecuteTaskNow()
            self.setprocessDelegate?.sendoutputprocessreference(outputprocess: self.outputprocess)
        }
    }
}

extension ExecuteTaskNow: UpdateProgress {
    func processTermination() {
        self.startstopindicators?.stopIndicator()
        if let index = self.index {
            self.configurations?.setCurrentDateonConfiguration(index: index, outputprocess: self.outputprocess)
        }
        self.deinitDelegate?.deinitexecutetasknow()
    }

    func fileHandler() {
        weak var outputeverythingDelegate: ViewOutputDetails?
        outputeverythingDelegate = ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllerMain
        if outputeverythingDelegate?.appendnow() ?? false {
            outputeverythingDelegate?.reloadtable()
        }
    }
}
