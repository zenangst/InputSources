import Foundation
import XCTest
import InputSources

@MainActor
final class InputSourceControllerTests: XCTestCase {
  enum InputSourceIdentifier: String {
    case abc = "com.apple.keylayout.ABC"
    case english = "com.apple.keylayout.US"
    case swedish = "com.apple.keylayout.Swedish-Pro"
    case norwegian = "com.apple.keylayout.Norwegian"
  }

  var userSelectedInput: InputSource!

  override func setUp() async throws {
    try await super.setUp()
    userSelectedInput = try InputSourceController().currentInputSource()
  }

  override func tearDown() async throws {
    try await super.tearDown()
    try InputSourceController().select(userSelectedInput)
  }

  func testCurrentInputSource() throws {
    let currentInput = try InputSourceController().currentInputSource()

    XCTAssertEqual(currentInput, userSelectedInput)
  }

  func testFetchInputSources() {
    let inputSources = InputSourceController()
      .fetchInputSources(includeAllInstalled: false)

    XCTAssertFalse(inputSources.isEmpty)
    XCTAssertTrue(inputSources.contains(userSelectedInput))
  }

  func testIsInstalled() {
    XCTAssertTrue(InputSourceController().isInstalled(userSelectedInput))
  }

  func testInstallSelectUninstallInputSource() throws {
    let controller = InputSourceController()
    var abcSource = try controller
      .findInput(InputSourceIdentifier.abc.rawValue,
                 includeAllInstalled: true)

    if controller.isInstalled(abcSource) {
      try controller.uninstall(abcSource)
    }

    XCTAssertFalse(controller.isInstalled(abcSource))

    try controller.install(abcSource)
    try controller.select(abcSource)

    abcSource = try controller
      .findInput(InputSourceIdentifier.abc.rawValue,
                 includeAllInstalled: false)
    let currentInputSource = try controller.currentInputSource()
    XCTAssertEqual(currentInputSource, abcSource)

    try controller.uninstall(abcSource)
  }
}

