Rest request for something similar
```
POST https://www.googleapis.com/compute/v1/projects/bentoml-316710/zones/us-central1-a/instances
{
  "canIpForward": false,
  "confidentialInstanceConfig": {
    "enableConfidentialCompute": false
  },
  "deletionProtection": false,
  "description": "",
  "disks": [
    {
      "autoDelete": true,
      "boot": true,
      "deviceName": "instancetest-1",
      "initializeParams": {
        "diskSizeGb": "10",
        "diskType": "projects/bentoml-316710/zones/us-central1-a/diskTypes/pd-balanced",
        "labels": {},
        "sourceImage": "projects/cos-cloud/global/images/cos-stable-97-16919-29-21"
      },
      "mode": "READ_WRITE",
      "type": "PERSISTENT"
    }
  ],
  "displayDevice": {
    "enableDisplay": false
  },
  "guestAccelerators": [],
  "keyRevocationActionType": "NONE",
  "labels": {
    "container-vm": "cos-stable-97-16919-29-21"
  },
  "machineType": "projects/bentoml-316710/zones/us-central1-a/machineTypes/e2-micro",
  "metadata": {
    "items": [
      {
        "key": "gce-container-declaration",
        "value": "spec:\n  containers:\n  - name: instancetest-1\n    image: gcr.io/bentoml-316710/test-google-cloud-run/test-google-cloud-run\n    stdin: false\n    tty: false\n  restartPolicy: Always\n# This container declaration format is not public API and may change without notice. Please\n# use gcloud command-line tool or Google Cloud Console to run Containers on Google Compute Engine."
      }
    ]
  },
  "name": "instancetest-1",
  "networkInterfaces": [
    {
      "accessConfigs": [
        {
          "name": "External NAT",
          "networkTier": "PREMIUM"
        }
      ],
      "stackType": "IPV4_ONLY",
      "subnetwork": "projects/bentoml-316710/regions/us-central1/subnetworks/default"
    }
  ],
  "reservationAffinity": {
    "consumeReservationType": "ANY_RESERVATION"
  },
  "scheduling": {
    "automaticRestart": true,
    "onHostMaintenance": "MIGRATE",
    "provisioningModel": "STANDARD"
  },
  "serviceAccounts": [
    {
      "email": "558210432501-compute@developer.gserviceaccount.com",
      "scopes": [
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring.write",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/trace.append"
      ]
    }
  ],
  "shieldedInstanceConfig": {
    "enableIntegrityMonitoring": true,
    "enableSecureBoot": false,
    "enableVtpm": true
  },
  "tags": {
    "items": [
      "http-server"
    ]
  },
  "zone": "projects/bentoml-316710/zones/us-central1-a"
}
```
