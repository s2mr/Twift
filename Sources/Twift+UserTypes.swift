import Foundation

public struct User: Codable, Identifiable {
  public typealias ID = String
  
  /// The unique identifier of this user.
  public let id: ID
  
  /// The name of the user, as they’ve defined it on their profile. Not necessarily a person’s name. Typically capped at 50 characters, but subject to change.
  public let name: String
  
  /// The Twitter screen name, handle, or alias that this user identifies themselves with. Usernames are unique but subject to change. Typically a maximum of 15 characters long, but some historical accounts may exist with longer names.
  public let username: String
  
  /// The UTC datetime that the user account was created on Twitter.
  public let createdAt: Date?
  
  /// Indicates if this user has chosen to protect their Tweets (in other words, if this user's Tweets are private).
  public let protected: Bool?
  
  /// Contains withholding details for withheld content, if applicable.
  public let withheld: WithheldInformation?
  
  /// The location specified in the user's profile, if the user provided one. As this is a freeform value, it may not indicate a valid location, but it may be fuzzily evaluated when performing searches with location queries.
  public let location: String?
  
  /// Unique identifier of this user's pinned Tweet.
  public let pinnedTweetId: Tweet.ID?
  
  /// The URL specified in the user's profile, if present.
  public let url: String?
  
  /// The text of this user's profile description (also known as bio), if the user provided one.
  public let description: String?
  
  /// Indicates if this user is a verified Twitter User.
  public let verified: Bool?
  
  /// Contains details about text that has a special meaning in the user's description.
  public let entities: Entities?
  
  /// The URL to the profile image for this user, as shown on the user's profile.
  public let profileImageUrl: URL?
  
  /// Contains details about activity for this user.
  public let publicMetrics: UserProfileMetrics?
}

extension User {
  public struct Includes: Codable {
    public let tweets: [Tweet]
  }
  
  public struct UserProfileMetrics: Codable {
    public let followersCount: Int
    public let followingCount: Int
    public let listedCount: Int
  }
  
  public struct Entities: Codable {
    public let url: URLEntity?
    public let description: DescriptionEntity?
  }
  
  public struct DescriptionEntity: Codable {
    public let urls: [URLEntityDetails]?
    public let hashtags: [TagEntity]?
    public let mentions: [MentionEntity]?
    public let cashtags: [TagEntity]?
  }
  
  public struct URLEntity: Codable {
    public let urls: [URLEntityDetails]?
  }
  
  public struct URLEntityDetails: EntityObject {
    public let start: Int
    public let end: Int
    public let url: String?
    public let expandedUrl: URL?
    public let displayUrl: String?
  }
}

protocol MappedKeyPath: CaseIterable {
  associatedtype T
  var keyPath: PartialKeyPath<T>? { get }
}

extension User: Fielded {
  /// Available additional fields for the ``User`` type
  public enum Fields: String, Codable, CaseIterable, Field {
    case created_at
    case description
    case entities
    case location
    case pinned_tweet_id
    case profile_image_url
    case protected
    case public_metrics
    case url
    case verified
    case withheld
    
    static let parameterName = "user.fields"
  }
}

extension User: Expandable {
  /// Available object expansions for the ``User`` type
  public enum Expansions: Expansion {
    case pinnedTweetId(tweetFields: Set<Tweet.Fields> = [])
    
    var fields: URLQueryItem? {
      switch self {
      case .pinnedTweetId(let tweetFields):
        if !tweetFields.isEmpty {
          return URLQueryItem(name: Tweet.Fields.parameterName, value: tweetFields.map(\.rawValue).joined(separator: ","))
        } else {
          return nil
        }
      }
    }
    
    var rawValue: String {
      switch self {
      case .pinnedTweetId(_):  return "pinned_tweet_id"
      }
    }
  }
}
