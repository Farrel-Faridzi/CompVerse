// Import library dasar dari Motoko base
import Nat "mo:base/Nat";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";

actor {

  // =======================
  // === TYPE DEFINITIONS ===
  // =======================

  type UserId = Principal;              // Setiap user diwakili oleh Principal
  type CompetitionId = Text;            // ID kompetisi bertipe teks

  // Struktur user
  type User = {
    id: UserId;
    name: Text;
    bio: Text;
    joinedCompetitions: [CompetitionId];  // Menyimpan daftar ID kompetisi yang diikuti
    isOrganiser: Bool;                    // True jika user adalah organiser
  };

  // Struktur gabungan user + kompetisi yang diikuti (untuk profile)
  type UserProfile = {
    user: User;
    competitions: [Competition]; // Kompetisi detail, bukan hanya ID
  };

  // Struktur kompetisi
  type Competition = {
    id: CompetitionId;
    name: Text;
    description: Text;
    organiser: UserId;
    participants: [UserId];
  };

  // ===================
  // === DATABASES ===
  // ===================

  // Map user berdasarkan ID
  stable var userMap = HashMap.HashMap<UserId, User>(0, Principal.equal, Principal.hash);

  // Map kompetisi berdasarkan ID teks
  stable var competitionMap = HashMap.HashMap<CompetitionId, Competition>(0, Text.equal, Text.hash);

  // ================================
  // === REGISTER & CREATE LOGIC ===
  // ================================

  // Fungsi untuk register user baru
  public func registerUser(name: Text, bio: Text, isOrganiser: Bool): async Text {
    let caller = Principal.fromActor(this); // Ambil Principal pemanggil

    if (userMap.get(caller) != null) {
      return "User already registered.";
    };

    userMap.put(caller, {
      id = caller;
      name = name;
      bio = bio;
      isOrganiser = isOrganiser;
      joinedCompetitions = [];
    });

    return "User registered successfully."
  }

  // Fungsi untuk membuat kompetisi (khusus organiser)
  public func createCompetition(id: Text, name: Text, desc: Text): async Text {
    let caller = Principal.fromActor(this);

    switch (userMap.get(caller)) {
      case (null) return "User not registered.";
      case (?user) {
        if (!user.isOrganiser) return "Only organisers can create competitions.";
        if (competitionMap.get(id) != null) return "Competition ID already exists.";

        let comp: Competition = {
          id = id;
          name = name;
          description = desc;
          organiser = caller;
          participants = [];
        };
        competitionMap.put(id, comp);
        return "Competition created.";
      }
    }
  }

// Hapus kompetisi jika caller adalah organiser-nya
  public func deleteCompetition(compId: CompetitionId): async Text {
    let caller = Principal.fromActor(this);
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
              let updatedUser = {
                id = user.id;
                name = user.name;
                bio = user.bio;
                isOrganiser = user.isOrganiser;
                joinedCompetitions = Array.filter<Text>(
                  user.joinedCompetitions,
                  func(c) { c != compId }
                );
              };
              userMap.put(pid, updatedUser);
            };
            case null {};
          }
        };

        // Hapus kompetisinya
        competitionMap.delete(compId);
        return "Competition deleted.";
      }
    }
  }

  // ===========================
  // === PARTICIPATION LOGIC ===
  // ===========================

  // Fungsi user untuk join kompetisi
  public func joinCompetition(id: Text): async Text {
    let caller = Principal.fromActor(this);

    switch (userMap.get(caller)) {
      case (null) return "User not registered.";
      case (?user) {
        switch (competitionMap.get(id)) {
          case (null) return "Competition not found.";
          case (?comp) {
            // Cek apakah sudah join
            if (Iter.contains<UserId>(comp.participants.vals(), caller, Principal.equal)) {
              return "Already joined.";
            };

            // Update user
            let updatedUser = {
              id = caller;
              name = user.name;
              bio = user.bio;
              isOrganiser = user.isOrganiser;
              joinedCompetitions = Array.append(user.joinedCompetitions, [id]);
            };
            userMap.put(caller, updatedUser);

            // Update kompetisi
            let updatedComp = {
              id = comp.id;
              name = comp.name;
              description = comp.description;
              organiser = comp.organiser;
              participants = Array.append(comp.participants, [caller]);
            };
            competitionMap.put(id, updatedComp);

            return "Successfully joined.";
          }
        }
      }
    }
  }

  // User keluar dari kompetisi
  public func unjoinCompetition(compId: CompetitionId): async Text {
    let caller = Principal.fromActor(this);

    switch (userMap.get(caller)) {
      case null return "User not registered.";
      case (?user) {
        switch (competitionMap.get(compId)) {
          case null return "Competition not found.";
          case (?comp) {
            if (!Iter.contains<Principal>(comp.participants.vals(), caller, Principal.equal)) {
              return "You are not a participant of this competition.";
            };

            // Update user
            let updatedUser = {
              id = user.id;
              name = user.name;
              bio = user.bio;
              isOrganiser = user.isOrganiser;
              joinedCompetitions = Array.filter<Text>(
                user.joinedCompetitions,
                func(c) { c != compId }
              );
            };
            userMap.put(caller, updatedUser);

            // Update competition
            let updatedComp = {
              id = comp.id;
              name = comp.name;
              description = comp.description;
              organiser = comp.organiser;
              participants = Array.filter<Principal>(
                comp.participants,
                func(p) { p != caller }
              );
            };
            competitionMap.put(compId, updatedComp);

            return "You have unjoined the competition.";
          }
        }
      }
    }
  }

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
          func (compId) {
            competitionMap.get(compId)
          }
        );

        return ?{
          user = user;
          competitions = comps;
        };
      };
    };
  }

  // Ambil detail kompetisi
  public query func getCompetitionDetail(compId: CompetitionId): async ?Competition {
    return competitionMap.get(compId);
  }

  // Ambil daftar kompetisi yang diikuti oleh user tertentu
  public query func getCompetitionsByUser(userId: UserId): async [Competition] {
    switch (userMap.get(userId)) {
      case (?user) {
        let comps = user.joinedCompetitions;
        return Array.filterMap<CompetitionId, Competition>(comps, func(id) {
          competitionMap.get(id);
        });
      };
      case null return [];
    }
  }

// Organiser bisa melihat peserta kompetisinya
public query func getParticipantsOfCompetition(compId: CompetitionId): async [User] {
  switch (competitionMap.get(compId)) {
    case (null) return [];
    case (?comp) {
      // Ambil semua user dari daftar principal
      return Array.filterMap<UserId, User>(comp.participants, func (pid) {
        userMap.get(pid);
      });
    }
  }
}





}
