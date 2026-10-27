import Testing
@testable import DownloadKit

@Test func versionIsSet() {
    #expect(!DownloadKit.version.isEmpty)
}
