"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
admin.initializeApp();
exports.alarmnotifiction = functions.firestore
  .document('lifeguardnotifications/{lifeguardnotifications}')
  .onCreate((snapshot, context) => {
      console.log(snapshot.data().orgID+snapshot.data().role)
    return admin.messaging().sendToTopic(snapshot.data().orgID+snapshot.data().sentTO, {
      notification: {
        title: 'Alarm',
        body: snapshot.data().text,
        "sound": "defualt",


      },
    });

  });


exports.delaynotification = functions.firestore
  .document('lifeguardnotifications/{lifeguardnotifications}')
  .onCreate((snapshot, context) => {
    //   console.log(snapshot.data().orgID+snapshot.data().role)
      var id=snapshot.id;
      setTimeout(

        delay
       ,20000);
function delay (){
    admin.firestore().collection('lifeguardnotifications').doc(''+ id).get().then(function(doc) {
        const data = doc.data();
        +new Date();
         if(data)
         {

             data.orgID;
             data.sent;
             if(!data.sent){
             admin.firestore().collection('lifeguardreports').doc().set({
                 comment:'automated lifeguard report',
                 date:admin.firestore.Timestamp.fromDate(new Date),
                 orgID:data.orgID,
                 sent:false,
                 sentTO:'medic',
                 type:'Get Ambulance'




             })
           }
             console.log(data.orgID);
         }
       //   snapshot.data().orgID;


     });

}


  });

exports.medicNotification = functions.firestore
  .document('lifeguardreports/{lifeguardReports}')
  .onCreate((snapshot, context) => {
      console.log(snapshot.data().orgID+snapshot.data().role)
    return admin.messaging().sendToTopic(snapshot.data().orgID+snapshot.data().sentTO, {
      notification: {
        title: snapshot.data().type,
        body: snapshot.data().comment,
        "sound": "defualt",


      },
    });
  });

  exports.orgNotification = functions.firestore
  .document('medicreports/{medicreports}')
  .onCreate((snapshot, context) => {
      console.log(snapshot.data().orgID+snapshot.data().sentTO)
    return admin.messaging().sendToTopic(snapshot.data().orgID+snapshot.data().sentTO, {
      notification: {
        title: 'Report',
        body: snapshot.data().comment,
        sound: "defualt",

      },
    });
  });