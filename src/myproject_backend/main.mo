// Import library dasar dari Motoko base
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
import Text "mo:base/Text";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";

actor {

  // ========================
  // === TYPE DEFINITIONS ===
  // ========================

  type UserId = Principal; // Setiap user diwakili oleh Principal
  type CompetitionId = Text; // ID kompetisi bertipe teks

  // Struktur user
  type User = {
    id : UserId;
    username : Text;
    password : Text;
    name : Text;
    bio : Text;
    profilePicUrl : Text; // URL pfp
    phoneNumber : Text;
    isOrganiser : Bool; // True jika user adalah organiser
    joinedCompetitions : [CompetitionId]; // Kompetisi yang diikuti
    ownedCompetitions : [CompetitionId]; // Kompetisi yang user selenggarakan
  };

  // Struktur gabungan user + kompetisi yang diikuti (untuk profile)
  type UserProfile = {
    user : User;
    competitions : [Competition]; // Kompetisi detail, bukan hanya ID
  };

  // Struktur kompetisi
  type Competition = {
    id : CompetitionId;
    name : Text;
    description : Text;
    organiser : UserId;
    participants : [UserId];

    // Attribute for filtering
    category : Text; // Hackathon, Data, UI/UX, Bussines Case, dll.
    tags : [Text];
    level : Text; //  SD, SMP, SMA, MAHASISWA, dll.
    location : Text;
    deadline : Nat; // Timestamp
    isFree : Bool;
    entryFee : Nat;
    maxParticipants : Nat;
    scope : CompetitionScope; // International, National, Province, City, Other
    status : CompetitionStatus; // Upcoming, Ongoing, Completed, Cancelled, Draft
    createdAt : Nat; // Timestamp
  };

  type CompetitionStatus = { #Upcoming } | { #Ongoing } | { #Completed } | { #Cancelled } | { #Draft };

  // province / state
  type CompetitionScope = { #International } | { #National } | { #Province } | { #City } | { #Other };

  // =================
  // === DATABASES ===
  // =================

  // Map user berdasarkan Username hanya untuk login dan register
  stable var usernameMap = HashMap.HashMap<Text, UserId>(0, Text.equal, Text.hash);

  // Map user berdasarkan ID
  stable var userMap = HashMap.HashMap<UserId, User>(0, Principal.equal, Principal.hash);

  // Map kompetisi berdasarkan ID teks
  stable var competitionMap = HashMap.HashMap<CompetitionId, Competition>(0, Text.equal, Text.hash);

  // Map to track which user is "logged in" (based on Principal)
  stable var loggedInMap = HashMap.HashMap<UserId, Bool>(0, Principal.equal, Principal.hash);

  // ====================================
  // === AUTHENTICATION & USER LOGIC  ===
  // ====================================

  // Fungsi untuk register user baru
  public func registerUser(username : Text, hashedPassword : Text, name : Text, bio : Text, isOrganiser : Bool, pfp : Text, phone : Text) : async Text {
    let caller = msg.caller;

    if (userMap.get(caller) != null) {
      return "User already registered.";
    };

    if (usernameMap.get(username) != null) {
      return "Username already taken.";
    };

    let newUser : User = {
      id = caller;
      username = username;
      password = hashedPassword;
      name = name;
      bio = bio;
      profilePicUrl = pfp;
      phoneNumber = phone;
      isOrganiser = isOrganiser;
      joinedCompetitions = [];
      ownedCompetitions = [];
    };

    userMap.put(caller, newUser);
    usernameMap.put(username, caller);

    return "User registered successfully.";
  };

  // Fungsi login
  public query func login(username : Text, hashedPassword : Text) : async Text {
    switch (usernameMap.get(username)) {
      case null return "Username not found.";
      case (?uid) {
        switch (userMap.get(uid)) {
          case null return "User data corrupted.";
          case (?user) {
            if (user.password == hashedPassword) {
              loggedInMap.put(uid, true);
              return "Login successful.";
            } else {
              return "Incorrect password.";
            };
          };
        };
      };
    };
  };

  public func logout() : async Text {
    let caller = msg.caller;

    if (loggedInMap.get(caller) == null or loggedInMap.get(caller) == ?false) {
      return "User not logged in.";
    };

    loggedInMap.put(caller, false);
    return "Logout successful.";
  };

  public query func getLoggedInUser() : async ?User {
    let caller = msg.caller;
    return userMap.get(caller);
  };

  public query func isLoggedIn() : async Bool {
    let caller = msg.caller;
    return loggedInMap.get(caller) == ?true;
  };

  // User update profile, kalau ada yang tidak diubah gunakan null
  public func updateUserProfile(nameOpt : ?Text, bioOpt : ?Text, pfpOpt : ?Text, phoneOpt : ?Text) : async Text {
    let caller = msg.caller;

    switch (userMap.get(caller)) {
      case null return "User not registered.";
      case (?user) {
        let newName = switch nameOpt { case (null) user.name; case (?n) n };
        let newBio = switch bioOpt { case (null) user.bio; case (?b) b };
        let newPic = switch pfpOpt {
          case (null) user.profilePicUrl;
          case (?p) p;
        };
        let newPhone = switch phoneOpt {
          case (null) user.phoneNumber;
          case (?ph) ph;
        };

        if (
          newName == user.name and
          newBio == user.bio and
          newPic == user.profilePicUrl and
          newPhone == user.phoneNumber
        ) {
          return "Nothing to update.";
        };

        let updatedUser : User = {
          id = user.id;
          username = user.username;
          password = user.password;
          name = newName;
          bio = newBio;
          profilePicUrl = newPic;
          phoneNumber = newPhone;
          isOrganiser = user.isOrganiser;
          joinedCompetitions = user.joinedCompetitions;
          ownedCompetitions = user.ownedCompetitions;
        };

        userMap.put(caller, updatedUser);
        return "Profile updated.";
      };
    };
  };

  // Update password user
  public func updatePassword(oldPassword : Text, newPassword : Text) : async Text {
    let caller = msg.caller;

    switch (userMap.get(caller)) {
      case null return "User not registered.";
      case (?user) {
        if (user.password != oldPassword) {
          return "Incorrect old password.";
        };

        let updatedUser : User = {
          id = user.id;
          username = user.username;
          password = newPassword;
          name = user.name;
          bio = user.bio;
          profilePicUrl = user.profilePicUrl;
          phoneNumber = user.phoneNumber;
          isOrganiser = user.isOrganiser;
          joinedCompetitions = user.joinedCompetitions;
          ownedCompetitions = user.ownedCompetitions;
        };

        userMap.put(caller, updatedUser);
        return "Password updated successfully.";
      };
    };
  };

  // ==============================
  // === COMPETITION MANAGEMENT ===
  // ==============================

  // Fungsi untuk membuat kompetisi (khusus organiser)
  public func createCompetition(
    id : Text,
    name : Text,
    desc : Text,
    category : Text,
    tags : [Text],
    level : Text,
    location : Text,
    deadline : Nat,
    isFree : Bool,
    entryFee : Nat,
    maxParticipants : Nat,
    scope : CompetitionScope,
    status : CompetitionStatus,
  ) : async Text {
    let caller = msg.caller;

    switch (userMap.get(caller)) {
      case null return "User not registered.";
      case (?user) {
        if (! user.isOrganiser) return "Only organisers can create competitions.";
        if (competitionMap.get(id) != null) return "Competition ID already exists.";

        let newComp : Competition = {
          id = id;
          name = name;
          description = desc;
          organiser = caller;
          participants = [];
          category = category;
          tags = tags;
          level = level;
          location = location;
          deadline = deadline;
          isFree = isFree;
          entryFee = entryFee;
          maxParticipants = maxParticipants;
          scope = scope;
          status = status;
          createdAt = Nat64.toNat(Nat64.fromIntWrap(Time.now()));
        };

        competitionMap.put(id, newComp);

        let updatedUser = {
          id = user.id;
          username = user.username;
          password = user.password;
          name = user.name;
          bio = user.bio;
          profilePicUrl = user.profilePicUrl;
          phoneNumber = user.phoneNumber;
          isOrganiser = user.isOrganiser;
          joinedCompetitions = user.joinedCompetitions;
          ownedCompetitions = Array.append(user.ownedCompetitions, [id]);
        };

        userMap.put(caller, updatedUser);

        return "Competition created.";
      };
    };
  };

  public func updateCompetition(compId : CompetitionId, nameOpt : ?Text, descOpt : ?Text) : async Text {
    let caller = msg.caller;

    switch (competitionMap.get(compId)) {
      case null return "Competition not found.";
      case (?comp) {
        if (comp.organiser != caller) {
          return "Unauthorized. Only the organiser can update this competition.";
        };

        let updatedComp : Competition = {
          id = comp.id;
          name = switch (nameOpt) { case (?n) n; case null comp.name };
          description = switch (descOpt) {
            case (?d) d;
            case null comp.description;
          };
          organiser = comp.organiser;
          participants = comp.participants;
          category = comp.category;
          tags = comp.tags;
          level = comp.level;
          location = comp.location;
          deadline = comp.deadline;
          isFree = comp.isFree;
          entryFee = comp.entryFee;
          maxParticipants = comp.maxParticipants;
          scope = comp.scope;
          status = comp.status;
          createdAt = comp.createdAt;
        };

        competitionMap.put(compId, updatedComp);
        return "Competition updated.";
      };
    };
  };

  // Kick participant dari competition (organiser function)
  public func kickParticipant(compId : CompetitionId, target : UserId) : async Text {
    let caller = msg.caller;

    switch (competitionMap.get(compId)) {
      case null return "Competition not found.";
      case (?comp) {
        if (comp.organiser != caller) {
          return "Only the organiser can kick participants.";
        };

        if (! Iter.contains<UserId>(comp.participants.vals(), target, Principal.equal)) {
          return "User is not a participant.";
        };

        // Hapus target dari list participant
        let newParticipants = Array.filter<UserId>(
          comp.participants,
          func(p) { p != target },
        );

        let updatedComp : Competition = {
          id = comp.id;
          name = comp.name;
          description = comp.description;
          organiser = comp.organiser;
          participants = newParticipants;
          category = comp.category;
          tags = comp.tags;
          level = comp.level;
          location = comp.location;
          deadline = comp.deadline;
          isFree = comp.isFree;
          entryFee = comp.entryFee;
          maxParticipants = comp.maxParticipants;
          scope = comp.scope;
          status = comp.status;
          createdAt = comp.createdAt;
        };

        competitionMap.put(compId, updatedComp);

        // Hapus competition dari joinedCompetitions milik user
        switch (userMap.get(target)) {
          case null {};
          case (?user) {
            let updatedUser = {
              id = user.id;
              username = user.username;
              password = user.password;
              name = user.name;
              bio = user.bio;
              profilePicUrl = user.profilePicUrl;
              phoneNumber = user.phoneNumber;
              isOrganiser = user.isOrganiser;
              joinedCompetitions = Array.filter<CompetitionId>(
                user.joinedCompetitions,
                func(c) { c != compId },
              );
              ownedCompetitions = user.ownedCompetitions;
            };
            userMap.put(target, updatedUser);
          };
        };

        return "User has been removed from the competition.";
      };
    };
  };

  // Hapus kompetisi jika caller adalah organiser-nya
  public func deleteCompetition(compId : CompetitionId) : async Text {
    let caller = msg.caller;

    switch (competitionMap.get(compId)) {
      case null return "Competition not found.";
      case (?comp) {
        if (comp.organiser != caller) {
          return "Unauthorized. Only the organiser can delete this competition.";
        };

        // Hapus ID kompetisi dari semua peserta
        for (pid in comp.participants.vals()) {
          switch (userMap.get(pid)) {
            case (?user) {
              let updatedUser : User = {
                id = user.id;
                username = user.username;
                password = user.password;
                name = user.name;
                bio = user.bio;
                profilePicUrl = user.profilePicUrl;
                phoneNumber = user.phoneNumber;
                isOrganiser = user.isOrganiser;
                joinedCompetitions = Array.filter<CompetitionId>(
                  user.joinedCompetitions,
                  func(c) { c != compId },
                );
                ownedCompetitions = user.ownedCompetitions;
              };
              userMap.put(pid, updatedUser);
            };
            case null {};
          };
        };

        // Hapus ID kompetisi dari organiser
        switch (userMap.get(caller)) {
          case (?organiser) {
            let updatedOrganiser = {
              id = organiser.id;
              username = organiser.username;
              password = organiser.password;
              name = organiser.name;
              bio = organiser.bio;
              profilePicUrl = organiser.profilePicUrl;
              phoneNumber = organiser.phoneNumber;
              isOrganiser = organiser.isOrganiser;
              joinedCompetitions = organiser.joinedCompetitions;
              ownedCompetitions = Array.filter<CompetitionId>(
                organiser.ownedCompetitions,
                func(c) { c != compId },
              );
            };
            userMap.put(caller, updatedOrganiser);
          };
          case null {}; // Tidak mungkin jika valid
        };

        // Hapus kompetisinya dari map
        competitionMap.delete(compId);
        return "Competition deleted.";
      };
    };
  };

  // ===========================
  // === PARTICIPATION LOGIC ===
  // ===========================

  // Fungsi user untuk join kompetisi
  public func joinCompetition(compId : CompetitionId) : async Text {
    let caller = msg.caller;

    switch (userMap.get(caller)) {
      case null return "User not registered.";
      case (?user) {
        switch (competitionMap.get(compId)) {
          case null return "Competition not found.";
          case (?comp) {
            if (Iter.contains<UserId>(comp.participants.vals(), caller, Principal.equal)) {
              return "Already joined.";
            };

            if (Array.size(comp.participants) >= comp.maxParticipants) {
              return "Participant limit reached.";
            };

            let now : Nat =
              Nat64.toNat(Nat64.fromIntWrap(Time.now() / (1_000_000_000 : Int)));

            if (now > comp.deadline) {
              return "Registration deadline has passed.";
            };

            let updatedUser = {
              id = user.id;
              username = user.username;
              password = user.password;
              name = user.name;
              bio = user.bio;
              profilePicUrl = user.profilePicUrl;
              phoneNumber = user.phoneNumber;
              isOrganiser = user.isOrganiser;
              joinedCompetitions = Array.append(user.joinedCompetitions, [compId]);
              ownedCompetitions = user.ownedCompetitions;
            };
            userMap.put(caller, updatedUser);

            let updatedComp = {
              id = comp.id;
              name = comp.name;
              description = comp.description;
              organiser = comp.organiser;
              participants = Array.append(comp.participants, [caller]);
              category = comp.category;
              tags = comp.tags;
              level = comp.level;
              location = comp.location;
              deadline = comp.deadline;
              isFree = comp.isFree;
              entryFee = comp.entryFee;
              maxParticipants = comp.maxParticipants;
              scope = comp.scope;
              status = comp.status;
              createdAt = comp.createdAt;
            };
            competitionMap.put(compId, updatedComp);

            return "Joined competition.";
          };
        };
      };
    };
  };

  // User keluar dari kompetisi
  public func unjoinCompetition(compId : CompetitionId) : async Text {
    let caller = msg.caller;

    switch (userMap.get(caller)) {
      case null return "User not registered.";
      case (?user) {
        switch (competitionMap.get(compId)) {
          case null return "Competition not found.";
          case (?comp) {
            if (! Iter.contains<Principal>(comp.participants.vals(), caller, Principal.equal)) {
              return "You are not a participant of this competition.";
            };

            // Update user
            let updatedUser = {
              id = user.id;
              username = user.username;
              password = user.password;
              name = user.name;
              bio = user.bio;
              profilePicUrl = user.profilePicUrl;
              phoneNumber = user.phoneNumber;
              isOrganiser = user.isOrganiser;
              joinedCompetitions = Array.filter<Text>(user.joinedCompetitions, func(c) { c != compId });
              ownedCompetitions = user.ownedCompetitions;
            };

            userMap.put(caller, updatedUser);

            // Update competition — FULL RECORD REQUIRED
            let updatedComp : Competition = {
              id = comp.id;
              name = comp.name;
              description = comp.description;
              organiser = comp.organiser;
              participants = Array.filter<Principal>(comp.participants, func(p) { p != caller });
              category = comp.category;
              tags = comp.tags;
              level = comp.level;
              location = comp.location;
              deadline = comp.deadline;
              isFree = comp.isFree;
              entryFee = comp.entryFee;
              maxParticipants = comp.maxParticipants;
              scope = comp.scope;
              status = comp.status;
              createdAt = comp.createdAt;
            };

            competitionMap.put(compId, updatedComp);

            return "You have unjoined the competition.";
          };
        };
      };
    };
  };

  // =======================
  // === QUERY FUNCTIONS ===
  // =======================

  // Ambil data user berdasarkan ID
  public query func getUser(id : UserId) : async ?User {
    return userMap.get(id);
  };

  // Ambil data lengkap user + daftar kompetisinya
  public query func getUserWithCompetitions(id : UserId) : async ?UserProfile {
    let userOpt = userMap.get(id);

    switch (userOpt) {
      case (null) { return null };
      case (?user) {
        let comps = Array.filterMap<CompetitionId, Competition>(
          user.joinedCompetitions,
          func(compId) {
            competitionMap.get(compId);
          },
        );

        return ?{
          user = user;
          competitions = comps;
        };
      };
    };
  };

  // Ambil detail kompetisi
  public query func getCompetitionDetail(compId : CompetitionId) : async ?Competition {
    return competitionMap.get(compId);
  };

  // Ambil daftar kompetisi yang diikuti oleh user tertentu
  public query func getCompetitionsByUser(userId : UserId) : async [Competition] {
    switch (userMap.get(userId)) {
      case (?user) {
        let comps = user.joinedCompetitions;
        return Array.filterMap<CompetitionId, Competition>(
          comps,
          func(id) {
            competitionMap.get(id);
          },
        );
      };
      case null return [];
    };
  };

  // Organiser bisa melihat peserta kompetisinya
  public query func getParticipantsOfCompetition(compId : CompetitionId) : async [User] {
    switch (competitionMap.get(compId)) {
      case (null) return [];
      case (?comp) {
        // Ambil semua user dari daftar principal
        return Array.filterMap<UserId, User>(
          comp.participants,
          func(pid) {
            userMap.get(pid);
          },
        );
      };
    };
  };

  // Cek jika user sudah join kompetisi atau belum
  public query func hasJoined(compId : CompetitionId) : async Bool {
    let caller = msg.caller;
    switch (userMap.get(caller)) {
      case (?user) {
        return Array.contains(user.joinedCompetitions, compId, func(a, b) { a == b });
      };
      case null return false;
    };
  };

  // Cek jika user sudah register atau belum
  public query func isUserRegistered() : async Bool {
    let caller = msg.caller;
    return userMap.get(caller) != null;
  };

  // Return semua kompetisi yang ada di sistem
  public query func getAllCompetitions() : async [Competition] {
    return Iter.toArray(competitionMap.vals());
  };

  // Return semua kompetisi yang diselenggarakan user
  public query func getOwnedCompetitions(userId : UserId) : async [Competition] {
    switch (userMap.get(userId)) {
      case (?user) {
        return Array.filterMap<CompetitionId, Competition>(
          user.ownedCompetitions,
          func(cid) { competitionMap.get(cid) },
        );
      };
      case null return [];
    };
  };

  // Search competitions by keyword (dari nama / description) and filter
  public query func searchCompetitions(
    keyword : ?Text,
    filter : CompetitionFilter,
  ) : async [Competition] {
    return Iter.toArray(
      Iter.filter<Competition>(
        competitionMap.vals(),
        func(comp) : Bool {
          let matchesKeyword = switch (keyword) {
            case null true;
            case (?k) {
              let kLower = Text.toLowercase(k);
              let nameMatch = Text.contains(Text.toLowercase(comp.name), kLower);
              let descMatch = Text.contains(Text.toLowercase(comp.description), kLower);
              nameMatch or descMatch;
            };
          };

          let matchesCategory = switch (filter.category) {
            case null true;
            case (?c) comp.category == c;
          };

          let matchesLevel = switch (filter.level) {
            case null true;
            case (?l) comp.level == l;
          };

          let matchesLocation = switch (filter.location) {
            case null true;
            case (?loc) comp.location == loc;
          };

          let matchesIsFree = switch (filter.isFree) {
            case null true;
            case (?f) comp.isFree == f;
          };

          let matchesScope = switch (filter.scope) {
            case null true;
            case (?s) comp.scope == s;
          };

          let matchesStatus = switch (filter.status) {
            case null true;
            case (?st) comp.status == st;
          };

          return matchesKeyword and matchesCategory and matchesLevel and matchesLocation and matchesIsFree and matchesScope and matchesStatus;
        },
      )
    );
  };

  type CompetitionFilter = {
    category : ?Text;
    level : ?Text;
    location : ?Text;
    isFree : ?Bool;
    scope : ?CompetitionScope;
    status : ?CompetitionStatus;
  };

  // =======================
  // === Admin / Testing ===
  // =======================

  public func deleteUser() : async Text {
    let caller = msg.caller;

    switch (userMap.get(caller)) {
      case null return "User not registered.";
      case (?user) {
        // Hapus user dari semua kompetisi yang ia ikuti
        for (compId in user.joinedCompetitions.vals()) {
          switch (competitionMap.get(compId)) {
            case (?comp) {
              let updatedComp : Competition = {
                id = comp.id;
                name = comp.name;
                description = comp.description;
                organiser = comp.organiser;
                participants = Array.filter<UserId>(comp.participants, func(p) { p != caller });
                category = comp.category;
                tags = comp.tags;
                level = comp.level;
                location = comp.location;
                deadline = comp.deadline;
                isFree = comp.isFree;
                entryFee = comp.entryFee;
                maxParticipants = comp.maxParticipants;
                scope = comp.scope;
                status = comp.status;
                createdAt = comp.createdAt;
              };
              competitionMap.put(compId, updatedComp);
            };
            case null {};
          };
        };

        // Hapus semua kompetisi yang diselenggarakan user ini
        for (cid in user.ownedCompetitions.vals()) {
          ignore deleteCompetition(cid);
        };

        // Hapus dari usernameMap, userMap, dan loggedInMap
        usernameMap.delete(user.username);
        userMap.delete(caller);
        loggedInMap.delete(caller);

        return "User deleted.";
      };
    };
  };

  // Return semua user
  public query func getAllUsers() : async [User] {
    return Iter.toArray(userMap.vals());
  };

  public query func getSystemStats() : async {
    userCount : Nat;
    competitionCount : Nat;
  } {
    return {
      userCount = Nat.fromIter(userMap.keys());
      competitionCount = Nat.fromIter(competitionMap.keys());
    };
  }

};
