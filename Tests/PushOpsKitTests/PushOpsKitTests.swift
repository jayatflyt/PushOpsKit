import XCTest
@testable import PushOpsKit

final class PushOpsKitTests: XCTestCase {
    func testAuthMethod() async throws {
//            let pushRouter = PushRouter()
            
            // Create an expectation for the async task
            let expectation = expectation(description: "Auth method expectation")
            
            do {
                let userData = try await PushRouter.auth(username: userName, password: passWord)
                
                // Check if a token is returned
                XCTAssertFalse(userData.token, "Token is empty")
                
                // Fulfill the expectation
                expectation.fulfill()
                
            } catch {
                // Handle any errors thrown during the auth method
                XCTFail("Failed with error: \(error.localizedDescription)")
            }
            
            // Wait for the expectation to be fulfilled or time out
            wait(for: [expectation], timeout: 5)
        }
}
