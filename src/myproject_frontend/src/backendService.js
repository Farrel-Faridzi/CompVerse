import { Actor, HttpAgent } from "@dfinity/agent";
import { idlFactory as backend_idl, canisterId as backend_id } from "../../../declarations/myproject_backend";

// Buat agent HTTP
const agent = new HttpAgent();

// Untuk development lokal:
if (process.env.DFX_NETWORK === "local") {
  agent.fetchRootKey(); // Hanya untuk dev
}

// Buat actor
const backend = Actor.createActor(backend_idl, {
  agent,
  canisterId: backend_id,
});

export default backend;
