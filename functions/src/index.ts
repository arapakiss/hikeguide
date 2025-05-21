import {onCall} from "firebase-functions/v2/https";
import * as admin from "firebase-admin";

admin.initializeApp();

export const revokeUserTokens = onCall(async (request) => {
  const {auth} = request;

  if (!auth || !auth.uid) {
    throw new Error("Authentication Required");
  }

  await admin.auth().revokeRefreshTokens(auth.uid);

  return {message: "All sessions revoked successfully."};
});
