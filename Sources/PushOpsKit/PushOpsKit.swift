import Foundation

/**
 # Push API
 - warning: This is absolutley against the Push TOS. You will most likely get in trouble for using this from either Push or the App Store. You've been warned.
 This is a Swift wrapper around the internal iOS API that Push uses in their employee app. It inlcludes a login endpoint and can automatically manage session tokens. Very cool!
*/

public class PushOps {
    public private(set) var authKey: String
    public private(set) var userSettings: PushUserSettings
    public private(set) var companies: [Int: Company]
    
    internal var router: Router
    
    public init(authKey: String) async throws {
        self.authKey = authKey
        self.router = Router(authKey: authKey)
        
        // get userSettings so we can make sure we have the proper workplace codes.
        self.userSettings = try await router.getSettings()
        
        self.companies = [:]
        for companyDatum in userSettings.companyData {
            self.companies[companyDatum.companyID] = try await Company(router: router, companyData: companyDatum)
        }
    }
    
    /**
     This method will return the session token of the authenticated user.
     Full URL: `https://app-elb.pushoperations.com/api/v1/ios/login`
     */
    public static func auth(username: String, password: String) async throws -> PushUserSettings {
        return try await Router.auth(username: username, password: password)
    }
}
