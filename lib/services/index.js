//for checking last seen and online activity

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.updateUserPresence = functions.firestore
  .document('users/{userId}')
  .onUpdate((change, context) => {
    const newData = change.after.data();
    const previousData = change.before.data();

    if (newData.isOnline !== previousData.isOnline) {
      // User presence changed, update lastSeen timestamp
      if (newData.isOnline) {
        // User is online, set lastSeen to null or remove it
        return change.after.ref.update({ lastSeen: null });
      } else {
        // User is offline, update lastSeen to current timestamp
        return change.after.ref.update({ lastSeen: admin.firestore.FieldValue.serverTimestamp() });
      }
    }

    return null;
  });
