import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Array "mo:base/Array";
import Iter "mo:base/Iter";

actor {

  // Type aliases
  type UserId = Text;
  type CompetitionId = Nat;

  // User definition
  type User = {
    name : Text;
    joinedCompetitions : [CompetitionId];
  };

  // Competition definition
  type Competition = {
    id : CompetitionId;
    title : Text;
    description : Text;
    organizer : UserId;
  };

  // Data storage
  stable var userMap = HashMap.HashMap<UserId, User>(10, Text.equal, Text.hash);
  stable var competitionMap = HashMap.HashMap<CompetitionId, Competition>(10, Nat.equal, Nat.hash);
  stable var nextCompetitionId : Nat = 0;

  // Register a new user
  public func registerUser(id : UserId, name : Text) : async Text {
    if (userMap.get(id) != null) {
      return "User already exists.";
    };

    let newUser : User = {
      name = name;
      joinedCompetitions = [];
    };
    userMap.put(id, newUser);
    return "User registered.";
  };

  // Create a new competition
  public func createCompetition(organizer : UserId, title : Text, description : Text) : async CompetitionId {
    switch (userMap.get(organizer)) {
      case (null) {
        Debug.print("Organizer not found");
        return 0;
      };
      case (_) {
        let newId = nextCompetitionId;
        nextCompetitionId += 1;
        let comp : Competition = {
          id = newId;
          title = title;
          description = description;
          organizer = organizer;
        };
        competitionMap.put(newId, comp);
        return newId;
      };
    };
  };

  // Join a competition
  public func joinCompetition(userId : UserId, compId : CompetitionId) : async Text {
    let userOpt = userMap.get(userId);
    let compOpt = competitionMap.get(compId);

    switch (userOpt, compOpt) {
      case (null, _) return "User not found.";
      case (_, null) return "Competition not found.";
      case (?user, ?_) {
        if (Array.find(user.joinedCompetitions, func x = x == compId) != null) {
          return "Already joined.";
        };
        let updatedUser = {
          name = user.name;
          joinedCompetitions = Array.append(user.joinedCompetitions, [compId]);
        };
        userMap.put(userId, updatedUser);
        return "Joined successfully.";
      };
    };
  };

  // Get user profile
  public query func getUserProfile(userId : UserId) : async ?User {
    userMap.get(userId)
  };

  // Get list of all competitions
  public query func listCompetitions() : async [Competition] {
    Iter.toArray(competitionMap.vals())
  };
};
