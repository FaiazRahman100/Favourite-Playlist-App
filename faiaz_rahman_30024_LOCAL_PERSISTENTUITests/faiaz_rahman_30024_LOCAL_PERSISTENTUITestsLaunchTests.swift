//
//  faiaz_rahman_30024_LOCAL_PERSISTENTUITestsLaunchTests.swift
//  faiaz_rahman_30024_LOCAL_PERSISTENTUITests
//
//  Created by Faiaz Rahman on 8/1/23.
//

import XCTest

final class faiaz_rahman_30024_LOCAL_PERSISTENTUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
