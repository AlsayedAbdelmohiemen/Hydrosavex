import os
import firebase_admin
from firebase_admin import credentials, firestore
from google.cloud.firestore_v1 import SERVER_TIMESTAMP

def main():
    cred_path = os.path.join(os.path.dirname(__file__), "drowning-detection-main-firebase-adminsdk-jr5nn-21062399ce.json")
    cred = credentials.Certificate(cred_path)
    firebase_admin.initialize_app(cred)
    db = firestore.client()

    print("Checking users in Firestore...")
    users = list(db.collection("users").stream())
    target_org_codes = set()
    for u in users:
        data = u.to_dict()
        role = data.get("role", "")
        org_code = data.get("orgCode") or data.get("orgId") or ""
        email = data.get("email", "")
        print(f"User: {email} | Role: {role} | OrgCode: {org_code}")
        if role == "lifeguard" and org_code:
            target_org_codes.add(str(org_code))

    # Also add the hardcoded one from final.py if none found or in addition
    default_org = "73311724355540472"
    if not target_org_codes:
        target_org_codes.add(default_org)
    else:
        target_org_codes.add(default_org)

    for org in target_org_codes:
        text = "Alert: Possible drowning detected! (Test Notification from final.py)"
        doc_ref = db.collection("lifeguardnotifications").add({
            "orgID": org,
            "orgId": org,
            "sent": False,
            "text": text,
            "date": SERVER_TIMESTAMP
        })
        print(f"Successfully sent Lifeguard Notification to org '{org}'! Doc ID: {doc_ref[1].id}")

if __name__ == "__main__":
    main()
